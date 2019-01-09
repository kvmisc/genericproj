//
//  XYZHTTPDownloader.h
//  GenericProj
//
//  Created by Kevin Wu on 11/03/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZHTTPDownloader : NSObject

@property (nonatomic, strong, readonly) NSURLSessionTask *task;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *destinationFile;
@property (nonatomic, copy) NSString *temporaryFile;
@property (nonatomic, assign) BOOL enableBrokenDownload;




@property (nonatomic, copy) void (^fractionHandler)(XYZHTTPDownloader *downloader);
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, assign) NSUInteger speed;

@property (nonatomic, copy) void (^completionHandler)(XYZHTTPDownloader *downloader, NSError *error);
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSError *error;

- (void)start:(void (^)(XYZHTTPDownloader *downloader, NSError *error))completionHandler;

// 调用此方法的时候：如果是断点续传，下次接着下载；否则都是重新下载
- (void)stop;


// 退出页面之前，一定要调用此方法，否则会造成内存泄露
- (void)invalidateSession;

@end
