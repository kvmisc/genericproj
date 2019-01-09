//
//  GPDownloadViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 01/11/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPDownloadViewController.h"
#import "GPDownloadCell.h"

@interface GPDownloadViewController ()
@property (nonatomic, strong) NSArray *downloadAry;
@end

@implementation GPDownloadViewController

- (BOOL)shouldLoadContentView
{
  return NO;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [GPDownloadCell tk_registerInTableView:_tableView hasNib:YES];

  _tableView.rowHeight = 52.0;


  TKDeleteFileOrDirectory(TKPathForDocumentResource(@"Download"));


  XYZDownloadManager *dm = [XYZDownloadManager sharedObject];
  dm.path = TKPathForDocumentResource(@"Download");
  [[XYZDownloadManager sharedObject] loadDownloadsFromDisk];


  [self performSelector:@selector(delayUpdateDownloads:) withObject:nil afterDelay:1.0];
}

- (void)delayUpdateDownloads:(id)object
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayUpdateDownloads:) object:nil];

  self.downloadAry = [NSArray arrayWithArray:[[XYZDownloadManager sharedObject] downloadAry]];
  [self.tableView reloadData];
  [self performSelector:@selector(delayUpdateDownloads:) withObject:nil afterDelay:1.0];
}



- (IBAction)refresh:(id)sender
{
//  -rw-r--r-- 1 root root   1914950 Mar 12 05:08 2M.zip
//  -rw-r--r-- 1 root root     88704 Mar 12 05:09 90K.zip
//  -rw-r--r-- 1 root root 104857600 Mar  9 04:19 100.bin
//  -rw-r--r-- 1 root root  20268525 Mar 12 05:09 20M.zip
//  -rw-r--r-- 1 root root    217270 Mar 12 05:09 217K.zip
//  -rw-r--r-- 1 root root   9369733 Mar 12 05:08 9M.zip

  NSArray *list = @[
                    @"http://kevinsblog.cn/download/2M.zip",
                    @"http://kevinsblog.cn/download/90K.zip",
                    @"http://kevinsblog.cn/download/not_exist.zip",
                    @"http://kevinsblog.cn/download/100.bin",
                    @"http://kevinsblog.cn/download/20M.zip",
                    @"http://kevinsblog.cn/download/217K.zip",
                    @"http://kevinsblog.cn/download/9M.zip"
                    ];
  for ( NSUInteger i=0; i<[list count]; ++i ) {
    [[XYZDownloadManager sharedObject] scheduleDownload:[list objectAtIndex:i]
                                            immediately:NO
                                               fraction:NULL
                                                 status:NULL];

//    [[XYZDownloadManager sharedObject] scheduleDownload:NO
//                                                    url:[list objectAtIndex:i]
//                                               progress:^(id item, NSProgress *progress) {
//                                                 NSLog(@"xxx: progress %lld/%lld %.02f", progress.completedUnitCount, progress.totalUnitCount, progress.fractionCompleted);
//                                               } update:^(id item, NSError *error) {
//                                                 NSLog(@"xxx: update %@ %d", [item url], [item status]);
//                                               }];
  }
}

- (IBAction)suspend:(id)sender
{
}

- (IBAction)resume:(id)sender
{
}

- (IBAction)cancel:(id)sender
{
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_downloadAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  GPDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GPDownloadCell" forIndexPath:indexPath];

  XYZDownloadItem *item = [_downloadAry objectAtIndex:indexPath.row];

  cell.titleLabel.text = item.url;
  if ( item.status==XYZDownloadStatusDownloading ) {
    cell.subLabel1.text = @"Downloading";
  } else if ( item.status==XYZDownloadStatusWaiting ) {
    cell.subLabel1.text = @"Waiting";
  } else if ( item.status==XYZDownloadStatusSuspended ) {
    cell.subLabel1.text = @"Suspended";
  } else if ( item.status==XYZDownloadStatusFailed ) {
    cell.subLabel1.text = @"Failed";
  } else if ( item.status==XYZDownloadStatusSuccess ) {
    cell.subLabel1.text = @"Success";
  } else {
    cell.subLabel1.text = @"Unknown";
  }

  //cell.subLabel2.text = [NSString stringWithFormat:@"%.02f %lld/%lld", item.request.progress.fractionCompleted, item.request.progress.completedUnitCount, item.request.progress.totalUnitCount];
  cell.subLabel2.text = [NSString stringWithFormat:@"%.02f %lld/%lld", item.progress.fractionCompleted, item.progress.completedUnitCount, item.progress.totalUnitCount];

  NSUInteger speed = item.speed;
  if ( speed<1024 ) {
    cell.subLabel3.text = [NSString stringWithFormat:@"%luB/s", (unsigned long)speed];
  } else if ( speed<1024*1024 ) {
    cell.subLabel3.text = [NSString stringWithFormat:@"%.02fKB/s", speed/1024.0];
  } else {
    cell.subLabel3.text = [NSString stringWithFormat:@"%.02fMB/s", speed/1024.0/1024.0];
  }



  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  XYZDownloadItem *item = [_downloadAry objectAtIndex:indexPath.row];
  if ( item.status==XYZDownloadStatusDownloading ) {
    [[XYZDownloadManager sharedObject] suspendURL:item.url];
  } else if ( item.status==XYZDownloadStatusWaiting ) {
    [[XYZDownloadManager sharedObject] suspendURL:item.url];
  } else if ( item.status==XYZDownloadStatusSuspended ) {
    [[XYZDownloadManager sharedObject] resumeURL:item.url];
  } else if ( item.status==XYZDownloadStatusFailed ) {
    [[XYZDownloadManager sharedObject] resumeURL:item.url];
  } else if ( item.status==XYZDownloadStatusSuccess ) {

  } else {
    [[XYZDownloadManager sharedObject] resumeURL:item.url];
  }

  [self delayUpdateDownloads:nil];
}

@end

