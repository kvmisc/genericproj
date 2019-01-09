//
//  XYZHTTPRequest.m
//  GenericProj
//
//  Created by Kevin Wu on 8/16/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import "XYZHTTPRequest.h"

@interface XYZHTTPRequest ()
@property (nonatomic, strong) NSFileHandle *temporaryFileHandle;
@end

@implementation XYZHTTPRequest

#ifdef DEBUG
- (void)dealloc
{
  XYZPrintMethod();
}
#endif

- (id)init
{
  self = [super init];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)initialize
{
}


- (void)setHeaders:(NSDictionary *)headers
{
  if ( !_headers) { _headers = [[NSMutableDictionary alloc] init]; }
  [(NSMutableDictionary *)_headers removeAllObjects];
  @weakify(self);
  [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    @strongify(self);
    if ( TK_S_NONEMPTY(key) ) {
      [(NSMutableDictionary *)(self.headers) setObject:obj forKey:key];
    }
  }];
}

- (void)setValue:(NSString *)value forHeader:(NSString *)header
{
  if ( !_headers) { _headers = [[NSMutableDictionary alloc] init]; }
  if ( TK_S_NONEMPTY(header) ) {
    if ( value ) {
      [(NSMutableDictionary *)_headers setObject:value forKey:header];
    } else {
      [(NSMutableDictionary *)_headers removeObjectForKey:header];
    }
  }
}

- (void)removeValueForHeader:(NSString *)header
{
  [(NSMutableDictionary *)_headers removeObjectForKey:header];
}


- (void)setParameters:(NSDictionary *)parameters
{
  if ( !_parameters) { _parameters = [[NSMutableDictionary alloc] init]; }
  [(NSMutableDictionary *)_parameters removeAllObjects];
  @weakify(self);
  [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    @strongify(self);
    if ( TK_S_NONEMPTY(key) ) {
      [(NSMutableDictionary *)(self.parameters) setObject:obj forKey:key];
    }
  }];
}

- (void)setValue:(NSString *)value forParameter:(NSString *)parameter
{
  if ( !_parameters) { _parameters = [[NSMutableDictionary alloc] init]; }
  if ( TK_S_NONEMPTY(parameter) ) {
    if ( value ) {
      [(NSMutableDictionary *)_parameters setObject:value forKey:parameter];
    } else {
      [(NSMutableDictionary *)_parameters removeObjectForKey:parameter];
    }
  }
}

- (void)removeValueForParameter:(NSString *)parameter
{
  [(NSMutableDictionary *)_parameters removeObjectForKey:parameter];
}














- (void)cleanRequestAndResponse
{
  // 取消掉旧的请求
  if ( _task ) {
    [_task cancel];
    _task = nil;
  }


  // 清除上次下载（可能）未清除的状态
  [_HTTPManager setDataTaskDidReceiveDataBlock:NULL];

  [_temporaryFileHandle closeFile];
  _temporaryFileHandle = nil;

  _progress = nil;
  _speed = 0;


  // 清除旧的返回数据和错误信息
  _response = nil;
  _responseData = nil;
  _error = nil;
}

- (void)addHeaderToHTTPManager
{
  @weakify(self);

  // 清除旧的 HTTP Header
  [self.HTTPManager.requestSerializer.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    @strongify(self);
    [self.HTTPManager.requestSerializer setValue:nil forHTTPHeaderField:key];
  }];

  // 添加新的 HTTP Header
  [_headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    @strongify(self);
    [self.HTTPManager.requestSerializer setValue:obj forHTTPHeaderField:key];
  }];
}

- (void)request:(XYZHTTPRequestCompletionHandler)completion
{
  [self cleanRequestAndResponse];
  [self addHeaderToHTTPManager];

  self.completionHandler = completion;

  if ( TK_S_NONEMPTY(_destinationFile) ) {



    NSError *serializationError = nil;
    NSMutableURLRequest *request = [_HTTPManager.requestSerializer requestWithMethod:_method
                                                                           URLString:[[NSURL URLWithString:_address relativeToURL:_HTTPManager.baseURL] absoluteString]
                                                                          parameters:_parameters
                                                                               error:&serializationError];
    if ( !serializationError ) {
      if ( _enableBrokenDownload ) {
        NSUInteger downloadedSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:_temporaryFile error:NULL] fileSize];
        if ( downloadedSize>0 ) {
          NSString *range = [NSString stringWithFormat:@"bytes=%lu-", downloadedSize];
          [request setValue:range forHTTPHeaderField:@"Range"];
        }
        @weakify(self);
        [_HTTPManager setDataTaskDidReceiveDataBlock:^(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data) {
          @strongify(self);
          if ( ![[NSFileManager defaultManager] fileExistsAtPath:self.temporaryFile] ) {
            [[NSFileManager defaultManager] createFileAtPath:self.temporaryFile contents:nil attributes:nil];
          }
          if ( !(self.temporaryFileHandle) ) {
            self.temporaryFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.temporaryFile];
          }
          [self.temporaryFileHandle seekToEndOfFile];
          [self.temporaryFileHandle writeData:data];
          NSProgress *progress = [NSProgress progressWithTotalUnitCount:dataTask.countOfBytesExpectedToReceive+downloadedSize];
          progress.completedUnitCount = dataTask.countOfBytesReceived+downloadedSize;
          [self calculateSpeed:progress];
          if ( self.progressHandler ) {
            self.progressHandler(progress);
          }
        }];
        _task = [_HTTPManager dataTaskWithRequest:request
                                   uploadProgress:NULL
                                 downloadProgress:^(NSProgress *downloadProgress) {}
                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                  @strongify(self);
                                  [self.temporaryFileHandle synchronizeFile];
                                  [self.temporaryFileHandle closeFile];
                                  self.temporaryFileHandle = nil;
                                  if ( error ) {
                                    // 200: 正常下载，状态码是 200，如果此时出错，不删除临时文件
                                    // 206: 断点下载，状态码是 206，如果此时出错，不删除临时文件
                                    NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                    if ( (HTTPStatusCode!=200) && (HTTPStatusCode!=206) ) {
                                      XYZLog(@"[req][%p][download_end] [%@] server_error:[%@]", self, self.destinationFile, error);
                                      NSError *removeError = nil;
                                      [[NSFileManager defaultManager] removeItemAtPath:self.temporaryFile error:&removeError];
                                      XYZLog(@"[req][%p][download_end] [%@] remove_temporary:[%@]", self, self.destinationFile, removeError);
                                    }
                                  } else {
                                    NSError *removeError = nil;
                                    [[NSFileManager defaultManager] removeItemAtPath:self.destinationFile error:&removeError];
                                    XYZLog(@"[req][%p][download_end] [%@] remove_destination:[%@]", self, self.destinationFile, removeError);
                                    NSError *moveError = nil;
                                    [[NSFileManager defaultManager] moveItemAtPath:self.temporaryFile toPath:self.destinationFile error:&moveError];
                                    XYZLog(@"[req][%p][download_end] [%@] move:[%@]", self, self.destinationFile, moveError);
                                  }
                                  XYZLog(@"[req][%p][download_end] [%@] [%@]", self, self.destinationFile, error);
                                  self.response = response;
                                  self.responseData = nil;
                                  self.error = error;
                                  [self calculateSpeed:nil];
                                  [self complete];
                                }];
        [_task resume];
      } else {
        @weakify(self);
        _task = [_HTTPManager downloadTaskWithRequest:request
                                             progress:^(NSProgress *downloadProgress) {
                                               @strongify(self);
                                               [self calculateSpeed:downloadProgress];
                                               if ( self.progressHandler ) {
                                                 self.progressHandler(downloadProgress);
                                               }
                                             }
                                          destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                            @strongify(self);
                                            return [NSURL fileURLWithPath:self.destinationFile];
                                          }
                                    completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                      @strongify(self);
                                      XYZLog(@"[req][%p][download_end] [%@] [%@]", self, self.destinationFile, error);
                                      self.response = response;
                                      self.responseData = nil;
                                      self.error = error;
                                      [self calculateSpeed:nil];
                                      [self complete];
                                    }];
        [_task resume];
      }
    } else {
      XYZLog(@"[req][%p][download_end_serialization] [%@] [%@]", self, self.destinationFile, serializationError);
      self.error = serializationError;
      [self complete];
    }



  } else {



    NSError *serializationError = nil;
    NSMutableURLRequest *request = [_HTTPManager.requestSerializer
                                    requestWithMethod:_method
                                    URLString:[[NSURL URLWithString:_address relativeToURL:_HTTPManager.baseURL] absoluteString]
                                    parameters:_parameters
                                    error:&serializationError];
    if ( [@"POST" isEqualToString:_method] && TK_D_NONEMPTY(_body) ) {
      [request setHTTPBody:_body];
    }
    if ( !serializationError ) {
      @weakify(self);
      _task = [_HTTPManager dataTaskWithRequest:request
                                 uploadProgress:NULL
                               downloadProgress:NULL
                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                @strongify(self);
                                self.response = response;
                                self.responseData = responseObject;
                                self.error = error;
                                if ( !error ) {
                                  XYZLog(@"[req][%p][request_end_success] [ContentLength: %lu]", self, (unsigned long)[responseObject length]);
                                  [self parseResponse:responseObject];
                                } else {
                                  XYZLog(@"[req][%p][request_end_failure] [%@]", self, error);
                                  [self complete];
                                }
                              }];
      [_task resume];
    } else {
      XYZLog(@"[req][%p][request_end_serialization] [%@]", self, serializationError);
      self.error = serializationError;
      [self complete];
    }



  }

  XYZLog(@"[req][%p][begin] [%@]", self, self.task.originalRequest.URL.absoluteString);
}

- (void)suspend
{
  [_task suspend];
}

- (void)resume
{
  [_task resume];
}

- (void)cancel
{
  [_task cancel];
}


- (void)calculateSpeed:(NSProgress *)progress
{
  if ( !_progress ) {
    // 前一个进度为空，不能算出速度，速度为 0
    _speed = 0;
    //XYZLog(@"[req][%p][progress] old: 0/0, new[%p]: %lld/%lld", self, progress, progress.completedUnitCount, progress.totalUnitCount);
    _progress = [NSProgress progressWithTotalUnitCount:progress.totalUnitCount];
    _progress.completedUnitCount = progress.completedUnitCount;
    _progress.tk_theInfo = [NSDate date];
  } else {
    if ( !progress ) {
      // 进度为空，应该是下载结束，速度为 0
      _speed = 0;
    } else {
      NSDate *now = [NSDate date];
      NSTimeInterval time = [now timeIntervalSinceDate:_progress.tk_theInfo];
      //XYZLog(@"[req][%p][progress] old[%p]: %lld/%lld, new[%p]: %lld/%lld", self, _progress, _progress.completedUnitCount, _progress.totalUnitCount, progress, progress.completedUnitCount, progress.totalUnitCount);
      NSUInteger unit = progress.completedUnitCount - _progress.completedUnitCount;
      _speed = unit / time;
      _progress = [NSProgress progressWithTotalUnitCount:progress.totalUnitCount];
      _progress.completedUnitCount = progress.completedUnitCount;
      _progress.tk_theInfo = [NSDate date];
    }
  }
}

- (void)parseResponse:(NSData *)data
{
  if ( [data length]>0 ) {
    NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    if ( object ) {
      [self parse:object];
    } else {
      // 返回消息体不是合法的 JSON 格式
      self.error = [XYZHTTPError invalidResponseError];
      [self complete];
    }
  } else {
    // 返回消息体为空
    self.error = [XYZHTTPError emptyResponseError];
    [self complete];
  }
}

- (void)parse:(id)object
{
}


- (void)complete
{
  if ( _completionHandler ) {
    _completionHandler(self, _error);
  }

  // 通知完成后清除请求句柄，免得夜长梦多
  _task = nil;
}

@end
