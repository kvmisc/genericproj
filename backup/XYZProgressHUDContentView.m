//
//  XYZProgressHUDContentView.m
//  GenericProj
//
//  Created by Kevin Wu on 3/14/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZProgressHUDContentView.h"

// [CONFIGURABLE_VALUE]
#define XYZ_HUD_CONTENT_PADDING_HORIZONTAL 5.0
#define XYZ_HUD_CONTENT_PADDING_VERTICAL 5.0

#define XYZ_HUD_CONTENT_SPACING_AT 5.0
#define XYZ_HUD_CONTENT_SPACING_TC 5.0
#define XYZ_HUD_CONTENT_SPACING_AC 5.0

#define XYZ_HUD_CONTENT_TEXT_HEIGHT 24.0

#define XYZ_HUD_CONTENT_CANCEL_WIDTH 18.0
#define XYZ_HUD_CONTENT_CANCEL_HEIGHT 18.0


@implementation XYZProgressHUDContentView

- (id)init
{
  self = [super init];
  if (self) {

    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.backgroundColor = [UIColor clearColor];


    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    // TODO: 修改背景颜色，增加图片
    _backgroundView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_backgroundView];
//    _backgroundView.layer.borderColor = [[UIColor redColor] CGColor];
//    _backgroundView.layer.borderWidth = 1.0;


    _paddingHorizontal = XYZ_HUD_CONTENT_PADDING_HORIZONTAL;
    _paddingVertical = XYZ_HUD_CONTENT_PADDING_VERTICAL;

    _spacingAT = XYZ_HUD_CONTENT_SPACING_AT;
    _spacingTC = XYZ_HUD_CONTENT_SPACING_TC;
    _spacingAC = XYZ_HUD_CONTENT_SPACING_AC;

    _textHeight = XYZ_HUD_CONTENT_TEXT_HEIGHT;

    _cancelWidth = XYZ_HUD_CONTENT_CANCEL_WIDTH;
    _cancelHeight = XYZ_HUD_CONTENT_CANCEL_HEIGHT;
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

  [_activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.left.equalTo(self).offset(self.paddingHorizontal);
    make.centerY.equalTo(self);
    make.top.equalTo(self).offset(self.paddingVertical).priorityLow();
    make.top.greaterThanOrEqualTo(self).offset(self.paddingVertical);
    if ( (!self.textLabel) && (!self.cancelButton) ) {
      make.right.equalTo(self).offset(0.0-self.paddingHorizontal);
    }
  }];
  [_textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    if ( self.textLabel.numberOfLines==1 ) {
      if ( self.activityView ) {
        make.left.equalTo(self.activityView.mas_right).offset(self.spacingAT);
      } else {
        make.left.equalTo(self).offset(self.paddingHorizontal);
      }
      make.centerY.equalTo(self);
      make.height.equalTo(@(self.textHeight));
      make.top.equalTo(self).offset(self.paddingVertical).priorityLow();
      make.top.greaterThanOrEqualTo(self).offset(self.paddingVertical);
      if ( !self.cancelButton ) {
        make.right.equalTo(self).offset(0.0-self.paddingHorizontal);
      }
    } else {
      make.edges.equalTo(self).insets(UIEdgeInsetsMake(self.paddingVertical, self.paddingHorizontal, self.paddingVertical, self.paddingHorizontal));
    }
  }];
  [_cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    if ( self.textLabel ) {
      make.left.equalTo(self.textLabel.mas_right).offset(self.spacingTC);
    } else {
      if ( self.activityView ) {
        make.left.equalTo(self.activityView.mas_right).offset(self.spacingAC);
      } else {
        make.left.equalTo(self).offset(self.paddingHorizontal);
      }
    }
    make.centerY.equalTo(self);
    make.width.equalTo(@(self.cancelWidth));
    make.height.equalTo(@(self.cancelHeight));
    make.top.equalTo(self).offset(self.paddingVertical).priorityLow();
    make.top.greaterThanOrEqualTo(self).offset(self.paddingVertical);
    make.right.equalTo(self).offset(0.0-self.paddingHorizontal);
  }];

  [super updateConstraints];
}


- (void)configForMode:(XYZProgressHUDContentMode)mode
{
  if ( mode==XYZProgressHUDContentModeActivity ) {
    [self addActivityViewIfNeeded];
    [self removeTextLabel];
    [self removeCancelButton];
  } else if ( mode==XYZProgressHUDContentModeText ) {
    [self addActivityViewIfNeeded];
    [self addTextLabelIfNeeded];
    _textLabel.numberOfLines = 1;
    _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self removeCancelButton];
    [self orderSubviews];
  } else if ( mode==XYZProgressHUDContentModeCancellation ) {
    [self addActivityViewIfNeeded];
    [self addTextLabelIfNeeded];
    _textLabel.numberOfLines = 1;
    _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addCancelButtonIfNeeded];
    [self orderSubviews];
  } else if ( mode==XYZProgressHUDContentModeInfo ) {
    [self removeActivityView];
    [self addTextLabelIfNeeded];
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self removeCancelButton];
  }
  [self setNeedsUpdateConstraints];
}

- (void)addActivityViewIfNeeded
{
  if ( !_activityView ) {
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityView.translatesAutoresizingMaskIntoConstraints = NO;
    _activityView.hidesWhenStopped = NO;
    [_activityView startAnimating];
    [self addSubview:_activityView];
  }
//  _activityView.layer.borderColor = [[UIColor blueColor] CGColor];
//  _activityView.layer.borderWidth = 1.0;
}
- (void)removeActivityView
{
  [_activityView removeFromSuperview];
  _activityView = nil;
}

- (void)addTextLabelIfNeeded
{
  if ( !_textLabel ) {
    _textLabel = [UILabel tk_labelWithFont:[UIFont systemFontOfSize:14.0]
                                 textColor:[UIColor whiteColor]
                             textAlignment:NSTextAlignmentLeft
                             lineBreakMode:NSLineBreakByTruncatingTail
                             numberOfLines:1
                           backgroundColor:[UIColor clearColor]];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_textLabel];
  }
//  _textLabel.layer.borderColor = [[UIColor blueColor] CGColor];
//  _textLabel.layer.borderWidth = 1.0;
}
- (void)removeTextLabel
{
  [_textLabel removeFromSuperview];
  _textLabel = nil;
}

- (void)addCancelButtonIfNeeded
{
  if ( !_cancelButton ) {
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    // TODO: 修改图片名字
    _cancelButton.tk_normalImage = [UIImage imageNamed:@"hud_cancel"];
    [self addSubview:_cancelButton];
  }
//  _cancelButton.layer.borderColor = [[UIColor blueColor] CGColor];
//  _cancelButton.layer.borderWidth = 1.0;
}
- (void)removeCancelButton
{
  [_cancelButton removeFromSuperview];
  _cancelButton = nil;
}

- (void)orderSubviews
{
  [_activityView tk_bringToFront];
  [_textLabel tk_bringToFront];
  [_cancelButton tk_bringToFront];
}


+ (BOOL)requiresConstraintBasedLayout
{
  return YES;
}

@end
