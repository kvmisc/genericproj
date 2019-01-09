//
//  XYZOptionView.m
//  GenericProj
//
//  Created by Kevin Wu on 5/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZOptionView.h"

#define XYZ_OPTION_ANIMATION_DURATION_SHOW_SELF 0.25
#define XYZ_OPTION_ANIMATION_DURATION_SHOW_CONTENT 0.25

#define XYZ_OPTION_ANIMATION_DURATION_HIDE_SELF 0.25
#define XYZ_OPTION_ANIMATION_DURATION_HIDE_CONTENT 0.25



@interface XYZOptionView ()
@property (nonatomic, assign) BOOL showing;
@property (nonatomic, assign) BOOL presented;
@property (nonatomic, assign) BOOL hiding;
@end

@implementation XYZOptionView

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

    self.alpha = 0.0;

    _touchBackgroundToHide = YES;

    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    // TODO: 修改背景颜色
    _backgroundView.backgroundColor = TKRGBA(30, 30, 30, 0.5);
    [self addSubview:_backgroundView];
    _backgroundView.userInteractionEnabled = YES;
    UIGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_backgroundView addGestureRecognizer:gr];
    //_backgroundView.layer.borderColor = [[UIColor redColor] CGColor];
    //_backgroundView.layer.borderWidth = 1.0;
  }
  return self;
}

- (void)tap:(UIGestureRecognizer *)gr
{
  if ( _touchBackgroundToHide ) {
    [self hide:YES];
  }
}


- (void)updateConstraints
{
  @weakify(self);

  [_backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.edges.equalTo(self);
  }];

  [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.left.right.equalTo(self);
    if ( self.presented ) {
      make.bottom.equalTo(self);
    }
  }];

  [super updateConstraints];
}

- (void)setContentView:(UIView *)contentView
{
  if ( (!_showing) && (!_presented) && (!_hiding) ) {
    [self addSubview:contentView];
    _contentView = contentView;

    @weakify(self);
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.left.right.equalTo(self);
      make.top.equalTo(self.mas_bottom);
    }];
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
  _presented = YES;
  _showing = NO;
  [self setNeedsUpdateConstraints];
}
- (void)showSelf
{
  _showing = YES;
  @weakify(self);
  [UIView animateWithDuration:XYZ_OPTION_ANIMATION_DURATION_SHOW_SELF
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

  [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.left.right.equalTo(self);
    make.bottom.equalTo(self);
  }];

  [UIView animateWithDuration:XYZ_OPTION_ANIMATION_DURATION_SHOW_CONTENT
                   animations:^{
                     @strongify(self);
                     [self layoutIfNeeded];
                   } completion:^(BOOL finished) {
                     @strongify(self);
                     self.presented = YES;
                     self.showing = NO;
                   }];
}


- (void)hide:(BOOL)animated
{
  if ( _presented ) {
    if ( animated ) {
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
  [self removeFromSuperview];
  _hiding = NO;
}
- (void)hideContent
{
  _hiding = YES;
  _presented = NO;
  @weakify(self);
  [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.left.right.equalTo(self);
    make.top.equalTo(self.mas_bottom);
  }];
  [UIView animateWithDuration:XYZ_OPTION_ANIMATION_DURATION_HIDE_CONTENT
                   animations:^{
                     @strongify(self);
                     [self layoutIfNeeded];
                   } completion:^(BOOL finished) {
                     @strongify(self);
                     [self hideSelf];
                   }];
}
- (void)hideSelf
{
  @weakify(self);
  [UIView animateWithDuration:XYZ_OPTION_ANIMATION_DURATION_HIDE_SELF
                   animations:^{
                     @strongify(self);
                     self.alpha = 0.0;
                   } completion:^(BOOL finished) {
                     @strongify(self);
                     [self removeFromSuperview];
                     self.hiding = NO;
                   }];
}

@end
