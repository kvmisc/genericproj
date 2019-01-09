//
//  XYZHTTPRequest.h
//  GenericProj
//
//  Created by Kevin Wu on 8/16/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XYZHTTPSessionManager.h"
#import "XYZHTTPError.h"

@class XYZHTTPRequest;

typedef void(^XYZHTTPRequestProgressHandler)(NSProgress *progress);
typedef void(^XYZHTTPRequestCompletionHandler)(XYZHTTPRequest *request, NSError *error);

@interface XYZHTTPRequest : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *HTTPManager;
@property (nonatomic, strong, readonly) NSURLSessionTask *task;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, strong) NSDictionary *headers; // 传空的时候清除
@property (nonatomic, strong) NSDictionary *parameters; // 传空的时候清除；能同时给 GET 和 POST 类型的请求提供参数
@property (nonatomic, strong) NSData *body; // 如果请求方式为 POST 且 body 不空，parameters 失效

@property (nonatomic, copy) XYZHTTPRequestProgressHandler progressHandler;
@property (nonatomic, copy) NSString *destinationFile; // 如果不空，则为文件下载模式
@property (nonatomic, copy) NSString *temporaryFile;
@property (nonatomic, assign) BOOL enableBrokenDownload; // 断点下载应该给每个 request 单独的 HTTPManager，因为 setDataTaskDidReceiveDataBlock: 依附于 HTTPManager
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, assign) NSUInteger speed;

@property (nonatomic, copy) XYZHTTPRequestCompletionHandler completionHandler;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSData *responseData; // 请求返回的原始值，如果要保存解析后的模型，请自己在子类中定义属性来保存
@property (nonatomic, strong) NSError *error;


// to override
- (void)initialize;


- (void)setValue:(NSString *)value forHeader:(NSString *)header;
- (void)removeValueForHeader:(NSString *)header;

- (void)setValue:(NSString *)value forParameter:(NSString *)parameter;
- (void)removeValueForParameter:(NSString *)parameter;


- (void)request:(XYZHTTPRequestCompletionHandler)completion;

- (void)suspend;

- (void)resume;

- (void)cancel;


// to override
- (void)parse:(id)object;


// 子类解析出结果后一定要调用此方法通知调用者
- (void)complete;

@end
