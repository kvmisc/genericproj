//
//  XYZHTTPRequest.h
//  GenericProj
//
//  Created by Kevin Wu on 10/03/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XYZHTTPError.h"
#import "NSDictionaryParameter.h"

@interface XYZHTTPRequest : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *HTTPManager;
@property (nonatomic, strong, readonly) NSURLSessionTask *task;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readonly) NSDictionary *queries;
@property (nonatomic, strong, readonly) NSDictionary *parameters;
// 如果请求方式为 POST 且 body 不为空，则 parameters 失效
@property (nonatomic, strong) NSData *body;

@property (nonatomic, copy) void (^completionHandler)(XYZHTTPRequest *request, NSError *error);
@property (nonatomic, strong) NSURLResponse *response;
// 请求返回的原始值，如果要保存解析后的模型，请在子类中定义属性来保存
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSError *error;


// to override
- (void)setup;

- (void)start:(void (^)(XYZHTTPRequest *request, NSError *error))completionHandler;

- (void)cancel;

// to override
- (void)parse:(id)object;

@end
