//
//  XYZCVContentView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "XYZCVContentView.h"
#import "XYZCVView.h"

@implementation XYZCVContentView

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport
{
  // 要加到的视图为空，返回
  if ( !inView ) { return; }
  // 已经有 coverView，但 coverView 已经加到其它视图上，返回
  if ( (_coverView.superview) && (_coverView.superview!=inView) ) { return; }

  [_coverView cancelDelayHide];
  [_coverView updateStateFromAnimation:NO];
  [self updateStateFromAnimation:NO];
  // status = unknown
  [_coverView removeAllAnimations];

  XYZCVView *coverView = _coverView;
  if ( !coverView ) {
    coverView = [[XYZCVView alloc] init];
    [inView addSubview:coverView];
    _coverView = coverView;
  }

  [coverView layoutForViewport:viewport];
  [inView layoutIfNeeded];

  [coverView addContentView:self];
}


- (void)updateStateFromAnimation:(BOOL)completion
{
}
- (CAAnimation *)showAnimation
{
  return nil;
}
- (CAAnimation *)hideAnimation
{
  return nil;
}

@end
