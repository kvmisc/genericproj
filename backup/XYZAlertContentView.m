//
//  XYZAlertContentView.m
//  GenericProj
//
//  Created by Kevin Wu on 13/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZAlertContentView.h"

@implementation XYZAlertContentView

- (void)presentInView:(UIView *)inView
{
  if ( self.superview ) { return; }
  if ( !inView ) { return; }

  XYZCoverView *coverView = [[XYZCoverView alloc] init];
  _coverView = coverView;
  [inView addSubview:coverView];

  @weakify(self);
  [_coverView mas_updateConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.edges.equalTo(self.coverView.superview);
  }];
  [inView layoutIfNeeded];

//  if ( viewport ) {
//    CGRect rect = [self.coverView.superview convertRect:viewport.bounds fromView:viewport];
//    [_coverView mas_updateConstraints:^(MASConstraintMaker *make) {
//      @strongify(self);
//      make.left.equalTo(self.coverView.superview).offset(rect.origin.x);
//      make.top.equalTo(self.coverView.superview).offset(rect.origin.y);
//      make.width.equalTo(@(rect.size.width));
//      make.height.equalTo(@(rect.size.height));
//    }];
//  } else {
//    [_coverView mas_updateConstraints:^(MASConstraintMaker *make) {
//      @strongify(self);
//      make.edges.equalTo(self.coverView.superview);
//    }];
//  }

  coverView.style = kXYZCoverViewStyleAlert;

  coverView.contentView = self;

  [self mas_updateConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.center.equalTo(self.superview);
  }];

  [coverView show:YES];
}

- (void)dismiss
{
  [_coverView hide:YES];
}

@end
