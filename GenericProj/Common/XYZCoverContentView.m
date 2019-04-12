//
//  XYZCoverContentView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "XYZCoverContentView.h"
#import "XYZCoverView.h"

@implementation XYZCoverContentView

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport
{
  // 要加到的视图为空，返回
  if ( !inView ) { return; }

  [_coverView cancelDelayHide];
  [_coverView updateStateFromAnimation:NO];
  [self updateStateFromAnimation:NO];
  _coverView.status = XYZCoverViewStatusUnknown;
  [_coverView removeAllAnimations];

  XYZCoverView *coverView = _coverView;
  if ( !coverView ) {
    // 无 coverView，创建
    coverView = [[XYZCoverView alloc] init];
    [inView addSubview:coverView];
    _coverView = coverView;
  } else {
    // 有 coverView
    if ( coverView.superview ) {
      // 已加入某个视图
      if ( coverView.superview==inView ) {
        // 本来就在 inView 上
      } else {
        // 在其它视图上
        [coverView removeFromSuperview];
        [inView addSubview:coverView];
      }
    } else {
      // 未加入任何视图，加入 inView
      [inView addSubview:coverView];
    }
  }
  if ( coverView.contentView!=self ) {
    [coverView.contentView removeFromSuperview];
    coverView.contentView = nil;
  }
  if ( self.superview!=coverView ) {
    [self removeFromSuperview];
    [coverView addSubview:self];
    coverView.contentView = self;
  }

  @weakify(self);
  if ( viewport ) {
    CGRect rect = [coverView.superview convertRect:viewport.bounds fromView:viewport];
    [coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.left.equalTo(self.coverView.superview).offset(rect.origin.x);
      make.top.equalTo(self.coverView.superview).offset(rect.origin.y);
      make.width.equalTo(@(rect.size.width));
      make.height.equalTo(@(rect.size.height));
    }];
  } else {
    [coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.edges.equalTo(self.coverView.superview);
    }];
  }
  [inView layoutIfNeeded];
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
