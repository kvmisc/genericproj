//
//  XYZCoverSpringView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "XYZCoverSpringView.h"

@implementation XYZCoverSpringView

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
  self.frame = CGRectMake(50,
                          floor((self.coverView.bounds.size.height-100)/2.0),
                          self.coverView.bounds.size.width-2*50,
                          100);
  self.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1.0);
}
- (void)updateStateFromAnimation:(BOOL)completion
{
  if ( completion ) {
    if ( self.coverView.status==XYZCoverViewStatusShowing ) {
      self.layer.transform = CATransform3DIdentity;
    } else if ( self.coverView.status==XYZCoverViewStatusHiding ) {
      self.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1.0);
    }
  } else {
    if ( (self.coverView.status==XYZCoverViewStatusShowing) || (self.coverView.status==XYZCoverViewStatusHiding) ) {
      if ( self.layer.presentationLayer ) {
        self.layer.transform = self.layer.presentationLayer.transform;
      }
    }
  }
}
- (CAAnimation *)showAnimation
{
  CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"transform"];
  // 模拟质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大。默认值 1
  animation.mass = 2.0;
  // 刚度系数（劲度系数/弹性系数），刚度系数越大，形变产生的力就越大，运动越快。默认值 100
  animation.stiffness = 100.0;
  // 阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快。默认值 10
  animation.damping = 20.0;
  // 初始速率，动画视图的初始速度大小。默认值 0
  // 速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
  animation.initialVelocity = 10.0;
  // 估算时间 返回弹簧动画到停止时的估算时间，根据当前的动画参数估算
  animation.duration = animation.settlingDuration;
  animation.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
  animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
  return animation;
}
- (CAAnimation *)hideAnimation
{
  CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"transform"];
  animation.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
  animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)];
  return animation;
}

@end
