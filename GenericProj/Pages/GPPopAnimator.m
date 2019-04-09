//
//  GPPopAnimator.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/8.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPPopAnimator.h"

@implementation GPPopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
  return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
  UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

  [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
  toViewController.view.frame = [transitionContext containerView].frame;

  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    fromViewController.view.alpha = 0.0;
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

@end
