//
//  XYZCVAlertView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "XYZCVAlertView.h"

@implementation XYZCVAlertView

- (id)init
{
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor greenColor];
    self.alpha = 0.0;
  }
  return self;
}

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport
{
  [super prepareForView:inView viewport:viewport];
  self.frame = CGRectMake(50,
                          floor((self.coverView.bounds.size.height-100)/2.0),
                          self.coverView.bounds.size.width-2*50,
                          100);
}

- (void)updateStateFromAnimation:(BOOL)completion
{
  if ( completion ) {
    if ( self.coverView.status==XYZCVViewStatusShowing ) {
      self.layer.opacity = 1.0;
    } else if ( self.coverView.status==XYZCVViewStatusHiding ) {
      self.layer.opacity = 0.0;
    }
  } else {
    if ( (self.coverView.status==XYZCVViewStatusShowing) || (self.coverView.status==XYZCVViewStatusHiding) ) {
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
  animation.removedOnCompletion = NO;
  animation.fillMode = kCAFillModeForwards;
  return animation;
}
- (CAAnimation *)hideAnimation
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animation.fromValue = @(self.layer.opacity);
  animation.toValue = @(0.0);
  animation.removedOnCompletion = NO;
  animation.fillMode = kCAFillModeForwards;
  return animation;
}

@end
