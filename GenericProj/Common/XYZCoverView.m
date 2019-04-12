//
//  XYZCVView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "XYZCVView.h"

/* [CONFIGURABLE_VALUE] */
//#define DURATION_SHOW_SELF    3.0
//#define DURATION_SHOW_CONTENT 5.0
//#define DURATION_HIDE_CONTENT 5.0
//#define DURATION_HIDE_SELF    3.0
#define DURATION_SHOW_SELF    0.12
#define DURATION_SHOW_CONTENT 0.25
#define DURATION_HIDE_CONTENT 0.25
#define DURATION_HIDE_SELF    0.12

@interface XYZCVView () <
    CAAnimationDelegate
>

@end

@implementation XYZCVView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup
{
  self.backgroundColor = [UIColor clearColor];
  self.clipsToBounds = YES;
  self.alpha = 0.0;

  _backgroundView = [[UIImageView alloc] init];
  _backgroundView.backgroundColor = TKRGBA(0, 0, 0, 0.20);
  [self addSubview:_backgroundView];

  _touchBackgroundToHide = YES;
  _backgroundView.userInteractionEnabled = YES;
  UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
  [_backgroundView addGestureRecognizer:recognizer];
}

- (void)tap:(UIGestureRecognizer *)recognizer
{
  if ( _touchBackgroundToHide ) {
    [self hide:YES];
  }
}

- (void)updateConstraints
{
  @weakify(self);
  [_backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.edges.equalTo(self);
  }];

  [super updateConstraints];
}

#ifdef DEBUG
- (void)dealloc { XYZPrintMethod(); }
#endif


- (void)cancelDelayHide
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)updateStateFromAnimation:(BOOL)completion
{
  // 只有在有动画的时候才能将状态同步过去
  if ( completion ) {
    if ( _status==XYZCVViewStatusShowing ) {
      self.layer.opacity = 1.0;
    } else if ( _status==XYZCVViewStatusHiding ) {
      self.layer.opacity = 0.0;
    }
  } else {
    if ( (_status==XYZCVViewStatusShowing) || (_status==XYZCVViewStatusHiding) ) {
      if ( self.layer.presentationLayer ) {
        self.layer.opacity = self.layer.presentationLayer.opacity;
      }
    }
  }
}

- (void)removeAllAnimations
{
  [self.layer removeAnimationForKey:@"ShowSelf"];
  [_contentView.layer removeAnimationForKey:@"ShowContent"];
  [_contentView.layer removeAnimationForKey:@"HideContent"];
  [self.layer removeAnimationForKey:@"HideSelf"];
}

- (void)layoutForViewport:(UIView *)viewport
{
  if ( self.superview ) {
    @weakify(self);
    if ( viewport ) {
      CGRect rect = [self.superview convertRect:viewport.bounds fromView:viewport];
      [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.superview).offset(rect.origin.x);
        make.top.equalTo(self.superview).offset(rect.origin.y);
        make.width.equalTo(@(rect.size.width));
        make.height.equalTo(@(rect.size.height));
      }];
    } else {
      [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.superview);
      }];
    }
  }
}

- (void)addContentView:(XYZCVContentView *)contentView
{
  if ( contentView!=_contentView ) {
    [_contentView removeFromSuperview];
    _contentView = nil;
  }
  if ( contentView ) {
    if ( contentView.superview!=self ) {
      [contentView removeFromSuperview];
      [self addSubview:contentView];
      _contentView = contentView;
    }
  }
}


- (void)animationDidStart:(CAAnimation *)anim
{
  XYZLogDebug(@"CoverView", @"animation start: %@", anim);
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  if ( anim==[self.layer animationForKey:@"ShowSelf"] ) {
    XYZLogDebug(@"CoverView", @"show self stop: %@", anim);
    [self updateStateFromAnimation:flag];
    if ( flag ) {
      // 已完成 ShowSelf，启动 ShowContent
      CAAnimation *animation = [_contentView showAnimation];
      if ( animation.duration<=0.0 ) {
        animation.duration = DURATION_SHOW_CONTENT;
      }
      animation.delegate = self;
      animation.removedOnCompletion = NO;
      animation.fillMode = kCAFillModeForwards;
      [_contentView.layer addAnimation:animation forKey:@"ShowContent"];
    } else {
      // 未完成 ShowSelf，非程序取消，置于 ShowFailed 状态
      _status = XYZCVViewStatusShowFailed;
    }
    [self.layer removeAnimationForKey:@"ShowSelf"];
    return;
  }

  if ( anim==[_contentView.layer animationForKey:@"ShowContent"] ) {
    XYZLogDebug(@"CoverView", @"show content stop: %@", anim);
    [_contentView updateStateFromAnimation:flag];
    if ( flag ) {
      // 已完成 ShowContent，置于 Presented 状态
      _status = XYZCVViewStatusPresented;
    } else {
      // 未完成 ShowContent，非程序取消，置于 ShowFailed 状态
      _status = XYZCVViewStatusShowFailed;
    }
    [_contentView.layer removeAnimationForKey:@"ShowContent"];
    return;
  }

  if ( anim==[_contentView.layer animationForKey:@"HideContent"] ) {
    XYZLogDebug(@"CoverView", @"hide content stop: %@", anim);
    [_contentView updateStateFromAnimation:flag];
    if ( flag ) {
      // 已完成 HideContent，启动 HideSelf
      CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
      animation.fromValue = @(self.layer.opacity);
      animation.toValue = @(0.0);
      animation.duration = DURATION_HIDE_SELF;
      animation.removedOnCompletion = NO;
      animation.fillMode = kCAFillModeForwards;
      animation.delegate = self;
      [self.layer addAnimation:animation forKey:@"HideSelf"];
    } else {
      // 未完成 HideContent，非程序取消，置于 HideFailed 状态
      _status = XYZCVViewStatusHideFailed;
    }
    [_contentView.layer removeAnimationForKey:@"HideContent"];
    return;
  }

  if ( anim==[self.layer animationForKey:@"HideSelf"] ) {
    XYZLogDebug(@"CoverView", @"hide self stop: %@", anim);
    [self updateStateFromAnimation:flag];
    if ( flag ) {
      // 已完成 HideSelf，置于 Unknown 状态
      _status = XYZCVViewStatusUnknown;
    } else {
      // 未完成 HideSelf，非程序取消，置于 HideFailed 状态
      _status = XYZCVViewStatusHideFailed;
    }
    [self.layer removeAnimationForKey:@"HideSelf"];

    [self removeFromSuperview];
    if ( _completion ) { _completion(); }
    XYZLogDebug(@"CoverView", @"hide done");
    return;
  }
}



- (void)show:(BOOL)animated
{
  // 取消之前可能已经调度的延迟隐藏请求
  [self cancelDelayHide];

  if ( animated ) {
    // 需要动画
    if ( _status==XYZCVViewStatusShowing ) {
      // 正在显示，不管
    } else if ( _status==XYZCVViewStatusShowFailed ) {
      // 显示失败，重启显示
      [self doShow:YES];
    } else if ( _status==XYZCVViewStatusPresented ) {
      // 已经显示，不管
    } else if ( _status==XYZCVViewStatusHiding ) {
      // 正在隐藏，保存视图状态且取消隐藏动画，启动显示
      [self updateStateFromAnimation:NO];
      [_contentView updateStateFromAnimation:NO];
      // 为了防止移除动画时候再保存视图状态，置为 Unknown 状态
      _status = XYZCVViewStatusUnknown;
      [self removeAllAnimations];
      [self doShow:YES];
    } else if ( _status==XYZCVViewStatusHideFailed ) {
      // 隐藏失败，启动显示
      [self doShow:YES];
    } else {
      [self doShow:YES];
    }
  } else {
    // 不要动画，保存视图状态且取消动画，启动显示
    [self updateStateFromAnimation:NO];
    [_contentView updateStateFromAnimation:NO];
    // 为了防止移除动画时候再保存视图状态，置为 Unknown 状态
    _status = XYZCVViewStatusUnknown;
    [self removeAllAnimations];
    [self doShow:NO];
  }
}
- (void)doShow:(BOOL)animated
{
  _status = XYZCVViewStatusShowing;

  if ( animated ) {

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(self.layer.opacity);
    animation.toValue = @(1.0);
    animation.duration = DURATION_SHOW_SELF;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:@"ShowSelf"];

  } else {

    [self updateStateFromAnimation:YES];
    [_contentView updateStateFromAnimation:YES];
    _status = XYZCVViewStatusPresented;

  }
}

- (void)hide:(BOOL)animated
{
  [self hide:animated afterDelay:0.0];
}
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
  // 不管是延迟隐藏还是直接隐藏，都应该取消之前可能已经调度的延迟隐藏请求
  [self cancelDelayHide];

  // 没加到任何视图上，直接返回
  if ( !(self.superview) ) { return; }

  if ( delay>0.0 ) {
    if ( _status==XYZCVViewStatusShowing ) {
      // 正在显示，用户调用显示功能的时候应该允许他马上启动延迟隐藏
      [self performSelector:@selector(delayHide:) withObject:@(animated) afterDelay:delay];
    } else if ( _status==XYZCVViewStatusShowFailed ) {
      // 显示失败，可以启动延迟隐藏
      [self performSelector:@selector(delayHide:) withObject:@(animated) afterDelay:delay];
    } else if ( _status==XYZCVViewStatusPresented ) {
      // 已经显示，可以启动延迟隐藏
      [self performSelector:@selector(delayHide:) withObject:@(animated) afterDelay:delay];
    } else if ( _status==XYZCVViewStatusHiding ) {
      // 正在隐藏，让它自己继续隐藏
      // 要不要取消这次隐藏，再延迟隐藏呢？
    } else if ( _status==XYZCVViewStatusHideFailed ) {
      // 隐藏失败，可以启动延迟隐藏
      [self performSelector:@selector(delayHide:) withObject:@(animated) afterDelay:delay];
    } else {
      [self performSelector:@selector(delayHide:) withObject:@(animated) afterDelay:delay];
    }
  } else {
    [self delayHide:@(animated)];
  }
}
- (void)delayHide:(id)object
{
  if ( [object boolValue] ) {
    // 需要动画
    if ( _status==XYZCVViewStatusShowing ) {
      // 正在显示，保存视图状态且取消显示动画，启动隐藏
      [self updateStateFromAnimation:NO];
      [_contentView updateStateFromAnimation:NO];
      // 为了防止移除动画时候再保存视图状态，置为 Unknown 状态
      _status = XYZCVViewStatusUnknown;
      [self removeAllAnimations];
      [self doHide:YES];
    } else if ( _status==XYZCVViewStatusShowFailed ) {
      // 显示失败，启动隐藏
      [self doHide:YES];
    } else if ( _status==XYZCVViewStatusPresented ) {
      // 已经显示，启动隐藏
      [self doHide:YES];
    } else if ( _status==XYZCVViewStatusHiding ) {
      // 正在隐藏，不管它
    } else if ( _status==XYZCVViewStatusHideFailed ) {
      // 隐藏失败，重启隐藏
      [self doHide:YES];
    } else {
      [self doHide:YES];
    }
  } else {
    // 不要动画，保存视图状态且取消动画，启动隐藏
    [self updateStateFromAnimation:NO];
    [_contentView updateStateFromAnimation:NO];
    // 为了防止移除动画时候再保存视图状态，置为 Unknown 状态
    _status = XYZCVViewStatusUnknown;
    [self removeAllAnimations];
    [self doHide:NO];
  }
}
- (void)doHide:(BOOL)animated
{
  [self cancelDelayHide];

  _status = XYZCVViewStatusHiding;

  if ( animated ) {

    CAAnimation *animation = [_contentView hideAnimation];
    if ( animation.duration<=0.0 ) {
      animation.duration = DURATION_HIDE_CONTENT;
    }
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [_contentView.layer addAnimation:animation forKey:@"HideContent"];

  } else {

    [self updateStateFromAnimation:YES];
    [_contentView updateStateFromAnimation:YES];
    _status = XYZCVViewStatusUnknown;
    [self removeFromSuperview];
    if ( _completion ) { _completion(); }
    XYZLogDebug(@"CoverView", @"hide done");

  }
}

@end
