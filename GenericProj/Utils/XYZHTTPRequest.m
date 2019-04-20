//
//  XYZHTTPRequest.m
//  GenericProj
//
//  Created by Kevin Wu on 10/03/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "XYZHTTPRequest.h"

@implementation XYZHTTPRequest

#ifdef DEBUG
- (void)dealloc { XYZPrintMethod(); }
#endif

- (id)init
{
  self = [super init];
  if (self) {
    _headers = [[NSMutableDictionary alloc] init];
    _queries = [[NSMutableDictionary alloc] init];
    _parameters = [[NSMutableDictionary alloc] init];
    [self setup];
  }
  return self;
}

- (void)setup
{
}


- (void)start:(void (^)(XYZHTTPRequest *request, NSError *error))completionHandler
{
  // 取消旧的请求
  if ( _task ) {
    [_task cancel];
    _task = nil;
  }

  // 清除旧的返回数据和错误信息
  _response = nil;
  _responseData = nil;
  _error = nil;

  self.completionHandler = completionHandler;



  // 将查询参数添加到地址中
  NSString *address = [_address tk_stringByAddingQueryDictionary:_queries];

  NSError *serializationError = nil;
  NSMutableURLRequest *request =
  [_HTTPManager.requestSerializer requestWithMethod:_method
                                          URLString:[[NSURL URLWithString:address relativeToURL:_HTTPManager.baseURL] absoluteString]
                                         parameters:nil
                                              error:&serializationError];

  if ( !serializationError ) {

    // 设置请求超时时间
    if ( _timeoutInterval>0.0 ) {
      request.timeoutInterval = _timeoutInterval;
    }

    // 设置请求头
    @weakify(request);
    [_headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      @strongify(request);
      [request setValue:obj forHTTPHeaderField:key];
    }];

    // 设置请求 body
    if ( [@"POST" isEqualToString:_method] ) {
      if ( ![request valueForHTTPHeaderField:@"Content-Type"] ) {
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
      }
      NSData *body = _body;
      if ( body.length<=0 ) {
        NSString *string = [_parameters tk_queryString];
        body = [(string.length>0)?string:@"" dataUsingEncoding:NSUTF8StringEncoding];
      }
      [request setHTTPBody:body];
    }

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
    XYZLog(@"[req][%p][begin] [%@]", self, self.task.originalRequest.URL.absoluteString);
    [_task resume];
  } else {
    XYZLog(@"[req][%p][request_end_serialization] [%@]", self, serializationError);
    self.error = serializationError;
    [self complete];
  }

}

- (void)cancel
{
  [_task cancel];
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
    }
  } else {
    // 返回消息体为空
    self.error = [XYZHTTPError emptyResponseError];
  }
  [self complete];
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
