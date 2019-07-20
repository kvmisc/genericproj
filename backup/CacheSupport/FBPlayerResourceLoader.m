//
//  FBPlayerResourceLoader.m
//  Foobar
//
//  Created by Haiping Wu on 2019/7/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "FBPlayerResourceLoader.h"
#import "NSURL+Player.h"

@interface FBPlayerResourceLoader ()

@property (nonatomic, strong) NSMutableArray *waitingList;
@property (nonatomic, strong) FBPlayerResourceRequest *request;

@property (nonatomic, strong) NSLock *lock;

@end


@implementation FBPlayerResourceLoader

- (NSString *)tmpFilePath
{
  return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/tmp_video.mp4"];
}
- (void)refreshTmpFile
{
  NSString *path = [self tmpFilePath];
  if ( path.length>0 ) {
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path] ) {
      [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
  }
}
- (void)writeTmpFile:(NSData *)data
{
  NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:[self tmpFilePath]];
  [handle seekToEndOfFile];
  [handle writeData:data];
  [handle synchronizeFile];
}
- (NSData *)readTmpFile:(NSUInteger)offset length:(NSUInteger)length
{
  NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:[self tmpFilePath]];
  [handle seekToFileOffset:offset];
  return [handle readDataOfLength:length];
}



- (instancetype)init
{
  self = [super init];
  if (self) {
    _waitingList = [[NSMutableArray alloc] init];
    _request = nil;
    _lock = [[NSLock alloc] init];
    [self refreshTmpFile];
  }
  return self;
}

- (void)stopLoading
{
  [_request cancel];
  _request = nil;
}

- (void)resumeLoading
{
  [self addLoadingRequest:nil];
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader
shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
//  NSLog(@" ");
//  NSLog(@"begin wait =================================");
//  if ( _request ) {
//    NSLog(@"Loading done: %ld, cancelled: %d", _request.cachedLength, _request.cancelled);
//  }
//  for ( AVAssetResourceLoadingRequest *request in _waitingList ) {
//    NSLog(@"Waiting [%ld-%ld] provided: %ld",
//          (long)request.dataRequest.requestedOffset,
//          (long)request.dataRequest.requestedLength,
//          (long)request.dataRequest.currentOffset-(long)request.dataRequest.requestedOffset);
//  }
//  NSLog(@"end wait ===================================");
//  NSLog(@" ");

  [self addLoadingRequest:loadingRequest];
  return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader
didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
//  NSLog(@" ");
//  NSLog(@"begin cancel ===============================");
//  if ( _request ) {
//    NSLog(@"Loading done: %ld, cancelled: %d", _request.cachedLength, _request.cancelled);
//  }
//  for ( AVAssetResourceLoadingRequest *request in _waitingList ) {
//    NSLog(@"Waiting [%ld-%ld] provided: %ld",
//          (long)request.dataRequest.requestedOffset,
//          (long)request.dataRequest.requestedLength,
//          (long)request.dataRequest.currentOffset-(long)request.dataRequest.requestedOffset);
//  }
//  NSLog(@"end cancel =================================");
//  NSLog(@" ");

  [self removeLoadingRequest:loadingRequest];
}

- (void)request:(FBPlayerResourceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
  if ( (_delegate) && [_delegate respondsToSelector:@selector(loader:didStart:)] ) {
    [_delegate loader:self didStart:_request.totalLength];
  }
}
- (void)request:(FBPlayerResourceRequest *)request didReceiveData:(NSData *)data
{
  [_lock lock];
  [self writeTmpFile:data];
  [self processWaitingList];
  [_lock unlock];
  if ( (_delegate) && [_delegate respondsToSelector:@selector(loader:didUpdateCache:)] ) {
    [_delegate loader:self didUpdateCache:[data length]];
  }
}
- (void)request:(FBPlayerResourceRequest *)request didCompleteWithError:(NSError *)error
{
  [_lock lock];
  [self processWaitingList];
  [_lock unlock];

  _error = error;

  if ( (_delegate) && [_delegate respondsToSelector:@selector(loader:didComplete:)] ) {
    [_delegate loader:self didComplete:error];
  }
}

- (void)addLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
  [_lock lock];

  if ( loadingRequest ) {
    [_waitingList addObject:loadingRequest];
  }

//  NSLog(@"Add? [%ld-%ld] provided: %ld",
//        (long)loadingRequest.dataRequest.requestedOffset,
//        (long)loadingRequest.dataRequest.requestedLength,
//        (long)loadingRequest.dataRequest.currentOffset-(long)loadingRequest.dataRequest.requestedOffset);

  if ( _request ) {
    if ( loadingRequest.dataRequest.requestedOffset <= _request.cachedLength ) {
//      NSLog(@"Add?process [%ld-%ld] provided: %ld",
//            (long)loadingRequest.dataRequest.requestedOffset,
//            (long)loadingRequest.dataRequest.requestedLength,
//            (long)loadingRequest.dataRequest.currentOffset-(long)loadingRequest.dataRequest.requestedOffset);
      [self processWaitingList];
    }
  } else {

//    NSLog(@"Add?request [%ld-%ld] provided: %ld",
//          (long)loadingRequest.dataRequest.requestedOffset,
//          (long)loadingRequest.dataRequest.requestedLength,
//          (long)loadingRequest.dataRequest.currentOffset-(long)loadingRequest.dataRequest.requestedOffset);

    if ( _waitingList.count>0 ) {
      AVAssetResourceLoadingRequest *request = loadingRequest;
      if ( !request ) {
        request = [_waitingList firstObject];
      }
      _request = [[FBPlayerResourceRequest alloc] init];
      _request.requestURL = [request.request.URL fb_originalSchemeURL];
      _request.requestOffset = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self tmpFilePath] error:NULL] fileSize];
      _request.delegate = self;
      [_request start];
    }
  }

  [_lock unlock];
}

- (void)removeLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
  [_lock lock];

//  NSLog(@"Remove?remove [%ld-%ld] provided: %ld",
//        (long)loadingRequest.dataRequest.requestedOffset,
//        (long)loadingRequest.dataRequest.requestedLength,
//        (long)loadingRequest.dataRequest.currentOffset-(long)loadingRequest.dataRequest.requestedOffset);

  [_waitingList removeObject:loadingRequest];

  [_lock unlock];
}

- (void)processWaitingList
{
//  NSLog(@" ");
//  NSLog(@"begin process ==============================");
//  if ( _request ) {
//    NSLog(@"Loading done: %ld, cancelled: %d", _request.cachedLength, _request.cancelled);
//  }
//  for ( AVAssetResourceLoadingRequest *request in _waitingList ) {
//    NSLog(@"Waiting [%ld-%ld] provided: %ld",
//          (long)request.dataRequest.requestedOffset,
//          (long)request.dataRequest.requestedLength,
//          (long)request.dataRequest.currentOffset-(long)request.dataRequest.requestedOffset);
//  }
//  NSLog(@"end process ================================");
//  NSLog(@" ");

  NSMutableArray *finishedWaitingList = [[NSMutableArray alloc] init];

  for ( AVAssetResourceLoadingRequest *loadingRequest in _waitingList ) {
    if ( [self finishLoadingWithLoadingRequest:loadingRequest] ) {
      [finishedWaitingList addObject:loadingRequest];
    }
  }

//  NSLog(@" ");
//  NSLog(@"begin done =================================");
//  if ( _request ) {
//    NSLog(@"Loading done: %ld, cancelled: %d", _request.cachedLength, _request.cancelled);
//  }
//  for ( AVAssetResourceLoadingRequest *request in finishedWaitingList ) {
//    NSLog(@"Waiting [%ld-%ld] provided: %ld",
//          (long)request.dataRequest.requestedOffset,
//          (long)request.dataRequest.requestedLength,
//          (long)request.dataRequest.currentOffset-(long)request.dataRequest.requestedOffset);
//  }
//  NSLog(@"end done ===================================");
//  NSLog(@" ");

  [_waitingList removeObjectsInArray:finishedWaitingList];
}

- (BOOL)finishLoadingWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
  //填充信息
  CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(@"video/mp4"), NULL);
  loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
  loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
  loadingRequest.contentInformationRequest.contentLength = _request.totalLength;

  // 已经缓存的量
  NSUInteger cachedLength = _request.cachedLength;
  // 已经提供给播放器的量
  NSUInteger providedLength = loadingRequest.dataRequest.currentOffset - loadingRequest.dataRequest.requestedOffset;
  // 最多能提供的量
  NSUInteger canReadLength = cachedLength - loadingRequest.dataRequest.currentOffset;
  // 播放器还需要的量
  NSUInteger neededLength = loadingRequest.dataRequest.requestedLength - providedLength;
  // 本次提供的量
  NSUInteger respondLength = MIN(canReadLength, neededLength);

//  NSLog(@"Feed cached:[0-%ld] request:[%ld-%ld=%ld %ld] can:%ld need:%ld respond:%ld",
//        cachedLength,
//
//        (long)loadingRequest.dataRequest.currentOffset,
//        (long)loadingRequest.dataRequest.requestedOffset,
//        providedLength,
//        loadingRequest.dataRequest.requestedLength,
//
//        canReadLength,
//        neededLength,
//        respondLength);

  // 提供数据
  NSData *data = [self readTmpFile:loadingRequest.dataRequest.currentOffset length:respondLength];
  [loadingRequest.dataRequest respondWithData:data];

//  NSLog(@"Feed done: %ld", [data length]);

  //如果完全响应了所需要的数据，则完成
  if ( canReadLength>=neededLength ) {
    [loadingRequest finishLoading];
    return YES;
  }

  return NO;
}

@end
