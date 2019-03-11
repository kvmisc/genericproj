//
//  XYZNavigationController.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/3/11.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "XYZNavigationController.h"
#import "XYZBaseViewController.h"

@implementation XYZNavigationController

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//  [super pushViewController:viewController animated:animated];
//}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
  UIViewController *vc = [super popViewControllerAnimated:YES];
  if ( [vc respondsToSelector:@selector(destroyActivities)] ) {
    [(id<XYZBaseViewControllerActivityProtocol>)vc destroyActivities];
  }
  return vc;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  NSArray *ary = [super popToViewController:viewController animated:animated];
  for ( NSInteger i=0; i<[ary count]; ++i ) {
    UIViewController *vc = [ary objectAtIndex:i];
    if ( [vc respondsToSelector:@selector(destroyActivities)] ) {
      [(id<XYZBaseViewControllerActivityProtocol>)vc destroyActivities];
    }
  }
  return ary;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
  NSArray *ary = [super popToRootViewControllerAnimated:animated];
  for ( NSInteger i=0; i<[ary count]; ++i ) {
    UIViewController *vc = [ary objectAtIndex:i];
    if ( [vc respondsToSelector:@selector(destroyActivities)] ) {
      [(id<XYZBaseViewControllerActivityProtocol>)vc destroyActivities];
    }
  }
  return ary;
}

@end
