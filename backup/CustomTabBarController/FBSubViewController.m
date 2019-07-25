//
//  FBSubViewController.m
//  Foobar
//
//  Created by Haiping Wu on 2019/7/20.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "FBSubViewController.h"

@interface FBSubViewController ()

@end

@implementation FBSubViewController

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
  return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
