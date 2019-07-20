//
//  FBPlayerResourceRequest.m
//  Foobar
//
//  Created by Haiping Wu on 2019/7/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "FBPlayerResourceRequest.h"

@interface FBPlayerResourceRequest () <
    NSURLSessionDataDelegate
>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation FBPlayerResourceRequest

- (void)start
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_requestURL
                                                         cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                     timeoutInterval:10.0];
  if ( _requestOffset>0 ) {
    NSString *value = [[NSString alloc] initWithFormat:@"bytes=%ld-", _requestOffset];
    [request addValue:value forHTTPHeaderField:@"Range"];
  }

  _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                           delegate:self
                                      delegateQueue:[NSOperationQueue mainQueue]];
  _task = [_session dataTaskWithRequest:request];
  [_task resume];
}

- (void)cancel
{
  _cancelled = YES;
  [_task cancel];
  [_session invalidateAndCancel];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
  if ( _cancelled ) return;

  completionHandler(NSURLSessionResponseAllow);

  NSString *contentRange = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Content-Range"];
  long totalLength = [[[contentRange componentsSeparatedByString:@"/"] lastObject] integerValue];
  _totalLength = (totalLength>0) ? (totalLength) : ([(NSHTTPURLResponse *)response expectedContentLength]);

  if ( (_delegate) && [_delegate respondsToSelector:@selector(request:didReceiveResponse:)] ) {
    [_delegate request:self didReceiveResponse:response];
  }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
  if ( _cancelled ) return;

  _cachedLength += data.length;

  if ( (_delegate) && [_delegate respondsToSelector:@selector(request:didReceiveData:)] ) {
    [_delegate request:self didReceiveData:data];
  }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
  if ( _cancelled ) { return; }

  if ( (_delegate) && [_delegate respondsToSelector:@selector(request:didCompleteWithError:)] ) {
    [_delegate request:self didCompleteWithError:error];
  }
}

@end
