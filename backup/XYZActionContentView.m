//
//  XYZActionContentView.m
//  GenericProj
//
//  Created by Kevin Wu on 5/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZActionContentView.h"

#import "XYZCoverView.h"

@implementation XYZActionContentView

- (void)presentInView:(UIView *)inView
{
  if ( self.superview ) { return; }
  if ( !inView ) { return; }

  XYZCoverView *coverView = [[XYZCoverView alloc] init];
  _coverView = coverView;
  [inView addSubview:coverView];

  @weakify(inView);
  [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
    @strongify(inView);
    make.edges.equalTo(inView);
  }];
  [inView layoutIfNeeded];

  coverView.style = kXYZCoverViewStyleAction;

  coverView.contentView = self;

  [coverView show:YES];
}

- (void)dismiss
{
  [_coverView hide:YES];
}

@end
