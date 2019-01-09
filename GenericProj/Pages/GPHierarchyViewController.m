//
//  GPHierarchyViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 9/8/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPHierarchyViewController.h"

static NSMutableArray *TitleAry = nil;

@implementation GPHierarchyViewController {
  NSString *_theTitle;
}

- (id)init
{
  self = [super init];
  if (self) {
    if ( !TitleAry ) {
      TitleAry = [[NSMutableArray alloc] initWithObjects:@"AAA", @"BBB", @"CCC", @"DDD", @"!!!", nil];
    }

    _theTitle = [TitleAry firstObject];
    if ( TitleAry.count>0 ) {
      [TitleAry removeObjectAtIndex:0];
    }
  }
  return self;
}


- (NSString *)description
{
  return [NSString stringWithFormat:@"[GPHierarchyViewController] %p %@", self, _theTitle];
}


- (IBAction)back:(id)sender
{
  if ( self.navigationController ) {
    if ( [self.navigationController.viewControllers count]>=2 ) {
      [self.navigationController popViewControllerAnimated:YES];
    } else {
      if ( self.navigationController.presentingViewController ) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
      }
    }
  } else {
    if ( self.presentingViewController ) {
      [self dismissViewControllerAnimated:YES completion:NULL];
    }
  }
}

- (IBAction)push:(id)sender
{
  UIViewController *vc = [[[self class] alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)present:(id)sender
{
  UIViewController *vc = [[[self class] alloc] init];
  [self presentViewController:vc animated:YES completion:NULL];
}


- (void)startActivities
{
  NSLog(@"start: %@", _theTitle);
}

- (void)stopActivities
{
  NSLog(@"stop: %@", _theTitle);
}

- (void)destroyActivities
{
  NSLog(@"destroy: %@", _theTitle);
}


//- (void)viewWillAppear:(BOOL)animated
//{
//  [super viewWillAppear:animated];
//
//  DDLogDebug(@"[%@][%@] from=%d to=%d", _theTitle, NSStringFromSelector(_cmd), self.isMovingFromParentViewController, self.isMovingToParentViewController);
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//  [super viewDidAppear:animated];
//
//  DDLogDebug(@"[%@][%@] from=%d to=%d", _theTitle, NSStringFromSelector(_cmd), self.isMovingFromParentViewController, self.isMovingToParentViewController);
//}
//
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//  [super viewWillDisappear:animated];
//
//  DDLogDebug(@"[%@][%@] from=%d to=%d", _theTitle, NSStringFromSelector(_cmd), self.isMovingFromParentViewController, self.isMovingToParentViewController);
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//  [super viewDidDisappear:animated];
//
//  DDLogDebug(@"[%@][%@] from=%d to=%d", _theTitle, NSStringFromSelector(_cmd), self.isMovingFromParentViewController, self.isMovingToParentViewController);
//}
//
//
//- (void)willMoveToParentViewController:(UIViewController *)parent
//{
//  [super willMoveToParentViewController:parent];
//
//  DDLogDebug(@"[%@][%@] parent=%@", _theTitle, NSStringFromSelector(_cmd), parent);
//}

@end
