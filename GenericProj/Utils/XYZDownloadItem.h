//
//  XYZDownloadItem.h
//  GenericProj
//
//  Created by Kevin Wu on 31/10/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  XYZDownloadStatusUnknown = 0,
  XYZDownloadStatusDownloading, // 下载队列
  XYZDownloadStatusWaiting,     // 等待队列
  XYZDownloadStatusSuspended,   // 挂起队列
  XYZDownloadStatusFailed,      // 出错队列
  XYZDownloadStatusSuccess      // 完成队列
} XYZDownloadStatus;

@interface XYZDownloadItem : NSObject <NSCoding>

// 准备信息
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *destinationFile;
@property (nonatomic, copy) NSString *temporaryFile;
@property (nonatomic, strong) NSFileHandle *temporaryFileHandle;
@property (nonatomic, assign) NSUInteger downloadedSize;

// 进度更新
@property (nonatomic, copy) void (^fractionHandler)(XYZDownloadItem *item);
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, assign) NSUInteger speed;
@property (nonatomic, strong) NSDate *lastReceiveDate;

// 状态改变
@property (nonatomic, copy) void (^statusHandler)(XYZDownloadItem *item);
@property (nonatomic, assign) XYZDownloadStatus status;

// HTTP 相关
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, assign) BOOL responseAcceptable;

- (void)setUpProgressAndSpeed:(NSProgress *)progress;

@end
