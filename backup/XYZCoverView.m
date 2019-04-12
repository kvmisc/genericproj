//
//  XYZCoverView.m
//  GenericProj
//
//  Created by Kevin Wu on 12/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZCoverView.h"

/* [CONFIGURABLE_VALUE] */
#define DURATION_SHOW_SELF    0.08
#define DURATION_SHOW_CONTENT 0.12
#define DURATION_HIDE_CONTENT 0.12
#define DURATION_HIDE_SELF    0.08

@implementation XYZCoverView {
  CADisplayLink *_displayLink;
  NSMutableDictionary *_animation;
  CGFloat _beginAlpha;
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



- (void)removeAllAnimations
{
  _animation = nil;

  _displayLink.paused = YES;
  [_displayLink invalidate];
  _displayLink = nil;
}

- (void)setUpDisplayLinkIfNeeded
{
  if ( !_displayLink ) {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    _displayLink.paused = YES;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
  }
  if ( _displayLink.paused ) {
    _displayLink.paused = NO;
  }
}

- (void)tick:(CADisplayLink *)displayLink
{
  if ( _status==XYZCoverViewStatusShowing ) {
    CFTimeInterval duration1 = [[_animation objectForKey:@"duration1"] doubleValue];
    CFTimeInterval duration2 = [[_animation objectForKey:@"duration2"] doubleValue];
    CFTimeInterval startTime = [[_animation objectForKey:@"startTime"] doubleValue];

    CFTimeInterval currentTime = CACurrentMediaTime();
    CFTimeInterval interval = currentTime - startTime;

    if ( interval<=duration1 ) {
      // 正在显示 self
      CGFloat progress = [XYZGlobal boundFlt:interval/duration1 left:0.0 right:1.0];
      self.alpha = _beginAlpha + progress * (1.0-_beginAlpha);
      XYZLogDebug(@"CoverView", @"%.04f - %.04f = %.04f / %.04f = %.04f", currentTime, startTime, interval, duration1, progress);
    } else if ( interval<=(duration1+duration2) ) {
      // 正在显示 contentView
      if ( _contentView.showAnimation ) {
        CGFloat progress = [XYZGlobal boundFlt:(interval-duration1)/duration2 left:0.0 right:1.0];
        _contentView.showAnimation(progress);
        XYZLogDebug(@"CoverView", @"%.04f - %.04f = (%.04f - %.04f) / %.04f = %.04f", currentTime, startTime, interval, duration1, duration2, progress);
      }
    } else {
      // 完成显示
      [self removeAllAnimations];
      self.alpha = 1.0;
      if ( _contentView.showAnimation ) { _contentView.showAnimation(1.0); }
      _status = XYZCoverViewStatusPresented;
    }

    return;
  }

  if ( _status==XYZCoverViewStatusHiding ) {
    CFTimeInterval duration1 = [[_animation objectForKey:@"duration1"] doubleValue];
    CFTimeInterval duration2 = [[_animation objectForKey:@"duration2"] doubleValue];
    CFTimeInterval startTime = [[_animation objectForKey:@"startTime"] doubleValue];

    CFTimeInterval currentTime = CACurrentMediaTime();
    CFTimeInterval interval = currentTime - startTime;

    if ( interval<=duration1 ) {
      // 正在隐藏 contentView
      if ( _contentView.hideAnimation ) {
        CGFloat progress = [XYZGlobal boundFlt:interval/duration1 left:0.0 right:1.0];
        _contentView.hideAnimation(progress);
        XYZLogDebug(@"CoverView", @"%.04f - %.04f = %.04f / %.04f = %.04f", currentTime, startTime, interval, duration1, progress);
      }
    } else if ( interval<=(duration1+duration2) ) {
      // 正在隐藏 self
      CGFloat progress = [XYZGlobal boundFlt:(interval-duration1)/duration2 left:0.0 right:1.0];
      self.alpha = _beginAlpha + progress * (0.0-_beginAlpha);
      XYZLogDebug(@"CoverView", @"%.04f - %.04f = (%.04f - %.04f) / %.04f = %.04f", currentTime, startTime, interval, duration1, duration2, progress);
    } else {
      // 完成隐藏
      [self removeAllAnimations];
      self.alpha = 0.0;
      if ( _contentView.hideAnimation ) { _contentView.hideAnimation(1.0); }
      [self removeFromSuperview];
      _status = XYZCoverViewStatusUnknown;
      if ( _completion ) { _completion(); }
      XYZLogDebug(@"CoverView", @"hide done");
    }

    return;
  }

  [self removeAllAnimations];
}



- (void)prepareForPresent
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self];

  [self removeAllAnimations];
}

- (void)prepareForAnimation
{
  _beginAlpha = self.alpha;
  [_contentView prepareForAnimation];
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

- (void)addContentView:(XYZCoverContentView *)contentView
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
    if ( _contentView.showAnimation ) {
      _contentView.showAnimation(0.0);
    }
  }
}

- (void)show:(BOOL)animated
{
  // 取消之前可能已经调度的延迟隐藏请求
  [NSObject cancelPreviousPerformRequestsWithTarget:self];

  if ( _status==XYZCoverViewStatusShowing ) {
    // 正在显示，不管
  } else if ( _status==XYZCoverViewStatusPresented ) {
    // 已经显示，不管
  } else {
    if ( _status==XYZCoverViewStatusHiding ) {
      // 正在隐藏，启动显示，里面会保存状态且取消隐藏动画
    }
    // 显示
    [self doShow:animated];
  }
}
- (void)doShow:(BOOL)animated
{
  [self removeAllAnimations];
  [self prepareForAnimation];

  _status = XYZCoverViewStatusShowing;

  if ( animated ) {

    _animation = [[NSMutableDictionary alloc] init];
    [_animation setObject:[NSNumber numberWithDouble:DURATION_SHOW_SELF] forKey:@"duration1"];
    [_animation setObject:[NSNumber numberWithDouble:DURATION_SHOW_CONTENT] forKey:@"duration2"];
    CFTimeInterval currentTime = CACurrentMediaTime();
    XYZLogDebug(@"CoverView", @"current:%.04f", currentTime);
    [_animation setObject:[NSNumber numberWithDouble:currentTime] forKey:@"startTime"];

    [self setUpDisplayLinkIfNeeded];

  } else {

    self.alpha = 1.0;
    if ( _contentView.showAnimation ) { _contentView.showAnimation(1.0); }
    _status = XYZCoverViewStatusPresented;

  }
}

- (void)hide:(BOOL)animated
{
  [self hide:animated afterDelay:0.0];
}
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
  // 不管是延迟隐藏还是直接隐藏，都应该取消之前可能已经调度的延迟隐藏请求
  [NSObject cancelPreviousPerformRequestsWithTarget:self];

  // 没加到任何视图上，直接返回
  if ( !(self.superview) ) { return; }

  if ( delay>0.0 ) {
    if ( _status==XYZCoverViewStatusShowing ) {
      // 正在显示，用户调用显示功能的时候应该允许他马上启动延迟隐藏
      [self performSelector:@selector(delayHide:) withObject:@(animated) afterDelay:delay];
    } else if ( _status==XYZCoverViewStatusPresented ) {
      // 已经显示，可以启动延迟隐藏
      [self performSelector:@selector(delayHide:) withObject:@(animated) afterDelay:delay];
    } else {
      if ( _status==XYZCoverViewStatusHiding ) {
        // 正在隐藏，让它自己继续隐藏
        //
      } else {
        // 加到父视图还没显示过，或已经被隐藏，直接移除视图并通知
        [self delayHide:@(NO)];
      }
    }

  } else {
    [self delayHide:@(animated)];
  }
}
- (void)delayHide:(id)object
{
  if ( [object boolValue] ) {
    // 需要动画
    if ( _status==XYZCoverViewStatusShowing ) {
      // 正在显示，启动隐藏，里面会保存状态且取消动画
      [self doHide:YES];
    } else if ( _status==XYZCoverViewStatusPresented ) {
      // 已经显示，启动隐藏，里面会保存状态且取消动画
      [self doHide:YES];
    } else if ( _status==XYZCoverViewStatusHiding ) {
      // 正在隐藏，不管它
    } else {
      // 加到父视图还没显示过，或已经被隐藏，直接移除视图并通知
      [self doHide:NO];
    }
  } else {
    // 不要动画，直接移除视图并通知
    [self doHide:NO];
  }
}
- (void)doHide:(BOOL)animated
{
  [self removeAllAnimations];
  [self prepareForAnimation];

  _status = XYZCoverViewStatusHiding;

  if ( animated ) {

    _animation = [[NSMutableDictionary alloc] init];
    [_animation setObject:[NSNumber numberWithDouble:DURATION_HIDE_CONTENT] forKey:@"duration1"];
    [_animation setObject:[NSNumber numberWithDouble:DURATION_HIDE_SELF] forKey:@"duration2"];
    CFTimeInterval currentTime = CACurrentMediaTime();
    XYZLogDebug(@"CoverView", @"current:%.04f", currentTime);
    [_animation setObject:[NSNumber numberWithDouble:currentTime] forKey:@"startTime"];

    [self setUpDisplayLinkIfNeeded];

  } else {

    [self removeFromSuperview];
    _status = XYZCoverViewStatusUnknown;
    if ( _completion ) { _completion(); }
    XYZLogDebug(@"CoverView", @"hide done");

  }
}

@end
