//
//  XYZDownloadManager.m
//  GenericProj
//
//  Created by Kevin Wu on 4/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZDownloadManager.h"

@interface XYZDownloadManager () <
    NSURLSessionDelegate
>

@property (nonatomic, strong) NSURLSession *URLSession;
@property (nonatomic, strong) NSIndexSet *acceptableCodes;

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, copy) NSString *recordPath;

@end


@implementation XYZDownloadManager

- (id)init
{
  self = [super init];
  if (self) {
    _downloadAry = [[NSMutableArray alloc] init];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _URLSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

    _acceptableCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];

    _lock = [[NSLock alloc] init];
  }
  return self;
}


static XYZDownloadManager *DownloadManager = nil;

+ (XYZDownloadManager *)sharedObject
{
  if ( !DownloadManager ) {
    DownloadManager = [[self alloc] init];
  }
  return DownloadManager;
}

+ (void)setSharedObject:(XYZDownloadManager *)object
{
  DownloadManager = object;
}


- (void)setPath:(NSString *)path
{
  if ( path.length>0 ) {
    _path = [path copy];
    _recordPath = [path stringByAppendingPathComponent:@"record.db"];
    TKCreateDirectory(_path);
  } else {
    _path = nil;
    _recordPath = nil;
  }
}


- (void)loadDownloadsFromDisk
{
  [_lock lock];

  [(NSMutableArray *)_downloadAry removeAllObjects];

  NSArray *itemAry = TKLoadArchivableObject(_recordPath);
  for ( NSUInteger i=0; i<[itemAry count]; ++i ) {
    XYZDownloadItem *item = [itemAry objectAtIndex:i];

    if ( item.status==XYZDownloadStatusDownloading ) {
      // 之前处于下载队列，保持状态不变，待会根据并发数决定是否启动
    } else if ( item.status==XYZDownloadStatusWaiting ) {
      // 之前处于等待队列，保持状态不变，待会根据并发数决定是否启动
    } else if ( item.status==XYZDownloadStatusSuspended ) {
      // 之前处于挂起队列，保持状态不变，不要改变用户的选择
    } else if ( item.status==XYZDownloadStatusFailed ) {
      // 之前处于出错队列，保持状态不变
    } else if ( item.status==XYZDownloadStatusSuccess ) {
      // 之前处于完成队列，保持状态不变
    } else {
      // 不知处于何队列，全部放到等待队列
      item.status = XYZDownloadStatusWaiting;
    }

    [(NSMutableArray *)_downloadAry addObject:item];
  }

  TKSaveArchivableObject(_downloadAry, _recordPath);

  [_lock unlock];
}

- (void)saveDownloadsToDisk
{
  [_lock lock];

  TKSaveArchivableObject(_downloadAry, _recordPath);

  [_lock unlock];
}


- (void)startDownloadsIfNeeded
{
  [_lock lock];

  [self beginItemsIfNeeded];
  
  [_lock unlock];
}



- (XYZDownloadItem *)scheduleDownload:(NSString *)url
                          immediately:(BOOL)immediately
                             fraction:(void (^)(XYZDownloadItem *item))fraction
                               status:(void (^)(XYZDownloadItem *item))status
{
  if ( url.length<=0 ) { return nil; }

  [_lock lock];

  XYZDownloadItem *item = [_downloadAry tk_objectForKeyPath:@"url" equalTo:url];
  if ( item ) {

    if ( item.status==XYZDownloadStatusSuccess ) {
      // 已经在成功队列，不作操作
      XYZLogDebug(@"download", @"add, success, url:%@", item.url);

    } else if ( item.status==XYZDownloadStatusDownloading ) {
      // 已经在下载队列，下载中，不作操作
      XYZLogDebug(@"download", @"add, downloading, url:%@", item.url);

    } else {

      // 已经在等待队列、挂起队列、出错队列或其它，马上启动或程序调度
      XYZLogDebug(@"download", @"add, launching, url:%@", item.url);
      item.status = XYZDownloadStatusWaiting;
      if ( immediately ) {
        [self beginItem:item];
      }
      
    }

  } else {

    item = [[XYZDownloadItem alloc] init];
    item.url = url;
    item.fractionHandler = fraction;
    item.statusHandler = status;
    item.status = XYZDownloadStatusWaiting;
    item.destinationFile = [self pathForURL:item.url];
    item.temporaryFile = [item.destinationFile stringByAppendingString:@".tkdownload"];
    [(NSMutableArray *)_downloadAry addObject:item];
    TKDeleteFileOrDirectory(item.destinationFile);
    TKDeleteFileOrDirectory(item.temporaryFile);

    // 新添加下载项，马上启动或进入准备
    XYZLogDebug(@"download", @"add, creating, url:%@", url);
    if ( immediately ) {
      [self beginItem:item];
    }

  }

  [self beginItemsIfNeeded];

  [_lock unlock];

  [self itemUpdated:item];

  return item;
}
- (void)beginItem:(XYZDownloadItem *)item
{
  item.status = XYZDownloadStatusDownloading;
  TKSaveArchivableObject(_downloadAry, _recordPath);
  [self makeRequestForItem:item];
}
- (void)beginItemsIfNeeded
{
  for ( XYZDownloadItem *item in _downloadAry ) {
    if ( item.status==XYZDownloadStatusDownloading ) {
      [self makeRequestForItem:item];
    }
  }

  NSInteger downloadingCount = [_downloadAry tk_numberOfObjectsForKeyPath:@"status" equalTo:@(XYZDownloadStatusDownloading)];
  for ( NSUInteger i=downloadingCount; i<XYZ_DOWNLOAD_CONCURRENT; ++i ) {
    XYZDownloadItem *item = [_downloadAry tk_objectForKeyPath:@"status" equalTo:@(XYZDownloadStatusWaiting)];
    if ( item ) {
      item.status = XYZDownloadStatusDownloading;
      [self makeRequestForItem:item];
    }
  }

  TKSaveArchivableObject(_downloadAry, _recordPath);
}
- (void)makeRequestForItem:(XYZDownloadItem *)item
{
  if ( (item.task) && (item.task.state==NSURLSessionTaskStateRunning) ) {
    return;
  }

  // 取消上次非活动的任务
  NSURLSessionTask *task = item.task;
  item.task = nil;
  [task cancel];
  // 清除上次的 HTTP 状态标志
  item.responseAcceptable = NO;

  // 关闭上次的临时文件句柄
  [item.temporaryFileHandle synchronizeFile];
  [item.temporaryFileHandle closeFile];
  item.temporaryFileHandle = nil;
  // 因为断点续传的关系，先记录已经下载的文件大小
  item.downloadedSize = (NSUInteger)[[[NSFileManager defaultManager] attributesOfItemAtPath:item.temporaryFile error:NULL] fileSize];

  // 创建 request
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:item.url]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:15.0];
  request.HTTPMethod = @"GET";

  // 添加断点续传头
  if ( item.downloadedSize>0 ) {
    NSString *range = [NSString stringWithFormat:@"bytes=%lu-", (unsigned long)(item.downloadedSize)];
    [request setValue:range forHTTPHeaderField:@"Range"];
  }

  // 开始下载任务
  item.task = [_URLSession dataTaskWithRequest:request];
  [item.task resume];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
  [_lock lock];

  XYZLog(@"%s %@", sel_getName(_cmd), response);

  XYZDownloadItem *item = [_downloadAry tk_objectForKeyPath:@"task" identicalTo:dataTask];

  if ( item ) {
    item.response = response;
    // 可接受的状态码为空，表示接受所有的状态码，可接受；
    // 可接受的状态码非空，且包含当前返回的状态码，可接受；
    item.responseAcceptable = ( (!_acceptableCodes) || [_acceptableCodes containsIndex:(NSUInteger)[(NSHTTPURLResponse *)response statusCode]] );

    if ( completionHandler ) {
      completionHandler(NSURLSessionResponseAllow);
    }
  }

  [_lock unlock];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
  [_lock lock];

  XYZLog(@"%s %lu", sel_getName(_cmd), (unsigned long)[data length]);

  XYZDownloadItem *item = [_downloadAry tk_objectForKeyPath:@"task" identicalTo:dataTask];

  if ( item ) {
    if ( item.responseAcceptable ) {

      // 创建临时文件
      if ( ![[NSFileManager defaultManager] fileExistsAtPath:item.temporaryFile] ) {
        [[NSFileManager defaultManager] createFileAtPath:item.temporaryFile contents:nil attributes:nil];
      }
      // 创建临时文件句柄
      if ( !(item.temporaryFileHandle) ) {
        item.temporaryFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:item.temporaryFile];
      }

      [item.temporaryFileHandle seekToEndOfFile];
      [item.temporaryFileHandle writeData:data];

      NSProgress *progress = [NSProgress progressWithTotalUnitCount:dataTask.countOfBytesExpectedToReceive+item.downloadedSize];
      progress.completedUnitCount = dataTask.countOfBytesReceived+item.downloadedSize;

      [item setUpProgressAndSpeed:progress];

      if ( item.fractionHandler ) {
        item.fractionHandler(item);
      }
    }
  }

  [_lock unlock];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
  [_lock lock];

  XYZLog(@"%s %@", sel_getName(_cmd), error);

  XYZDownloadItem *item = [_downloadAry tk_objectForKeyPath:@"task" identicalTo:task];

  if ( item ) {
    [item.temporaryFileHandle synchronizeFile];
    [item.temporaryFileHandle closeFile];
    item.temporaryFileHandle = nil;

    if ( error ) {
      item.error = error;
    } else {
      if ( item.responseAcceptable ) {
        item.error = nil;
      } else {
        item.error = [[NSError alloc] initWithDomain:XYZ_ERROR_DOMAIN_HTTP
                                                code:[(NSHTTPURLResponse *)item.response statusCode]
                                            userInfo:@{NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"请求出错", @"")}];
      }
    }

    if ( item.error ) {
      // 只能从下载状态切换到出错，因为如果先下载再暂停，过一会链接会超时，超时会有错误调用到这里，本来应该挂起的，却会被这里修改为出错
      if ( item.status==XYZDownloadStatusDownloading ) {
        item.status = XYZDownloadStatusFailed;
      }
    } else {
      item.status = XYZDownloadStatusSuccess;
      [[NSFileManager defaultManager] moveItemAtPath:item.temporaryFile toPath:item.destinationFile error:NULL];
    }

    [self beginItemsIfNeeded];
  }

  [_lock unlock];

  [self itemUpdated:item];

  item.task = nil;
}


- (void)suspendURL:(NSString *)url
{
  if ( url.length>0 ) {
    [_lock lock];

    XYZDownloadItem *item = [_downloadAry tk_objectForKeyPath:@"url" equalTo:url];
    if ( item ) {
      [self doSuspendItem:item];
    }

    [self beginItemsIfNeeded];

    [_lock unlock];

    [self itemUpdated:item];
  }
}
- (void)suspendAllURL
{
  [_lock lock];

  for ( XYZDownloadItem *item in _downloadAry ) {
    [self doSuspendItem:item];
  }

  TKSaveArchivableObject(_downloadAry, _recordPath);

  [_lock unlock];

  [self itemUpdated:nil];
}
- (void)doSuspendItem:(XYZDownloadItem *)item
{
  NSURLSessionTask *task = item.task;
  item.task = nil;
  [task cancel];
  if ( item.status!=XYZDownloadStatusSuccess ) {
    item.status = XYZDownloadStatusSuspended;
  }
}

- (void)resumeURL:(NSString *)url
{
  if ( url.length>0 ) {
    [_lock lock];

    XYZDownloadItem *item = [_downloadAry tk_objectForKeyPath:@"url" equalTo:url];
    if ( item ) {
      [self doResumeItem:item];
    }

    [self beginItemsIfNeeded];

    [_lock unlock];

    [self itemUpdated:item];
  }
}
- (void)resumeAllURL
{
  [_lock lock];

  for ( XYZDownloadItem *item in _downloadAry ) {
    [self doResumeItem:item];
  }

  [self beginItemsIfNeeded];

  [_lock unlock];

  [self itemUpdated:nil];
}
- (void)doResumeItem:(XYZDownloadItem *)item
{
  if ( (item.status!=XYZDownloadStatusDownloading) && (item.status!=XYZDownloadStatusSuccess) ) {
    item.status = XYZDownloadStatusWaiting;
  }
}

- (void)cancelURL:(NSString *)url
{
  if ( url.length>0 ) {
    [_lock lock];

    XYZDownloadItem *item = [_downloadAry tk_objectForKeyPath:@"url" equalTo:url];
    if ( item ) {
      [self doCancelItem:item];
      [(NSMutableArray *)_downloadAry removeObject:item];
    }

    [self beginItemsIfNeeded];

    [_lock unlock];

    [self itemUpdated:item];
  }
}
- (void)cancelAllURL
{
  [_lock lock];

  for ( XYZDownloadItem *item in _downloadAry ) {
    [self doCancelItem:item];
  }
  [(NSMutableArray *)_downloadAry removeAllObjects];

  TKSaveArchivableObject(_downloadAry, _recordPath);

  [_lock unlock];

  [self itemUpdated:nil];
}
- (void)doCancelItem:(XYZDownloadItem *)item
{
  NSURLSessionTask *task = item.task;
  item.task = nil;
  [task cancel];
  TKDeleteFileOrDirectory(item.temporaryFile);
  item.status = XYZDownloadStatusUnknown;
}


- (void)itemUpdated:(XYZDownloadItem *)item
{
  if ( item.statusHandler ) {
    item.statusHandler(item);
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:XYZDownloadDidUpdateNotification object:item];
}


- (XYZDownloadItem *)itemForURL:(NSString *)url
{
  XYZDownloadItem *item = nil;
  [_lock lock];
  item = [_downloadAry tk_objectForKeyPath:@"url" equalTo:url];
  [_lock unlock];
  return item;
}

- (NSString *)pathForURL:(NSString *)url
{
  if ( url.length>0 ) {
    return [_path stringByAppendingPathComponent:[[url tk_MD5HashString] lowercaseString]];
  }
  return nil;
}

- (void)invalidateURLSession
{
  [_URLSession invalidateAndCancel];
  _URLSession = nil;
}

@end
