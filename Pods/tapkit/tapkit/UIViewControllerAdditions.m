//
//  UIViewControllerAdditions.m
//  TapKitDemo
//
//  Created by Kevin on 7/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UIViewControllerAdditions.h"

@implementation UIViewController (TapKit)

#pragma mark - Content management

- (void)tk_presentChildViewController:(UIViewController *)childViewController inView:(UIView *)containerView
{
  [self addChildViewController:childViewController];
  [(containerView)?:(self.view) addSubview:childViewController.view];
  [childViewController didMoveToParentViewController:self];
}

- (void)tk_dismissChildViewController:(UIViewController *)childViewController
{
  [childViewController willMoveToParentViewController:nil];
  [childViewController.view removeFromSuperview];
  [childViewController removeFromParentViewController];
}

@end
