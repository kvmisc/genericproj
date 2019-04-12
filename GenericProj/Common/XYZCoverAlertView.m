//
//  XYZCoverAlertView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "XYZCoverAlertView.h"

@implementation XYZCoverAlertView

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
