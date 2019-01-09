//
//  GPMessageContentViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 3/15/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPMessageContentViewController.h"

@implementation GPMessageContentViewController

- (BOOL)shouldLoadContentView
{
  return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

//  UIView *prevView = nil;
//
//  {
//    XYZHUDView *cv = [[XYZHUDView alloc] init];
//    [cv configForMode:XYZHUDContentModeActivity];
//    [self.view addSubview:cv];
//    @weakify(self);
//    [cv mas_updateConstraints:^(MASConstraintMaker *make) {
//      @strongify(self);
//      make.centerX.equalTo(self.view);
//      if ( prevView ) {
//        make.top.equalTo(prevView.mas_bottom).offset(10);
//      } else {
//        make.top.equalTo(self.view).offset(30);
//      }
//    }];
//    prevView = cv;
//  }
//  {
//    XYZHUDView *cv = [[XYZHUDView alloc] init];
//    [cv configForMode:XYZHUDContentModeText];
//    cv.textLabel.text = @"Loading...";
//    [self.view addSubview:cv];
//    @weakify(self);
//    [cv mas_updateConstraints:^(MASConstraintMaker *make) {
//      @strongify(self);
//      make.centerX.equalTo(self.view);
//      if ( prevView ) {
//        make.top.equalTo(prevView.mas_bottom).offset(10);
//      } else {
//        make.top.equalTo(self.view).offset(30);
//      }
//    }];
//    prevView = cv;
//  }
//  {
//    XYZHUDView *cv = [[XYZHUDView alloc] init];
//    [cv configForMode:XYZHUDContentModeCancellation];
//    cv.textLabel.text = @"Loading...";
//    [self.view addSubview:cv];
//    @weakify(self);
//    [cv mas_updateConstraints:^(MASConstraintMaker *make) {
//      @strongify(self);
//      make.centerX.equalTo(self.view);
//      if ( prevView ) {
//        make.top.equalTo(prevView.mas_bottom).offset(10);
//      } else {
//        make.top.equalTo(self.view).offset(30);
//      }
//    }];
//    prevView = cv;
//  }
//  {
//    XYZHUDView *cv = [[XYZHUDView alloc] init];
//    [cv configForMode:XYZHUDContentModeInfo];
//    cv.textLabel.text = @"If you want to be notified about new Wireshark releases you should subscribe to the wireshark-announce mailing list.";
//    [self.view addSubview:cv];
//    @weakify(self);
//    [cv mas_updateConstraints:^(MASConstraintMaker *make) {
//      @strongify(self);
//      make.centerX.equalTo(self.view);
//      if ( prevView ) {
//        make.top.equalTo(prevView.mas_bottom).offset(10);
//      } else {
//        make.top.equalTo(self.view).offset(30);
//      }
//      make.width.equalTo(@(200.0));
//    }];
//    prevView = cv;
//  }
}

@end
