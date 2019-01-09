//
//  GPHTTPViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 9/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPHTTPViewController.h"

@implementation GPHTTPViewController

#ifdef DEBUG
- (void)dealloc
{
  XYZPrintMethod();
}
#endif



- (IBAction)doit:(id)sender
{
  [_request1 cancel];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [[NSURLCache sharedURLCache] removeAllCachedResponses];

//  _downloader = [[XYZHTTPDownloader alloc] init];
//  _downloader.address = @"http://kevinsblog.cn/download/bbc.zip";
//  _downloader.destinationFile = TKPathForDocumentResource(@"s110.zip");
//  _downloader.temporaryFile = TKPathForDocumentResource(@"s110.tmp");
//  _downloader.enableBrokenDownload = NO;
////  _downloader.statusHandler = ^(NSProgress *progress, NSUInteger speed) {
////    NSLog(@"status: %.02f %.02fKB/s", progress.fractionCompleted, speed/1024.0);
////  };
//  [_downloader start:^(XYZHTTPDownloader *downloader, NSError *error) {
//    NSLog(@"complete: %@", error);
//  }];

  //return;


  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
  //AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://kevinsblog.cn/"]
  //                                                         sessionConfiguration:configuration];

  AFHTTPResponseSerializer *serializer = [[AFHTTPResponseSerializer alloc] init];
  manager.responseSerializer = serializer;



  _request1 = [[GPTestRequest alloc] init];
  _request1.HTTPManager = manager;
  //_request1.address = @"http://kevinsblog.cn/";
  //_request1.address = @"http://kevinsblog.cn/download/ts.bin";
  //_request1.destinationFile = TKPathForDocumentResource(@"s110.zip");
  //_request1.temporaryFile = TKPathForDocumentResource(@"s110.tmp");
  //_request1.enableBrokenDownload = YES;

//  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)(_request1.task);
//    [task cancelByProducingResumeData:^(NSData *resumeData) {
//      NSLog(@"%ld", [resumeData length]);
//      [resumeData writeToFile:TKPathForDocumentResource(@"alkd.txt") atomically:YES];
//    }];
//  });

  //return;

  //@weakify(self);
  [_request1 start:^(XYZHTTPRequest *request, NSError *error) {
    //@strongify(self);
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    NSLog(@"thread:%d", [NSThread isMainThread]);
//    NSLog(@"%@", request);
//    NSLog(@"%@", error);
//    NSLog(@"\n\n\n\n\n");
  }];

}

@end
