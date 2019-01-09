//
//  XYZProgressHUD.m
//  GenericProj
//
//  Created by Kevin Wu on 1/10/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZProgressHUD.h"

// [CONFIGURABLE_VALUE]
#define XYZ_HUD_ANIMATION_DURATION_SHOW_SELF 0.25
#define XYZ_HUD_ANIMATION_DURATION_SHOW_CONTENT 0.25

#define XYZ_HUD_ANIMATION_DURATION_HIDE_SELF 0.25
#define XYZ_HUD_ANIMATION_DURATION_HIDE_CONTENT 0.25


#define XYZ_HUD_CONTENT_MARGIN_HORIZONTAL 30.0


@interface XYZProgressHUD ()
@property (nonatomic, assign) BOOL showing;
@property (nonatomic, assign) BOOL presented;
@property (nonatomic, assign) BOOL hiding;
@end


@implementation XYZProgressHUD

+ (BOOL)requiresConstraintBasedLayout
{
  return YES;
}

- (id)init
{
  self = [super init];
  if (self) {
    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.backgroundColor = [UIColor clearColor];

    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    // TODO: 修改背景颜色
    _backgroundView.backgroundColor = TKRGBA(30, 30, 30, 0.5);
    [self addSubview:_backgroundView];
//    _backgroundView.layer.borderColor = [[UIColor redColor] CGColor];
//    _backgroundView.layer.borderWidth = 1.0;

    _contentView = [[XYZProgressHUDContentView alloc] init];
    _contentView.alpha = 0.0;
    [self addSubview:_contentView];


    _marginHorizontal = XYZ_HUD_CONTENT_MARGIN_HORIZONTAL;
    
    _marginTop = -1.0;
    _marginBottom = -1.0;
  }
  return self;
}

- (void)updateConstraints
{
  @weakify(self);

  [_backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.edges.equalTo(self);
  }];

  [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.centerX.equalTo(self);
    if ( self.marginTop<0.0 ) {
      if ( self.marginBottom<0.0 ) {
        // 同时小于0.0，居中显示
        make.centerY.equalTo(self);
      } else {
        // 底部大于等于0.0，靠底部
        make.bottom.equalTo(self).offset(0.0-self.marginBottom);
      }
    } else {
      // 顶部大于等于0.0，顶部优先，不管底部，靠顶部
      make.top.equalTo(self).offset(self.marginTop);
    }
    if ( self.marginHorizontal>0.0 ) {
      make.left.greaterThanOrEqualTo(self).offset(self.marginHorizontal);
    }
  }];

  [super updateConstraints];
}

- (void)setCustomContentView:(UIView *)customContentView
{
  if ( customContentView ) {
    _contentView.hidden = YES;
    if ( _customContentView!=customContentView ) {
      [_customContentView removeFromSuperview];
      [self addSubview:customContentView];
      _customContentView = customContentView;
    }
  } else {
    _contentView.hidden = NO;
    [_customContentView removeFromSuperview];
    _customContentView = nil;
  }
}


- (void)updateViewport:(UIView *)viewport
{
  if ( viewport ) {
    CGRect rect = [self.superview convertRect:viewport.bounds fromView:viewport];
    @weakify(self);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.left.equalTo(self.superview).offset(rect.origin.x);
      make.top.equalTo(self.superview).offset(rect.origin.y);
      make.width.equalTo(@(rect.size.width));
      make.height.equalTo(@(rect.size.height));
    }];
  } else {
    @weakify(self);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.edges.equalTo(self.superview);
    }];
  }
}

- (void)updateEvent
{
  [_contentView.cancelButton addTarget:self
                                action:@selector(cancelButtonClicked:)
                      forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelButtonClicked:(id)sender
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self];

  if ( _cancelHandler ) {
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
      @strongify(self);
      [self removeFromSuperview];
      self.cancelHandler();
    });
  } else {
    [self removeFromSuperview];
  }
}


- (BOOL)show:(BOOL)animated
{
  if ( _showing ) {
    // 正在显示，返回
    return YES;
  }
  if ( _presented ) {
    // 已经显示完成，返回
    return YES;
  }
  if ( _hiding ) {
    // 正在隐藏，返回
    return NO;
  }

  if ( animated ) {
    [self showSelf];
  } else {
    [self show];
  }

  return YES;
}
- (void)show
{
  _showing = YES;
  self.alpha = 1.0;
  [(_customContentView?:_contentView) setAlpha:1.0];
  _presented = YES;
  _showing = NO;
}
- (void)showSelf
{
  _showing = YES;
  @weakify(self);
  [UIView animateWithDuration:XYZ_HUD_ANIMATION_DURATION_SHOW_SELF
                   animations:^{
                     @strongify(self);
                     self.alpha = 1.0;
                   } completion:^(BOOL finished) {
                     @strongify(self);
                     [self showContent];
                   }];
}
- (void)showContent
{
  @weakify(self);
  [UIView animateWithDuration:XYZ_HUD_ANIMATION_DURATION_SHOW_CONTENT
                   animations:^{
                     @strongify(self);
                     [(self.customContentView?:self.contentView) setAlpha:1.0];
                   } completion:^(BOOL finished) {
                     @strongify(self);
                     self.presented = YES;
                     self.showing = NO;
                   }];
}

- (void)hide:(BOOL)animated
{
  [self hide:animated afterDelay:0.0];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
  // 不管是延迟隐藏还是直接隐藏，都应该取消之前可能已经调度的隐藏请求
  [NSObject cancelPreviousPerformRequestsWithTarget:self];

  if ( delay>0.0 ) {
    // 正在显示或者已经显示完成的时候可以启动延迟隐藏
    if ( _showing || _presented ) {
      [self performSelector:@selector(delayHide:) withObject:@(animated) afterDelay:delay];
    }
  } else {
    [self delayHide:@(animated)];
  }
}
- (void)delayHide:(id)object
{
  if ( _presented ) {
    if ( [object boolValue] ) {
      [self hideContent];
    } else {
      [self hide];
    }
  }
}
- (void)hide
{
  _hiding = YES;
  _presented = NO;
  [self notifyAndClear];
  _hiding = NO;
}
- (void)hideContent
{
  _hiding = YES;
  _presented = NO;
  @weakify(self);
  [UIView animateWithDuration:XYZ_HUD_ANIMATION_DURATION_HIDE_CONTENT
                   animations:^{
                     @strongify(self);
                     [(self.customContentView?:self.contentView) setAlpha:0.0];
                   } completion:^(BOOL finished) {
                     @strongify(self);
                     [self hideSelf];
                   }];
}
- (void)hideSelf
{
  @weakify(self);
  [UIView animateWithDuration:XYZ_HUD_ANIMATION_DURATION_HIDE_SELF
                   animations:^{
                     @strongify(self);
                     self.alpha = 0.0;
                   } completion:^(BOOL finished) {
                     @strongify(self);
                     [self notifyAndClear];
                     self.hiding = NO;
                   }];
}
- (void)notifyAndClear
{
  if ( _completeHandler ) {
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
      @strongify(self);
      [self removeFromSuperview];
      self.completeHandler();
    });
  } else {
    [self removeFromSuperview];
  }
}

@end
