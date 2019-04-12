//
//  XYZCoverActionContentView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "XYZCoverActionContentView.h"

@implementation XYZCoverActionContentView

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
}

- (CGSize)intrinsicContentSize
{
  return CGSizeMake(UIViewNoIntrinsicMetric, 100.0);
}

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport
{
  [super prepareForView:inView viewport:viewport];
  CGSize contentSize = [self intrinsicContentSize];
  self.frame = CGRectMake(0.0,
                          self.coverView.bounds.size.height,
                          self.coverView.bounds.size.width,
                          contentSize.height);
}
- (void)updateStateFromAnimation:(BOOL)completion
{
  CGSize contentSize = [self intrinsicContentSize];

  if ( completion ) {
    if ( self.coverView.status==XYZCoverViewStatusShowing ) {
      self.layer.position = CGPointMake(floor(self.coverView.bounds.size.width/2.0),
                                        floor(self.coverView.bounds.size.height-contentSize.height/2.0));
    } else if ( self.coverView.status==XYZCoverViewStatusHiding ) {
      self.layer.position = CGPointMake(floor(self.coverView.bounds.size.width/2.0),
                                        floor(self.coverView.bounds.size.height+contentSize.height/2.0));
    }
  } else {
    if ( (self.coverView.status==XYZCoverViewStatusShowing) || (self.coverView.status==XYZCoverViewStatusHiding) ) {
      if ( self.layer.presentationLayer ) {
        self.layer.position = self.layer.presentationLayer.position;
      }
    }
  }
}
- (CAAnimation *)showAnimation
{
  CGSize contentSize = [self intrinsicContentSize];

  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  animation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
  CGPoint point = CGPointMake(floor(self.coverView.bounds.size.width/2.0),
                              floor(self.coverView.bounds.size.height-contentSize.height/2.0));
  animation.toValue = [NSValue valueWithCGPoint:point];
  return animation;
}
- (CAAnimation *)hideAnimation
{
  CGSize contentSize = [self intrinsicContentSize];

  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  animation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
  CGPoint point = CGPointMake(floor(self.coverView.bounds.size.width/2.0),
                              floor(self.coverView.bounds.size.height+contentSize.height/2.0));
  animation.toValue = [NSValue valueWithCGPoint:point];
  return animation;
}

@end
