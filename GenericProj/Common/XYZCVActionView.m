//
//  XYZCVActionView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "XYZCVActionView.h"

@implementation XYZCVActionView

- (id)init
{
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor greenColor];
  }
  return self;
}

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport
{
  [super prepareForView:inView viewport:viewport];
  self.frame = CGRectMake(0,
                          self.coverView.bounds.size.height,
                          self.coverView.bounds.size.width,
                          100);
}

- (void)updateStateFromAnimation:(BOOL)completion
{
  if ( completion ) {
    if ( self.coverView.status==XYZCVViewStatusShowing ) {
      self.layer.position = CGPointMake(floor(self.coverView.bounds.size.width/2.0),
                                        floor(self.coverView.bounds.size.height-50.0));
    } else if ( self.coverView.status==XYZCVViewStatusHiding ) {
      self.layer.position = CGPointMake(floor(self.coverView.bounds.size.width/2.0),
                                        floor(self.coverView.bounds.size.height+50.0));
    }
  } else {
    if ( (self.coverView.status==XYZCVViewStatusShowing) || (self.coverView.status==XYZCVViewStatusHiding) ) {
      if ( self.layer.presentationLayer ) {
        self.layer.position = self.layer.presentationLayer.position;
      }
    }
  }
}
- (CAAnimation *)showAnimation
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  animation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
  CGPoint point = CGPointMake(floor(self.coverView.bounds.size.width/2.0),
                              floor(self.coverView.bounds.size.height-50.0));
  animation.toValue = [NSValue valueWithCGPoint:point];
  return animation;
}
- (CAAnimation *)hideAnimation
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  animation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
  CGPoint point = CGPointMake(floor(self.coverView.bounds.size.width/2.0),
                              floor(self.coverView.bounds.size.height+50.0));
  animation.toValue = [NSValue valueWithCGPoint:point];
  return animation;
}

@end
