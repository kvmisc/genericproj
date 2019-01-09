//
//  XYZDownloadManager.h
//  GenericProj
//
//  Created by Kevin Wu on 4/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZDownloadItem.h"

/* [CONFIGURABLE_VALUE] */
#define XYZ_DOWNLOAD_CONCURRENT 2

// 链接被纳入到管理器中/被移除/出错/完成等各种状态更新，object 是对应的 item，如果 item 为空则为批量操作
#define XYZDownloadDidUpdateNotification @"XYZDownloadDidUpdateNotification"


@interface XYZDownloadManager : NSObject

@property (nonatomic, strong, readonly) NSArray *downloadAry;

@property (nonatomic, copy) NSString *path;


+ (XYZDownloadManager *)sharedObject;
+ (void)setSharedObject:(XYZDownloadManager *)object;


- (void)loadDownloadsFromDisk;
- (void)saveDownloadsToDisk;

- (void)startDownloadsIfNeeded;


- (XYZDownloadItem *)scheduleDownload:(NSString *)url
                          immediately:(BOOL)immediately
                             fraction:(void (^)(XYZDownloadItem *item))fraction
                               status:(void (^)(XYZDownloadItem *item))status;

// 如果已经在下载队列，移除并放入挂起队列
// 如果已经在等待队列，移除并放入挂起队列
// 如果已经在挂起队列，不管
// 如果已经在出错队列，移除并放入挂起队列
// 如果已经在完成队列，不管
// 如果已经在其它，移除并放入挂起队列
- (void)suspendURL:(NSString *)url;
- (void)suspendAllURL;

// 如果已经在下载队列且请求被挂起，启动
// 如果已经在等待队列，不管，让程序调度
// 如果已经在挂起队列，移到等待队列，让程序调度
// 如果已经在出错队列，移到等待队列，让程序调度
// 如果已经在完成队列，不管
// 如果已经在其它，移到等待队列，让程序调度
- (void)resumeURL:(NSString *)url;
- (void)resumeAllURL;

// 如果已经在下载队列，取消并移除
// 如果已经在等待队列，移除
// 如果已经在挂起队列，移除
// 如果已经在出错队列，移除
// 如果已经在完成队列，移除
// 如果已经在其它，移除
- (void)cancelURL:(NSString *)url;
- (void)cancelAllURL;


// 链接的状态分很多种：
//   * 未纳入到管理器中
//   * 纳入管理器中且处于 Downloading
//   * 纳入管理器中且处于 Waiting
//   * 纳入管理器中且处于 Suspended
//   * 纳入管理器中且处于 Error
//   * 纳入管理器中且处于 Success
- (XYZDownloadItem *)itemForURL:(NSString *)url;

- (NSString *)pathForURL:(NSString *)url;

// 退出应用时，一定要调用此方法解除与 NSURLSession 的循环引用
- (void)invalidateURLSession;

@end
