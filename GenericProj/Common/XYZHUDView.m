//
//  XYZHUDView.m
//  GenericProj
//
//  Created by Kevin Wu on 13/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZHUDView.h"

/* [CONFIGURABLE_VALUE] */
#define PADDING_X 5.0
#define PADDING_Y 5.0
#define SPACING_X 5.0

@interface XYZHUDView ()
@property (nonatomic, assign) CGFloat beginAlpha;
@end

@implementation XYZHUDView

- (void)setup
{
  [super setup];

  self.backgroundColor = [UIColor clearColor];
  self.alpha = 0.0;

  _backgroundView = [[UIImageView alloc] init];
  _backgroundView.backgroundColor = [UIColor darkGrayColor];
  [self addSubview:_backgroundView];

  _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  _activityView.hidesWhenStopped = NO;
  [_activityView startAnimating];

  _textLabel = [[UILabel alloc] init];
  _textLabel.font = [UIFont systemFontOfSize:14.0];
  _textLabel.textColor = [UIColor whiteColor];
  _textLabel.textAlignment = NSTextAlignmentLeft;
  _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  _textLabel.numberOfLines = 1;
  _textLabel.backgroundColor = [UIColor clearColor];

  _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_cancelButton setImage:[UIImage imageNamed:@"hud_cancel"] forState:UIControlStateNormal];
  [_cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

//  _activityView.layer.borderColor = [[UIColor blueColor] CGColor];
//  _activityView.layer.borderWidth = 1.0;
//  _textLabel.layer.borderColor = [[UIColor blueColor] CGColor];
//  _textLabel.layer.borderWidth = 1.0;
//  _cancelButton.layer.borderColor = [[UIColor blueColor] CGColor];
//  _cancelButton.layer.borderWidth = 1.0;
}

- (void)buttonClicked:(id)sender
{
  [self.coverView hide:NO];
  if ( _cancellation ) {
    _cancellation();
  }
}

- (void)updateConstraints
{
  @weakify(self);

  [_backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.edges.equalTo(self);
  }];

  if ( _activityView.superview==self ) {
    [_activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.left.equalTo(self).offset(PADDING_X);
      make.centerY.equalTo(self);
      make.top.equalTo(self).offset(PADDING_Y);
      if ( !(self.textLabel.superview) && !(self.cancelButton.superview) ) {
        make.right.equalTo(self).offset(-PADDING_X);
      }
    }];
  }

  if ( _textLabel.superview==self ) {
    [_textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      if ( self.textLabel.numberOfLines==1 ) {
        make.left.equalTo(self.activityView.mas_right).offset(SPACING_X);
        make.centerY.equalTo(self);
        if ( !(self.cancelButton.superview) ) {
          make.right.equalTo(self).offset(-PADDING_X);
        }
      } else {
        UIEdgeInsets insets = UIEdgeInsetsMake(PADDING_Y, PADDING_X, PADDING_Y, PADDING_X);
        make.edges.equalTo(self).insets(insets);
      }
    }];
  }

  if ( _cancelButton.superview==self ) {
    [_cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.left.equalTo(self.textLabel.mas_right).offset(SPACING_X);
      make.centerY.equalTo(self);
      make.right.equalTo(self).offset(-PADDING_X);
    }];
  }

  [super updateConstraints];
}

- (void)configWithActivity:(BOOL)activity text:(NSString *)text cancel:(void (^)(void))cancel
{
  [_activityView removeFromSuperview];
  [_textLabel removeFromSuperview];
  [_cancelButton removeFromSuperview];

  self.cancellation = cancel;

  _textLabel.text = text;

  if ( activity ) {
    if ( cancel ) {
      // Cancellation
      [self addSubview:_activityView];
      [self addSubview:_textLabel];
      _textLabel.numberOfLines = 1;
      _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
      [self addSubview:_cancelButton];
    } else {
      if ( text.length>0 ) {
        // Text
        [self addSubview:_activityView];
        [self addSubview:_textLabel];
        _textLabel.numberOfLines = 1;
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_cancelButton removeFromSuperview];
      } else {
        // Activity
        [self addSubview:_activityView];
        [_textLabel removeFromSuperview];
        [_cancelButton removeFromSuperview];
      }
    }
  } else {
    // Info
    [_activityView removeFromSuperview];
    [self addSubview:_textLabel];
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_cancelButton removeFromSuperview];
  }

  [self setNeedsUpdateConstraints];
}

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport
{
  [super prepareForView:inView viewport:viewport];

  @weakify(self);

  self.showAnimation = ^(CGFloat progress) {
    @strongify(self);
    CGFloat value = self.beginAlpha + progress * (1.0-self.beginAlpha);
    self.alpha = value;
  };

  self.hideAnimation = ^(CGFloat progress) {
    @strongify(self);
    CGFloat value = self.beginAlpha + progress * (0.0-self.beginAlpha);
    self.alpha = value;
  };

  [self mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.center.equalTo(self.superview);
    make.width.lessThanOrEqualTo(self.superview).offset(-40.0);
  }];
}

- (void)prepareForAnimation
{
  _beginAlpha = self.alpha;
}

@end
