//
//  FBTestViewController.m
//  Foobar
//
//  Created by Haiping Wu on 2019/7/20.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "FBTestViewController.h"

#import "FBSubViewController.h"

@interface FBTestViewController ()

@end

@implementation FBTestViewController

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesEnded:touches withEvent:event];

  FBSubViewController *vc = [[FBSubViewController alloc] init];
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)shouldAutorotate
{
  //  UIViewController *currentVC = self.selectedViewController;
  //  if ( currentVC ) {
  //    return [currentVC shouldAutorotate];
  //  }
  return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskPortrait;
}

@end
