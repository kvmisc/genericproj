//
//  XYZCoverContentView.m
//  GenericProj
//
//  Created by Kevin Wu on 13/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZCoverContentView.h"

#import "XYZCoverView.h"

@implementation XYZCoverContentView

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport
{
  // 要加到的视图为空，返回
  if ( !inView ) { return; }
  // 已经有 coverView，但 coverView 已经加到其它视图上，返回
  if ( (_coverView.superview) && (_coverView.superview!=inView) ) { return; }

  XYZCoverView *coverView = _coverView;
  if ( !coverView ) {
    coverView = [[XYZCoverView alloc] init];
    [inView addSubview:coverView];
    _coverView = coverView;
  }

  [coverView prepareForPresent];

  [coverView layoutForViewport:viewport];
  [inView layoutIfNeeded];

  [coverView addContentView:self];
}

- (void)prepareForAnimation
{
}

@end
