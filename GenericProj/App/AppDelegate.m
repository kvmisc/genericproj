//
//  AppDelegate.m
//  GenericProj
//
//  Created by Kevin Wu on 8/8/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import "AppDelegate.h"

#import "../Pages/GPRootViewController.h"

#import "../Vendors/YYFPSLabel/YYFPSLabel.h"

#import "GPTestObject.h"

#import "../Pages/GPPushAnimator.h"
#import "../Pages/GPPopAnimator.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSLog(@"%d %d", 9 % 4, 9 % -4);

  [XYZLogger setup];

//  [NSString tk_TestAddingQueryDictionary];
//  [NSString tk_TestAddingQueryString];
//  [NSString tk_TestQueryString];
//  [NSString tk_TestQueryDictionary];
//  [NSDictionary tk_TestQueryString];

//  NSString *pwd1 = [SAMKeychain passwordForService:@"com.firefly.gp" account:@"kevin"];
//  NSString *pwd2 = [SAMKeychain passwordForService:@"com.firefly.gp" account:@"tony"];
//  NSLog(@"pwd: [%@] [%@]", pwd1, pwd2);
//
//  //[SAMKeychain setPassword:@"qwert110" forService:@"com.firefly.gp" account:@"tony"];
//
//  pwd1 = [SAMKeychain passwordForService:@"com.firefly.gp" account:@"kevin"];
//  pwd2 = [SAMKeychain passwordForService:@"com.firefly.gp" account:@"tony"];
//  NSLog(@"pwd: [%@] [%@]", pwd1, pwd2);

//  NSLog(@"%@", [XYZGlobal pathGlobal:nil]);
//  NSLog(@"%@", [XYZGlobal pathGlobal:@"aaa/bbb.txt"]);
//  NSLog(@"==============================");
//  NSLog(@"%@", [XYZGlobal pathUser:nil relativePath:nil]);
//  NSLog(@"%@", [XYZGlobal pathUser:@"9527" relativePath:nil]);
//  NSLog(@"%@", [XYZGlobal pathUser:@"9527" relativePath:@"aaa.txt"]);
//  NSLog(@"==============================");
//  NSLog(@"%@", [XYZGlobal pathUser:nil service:nil file:nil]);
//  NSLog(@"%@", [XYZGlobal pathUser:@"1234" service:nil file:nil]);
//  NSLog(@"%@", [XYZGlobal pathUser:@"1234" service:@"img" file:nil]);
//  NSLog(@"%@", [XYZGlobal pathUser:@"1234" service:@"img" file:@"icon.png"]);

  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  _window.backgroundColor = [UIColor whiteColor];
  UIViewController *vc = [[GPRootViewController alloc] init];
  UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
  nc.navigationBarHidden = YES;
  //nc.delegate = self;
  _window.rootViewController = nc;


#ifdef DEBUG
  [YYFPSLabel setup];
#endif


  UISwipeGestureRecognizer *gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
  [_window addGestureRecognizer:gr];

  [_window makeKeyAndVisible];

  // 前面显示某个加载页面，这里设置数据库和一些其它必备的功能，如果这些必备功能失败，软件应该
  // 告诉用户出现了某个致命错误，用户可以重启或重装软件。
  // 有些用户比较笨，不会退出软件再打开，只会退到后台，然后再打开。所以，这些操作应该在进入前
  // 台的时候就做一遍。当然，这些操作要能检查重复。

//  NSLog(@"%d", 11%3);
//  NSLog(@"%d", -11%3);

  return YES;
}


- (void)swipe:(UISwipeGestureRecognizer *)gr
{
  UIViewController *top = [XYZGlobal topmostViewController];

  if ( [top isKindOfClass:[UINavigationController class]] ) {
    [(UINavigationController *)top popViewControllerAnimated:YES];
  }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
  if ( operation==UINavigationControllerOperationPush ) {
    return [[GPPushAnimator alloc] init];
  }

  if ( operation==UINavigationControllerOperationPop ) {
    return [[GPPopAnimator alloc] init];
  }

  return nil;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
