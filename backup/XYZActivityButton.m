//
//  XYZActivityButton.m
//  winlot
//
//  Created by Kevin Wu on 11/3/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import "XYZActivityButton.h"

@implementation XYZActivityButton {
  UIActivityIndicatorView *_activityView;

  NSMutableDictionary *_statusMap;
}

- (id)initWithActivityView:(UIActivityIndicatorView *)activityView
{
  self = [super init];
  if (self) {
    if ( activityView ) {
      self.translatesAutoresizingMaskIntoConstraints = NO;

      _activityView = activityView;
      _activityView.hidden = YES;
      [_activityView stopAnimating];
      [self addSubview:_activityView];

      _statusMap = [[NSMutableDictionary alloc] init];
    } else {
      [self initialize];
    }
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)initialize
{
  self.translatesAutoresizingMaskIntoConstraints = NO;

  _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _activityView.hidesWhenStopped = YES;
  [_activityView stopAnimating];
  [self addSubview:_activityView];


  _statusMap = [[NSMutableDictionary alloc] init];
}


- (void)updateConstraints
{
  @weakify(self);
  [_activityView mas_updateConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.center.equalTo(self);
  }];
  
  [super updateConstraints];
}

- (void)setAnimating:(BOOL)animating
{
  _animating = animating;

  if ( _animating ) {
    if ( _saveAndClearStatus ) {
      _saveAndClearStatus(self, _statusMap);
    }
    [_activityView startAnimating];
    _activityView.hidden = NO;
  } else {
    _activityView.hidden = YES;
    [_activityView stopAnimating];
    if ( _restoreStatus ) {
      _restoreStatus(self, _statusMap);
    }
  }
}

@end
