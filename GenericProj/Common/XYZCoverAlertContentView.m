//
//  XYZCoverAlertContentView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "XYZCoverAlertContentView.h"

@implementation XYZCoverAlertContentView

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
  self.backgroundColor = [UIColor greenColor];
  self.alpha = 0.0;
}

- (CGSize)intrinsicContentSize
{
  return CGSizeMake(200.0, 100.0);
}

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport
{
  [super prepareForView:inView viewport:viewport];
  CGSize contentSize = [self intrinsicContentSize];
  self.frame = CGRectMake(floor((self.coverView.bounds.size.width-contentSize.width)/2.0),
                          floor((self.coverView.bounds.size.height-contentSize.height)/2.0),
                          contentSize.width,
                          contentSize.height);
}
- (void)updateStateFromAnimation:(BOOL)completion
{
  if ( completion ) {
    if ( self.coverView.status==XYZCoverViewStatusShowing ) {
      self.layer.opacity = 1.0;
    } else if ( self.coverView.status==XYZCoverViewStatusHiding ) {
      self.layer.opacity = 0.0;
    }
  } else {
    if ( (self.coverView.status==XYZCoverViewStatusShowing) || (self.coverView.status==XYZCoverViewStatusHiding) ) {
      if ( self.layer.presentationLayer ) {
        self.layer.opacity = self.layer.presentationLayer.opacity;
      }
    }
  }
}
- (CAAnimation *)showAnimation
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animation.fromValue = @(self.layer.opacity);
  animation.toValue = @(1.0);
  return animation;
}
- (CAAnimation *)hideAnimation
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animation.fromValue = @(self.layer.opacity);
  animation.toValue = @(0.0);
  return animation;
}

@end
