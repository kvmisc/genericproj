//
//  XYZHTTPDownloader.m
//  GenericProj
//
//  Created by Kevin Wu on 11/03/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "XYZHTTPDownloader.h"

@interface XYZHTTPDownloader () <
    NSURLSessionDelegate
>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, copy) NSIndexSet *acceptableStatusCodes;
@property (nonatomic, assign) BOOL responseAcceptable; // 返回出错时不向磁盘写数据

@property (nonatomic, strong) NSFileHandle *temporaryFileHandle;
@property (nonatomic, assign) NSUInteger downloadedSize;

@end

@implementation XYZHTTPDownloader

#ifdef DEBUG
- (void)dealloc { XYZPrintMethod(); }
#endif

- (void)start:(void (^)(XYZHTTPDownloader *downloader, NSError *error))completionHandler
{
  self.completionHandler = completionHandler;

  // 取消上次的请求
  if ( _task ) {
    [_task cancel];
    _task = nil;
  }
  // 清除上次的返回出错标志
  _acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
  _responseAcceptable = NO;
  // 关闭上次的临时文件句柄
  if ( _temporaryFileHandle ) {
    [_temporaryFileHandle synchronizeFile];
    [_temporaryFileHandle closeFile];
    _temporaryFileHandle = nil;
  }

  // 如果不是断点续传，删除临时文件
  if ( !_enableBrokenDownload ) {
    [[NSFileManager defaultManager] removeItemAtPath:_temporaryFile error:NULL];
  }
  // 断点续传的时候，已经下载的文件大小
  if ( _enableBrokenDownload ) {
    _downloadedSize = (NSUInteger)[[[NSFileManager defaultManager] attributesOfItemAtPath:_temporaryFile error:NULL] fileSize];
  } else {
    _downloadedSize = 0;
  }

  // 创建 request
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_address]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:10.0];
  request.HTTPMethod = @"GET";

  // 添加断点续传头
  if ( (_enableBrokenDownload) && (_downloadedSize>0) ) {
    NSString *range = [NSString stringWithFormat:@"bytes=%lu-", (unsigned long)_downloadedSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
  }


  // 开始下载任务
  if ( !_session ) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
  }
  _task = [_session dataTaskWithRequest:request];
  [_task resume];
}

- (void)stop
{
  _completionHandler = NULL;
  [_task cancel];
  _task = nil;
}


- (void)invalidateSession
{
  [_session invalidateAndCancel];
  _session = nil;
}


- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
  XYZLog(@"%s %@", sel_getName(_cmd), response);

  _response = response;
  // 可接受的状态码为空，表示接受所有的状态码，可接受；
  // 可接受的状态码非空，且包含当前返回的状态码，可接受；
  _responseAcceptable = ( (!_acceptableStatusCodes) || [_acceptableStatusCodes containsIndex:(NSUInteger)[(NSHTTPURLResponse *)response statusCode]] );

  if ( completionHandler ) {
    completionHandler(NSURLSessionResponseAllow);
  }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
  XYZLog(@"%s %lu", sel_getName(_cmd), (unsigned long)[data length]);

  if ( _responseAcceptable ) {

    // 创建临时文件
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:_temporaryFile] ) {
      [[NSFileManager defaultManager] createFileAtPath:_temporaryFile contents:nil attributes:nil];
    }
    // 创建临时文件句柄
    if ( !_temporaryFileHandle ) {
      _temporaryFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_temporaryFile];
    }

    [_temporaryFileHandle seekToEndOfFile];
    [_temporaryFileHandle writeData:data];

    NSProgress *progress = [NSProgress progressWithTotalUnitCount:dataTask.countOfBytesExpectedToReceive+_downloadedSize];
    progress.completedUnitCount = dataTask.countOfBytesReceived+_downloadedSize;

    [self setUpProgressAndSpeed:progress];

    if ( _fractionHandler ) {
      _fractionHandler(self);
    }
  }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
  XYZLog(@"%s %@", sel_getName(_cmd), error);

  [_temporaryFileHandle synchronizeFile];
  [_temporaryFileHandle closeFile];
  _temporaryFileHandle = nil;

  if ( error ) {
    _error = error;
  } else {
    if ( _responseAcceptable ) {
      _error = nil;
    } else {
      _error = [[NSError alloc] initWithDomain:XYZ_ERROR_DOMAIN_HTTP
                                          code:[(NSHTTPURLResponse *)_response statusCode]
                                      userInfo:@{NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"请求出错", @"")}];
    }
  }

  if ( _completionHandler ) {
    _completionHandler(self, _error);
  }

  _task = nil;
}


- (void)setUpProgressAndSpeed:(NSProgress *)progress
{
  if ( !_progress ) {
    XYZLog(@"[down][%p][progress] old[nil]: 0/0, new[%p]: %lld/%lld", self, progress, progress.completedUnitCount, progress.totalUnitCount);
    // 前一个进度为空，不能算出速度，速度为 0
    _speed = 0;
    _progress = progress;
    _progress.tk_theInfo = [NSDate date];
  } else {
    if ( !progress ) {
      XYZLog(@"[down][%p][progress] old[%p]: %lld/%lld, new[nil]: 0/0", self, _progress, _progress.completedUnitCount, _progress.totalUnitCount);
      // 进度为空，应该是下载结束，速度为 0
      _speed = 0;
      _progress = nil;
    } else {
      XYZLog(@"[down][%p][progress] old[%p]: %lld/%lld, new[%p]: %lld/%lld", self, _progress, _progress.completedUnitCount, _progress.totalUnitCount, progress, progress.completedUnitCount, progress.totalUnitCount);
      NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:_progress.tk_theInfo];
      NSUInteger unit = (NSUInteger)(progress.completedUnitCount - _progress.completedUnitCount);
      _speed = (unit / time);
      _progress = progress;
      _progress.tk_theInfo = [NSDate date];

    }
  }
}

@end
