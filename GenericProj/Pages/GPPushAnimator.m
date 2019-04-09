//
//  GPPushAnimator.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/8.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPPushAnimator.h"

@implementation GPPushAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
  return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
  UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

  [[transitionContext containerView] addSubview:toViewController.view];
  toViewController.view.frame = [transitionContext containerView].frame;

  toViewController.view.alpha = 0.0;

  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    toViewController.view.alpha = 1.0;
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

@end
