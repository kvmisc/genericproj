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
  NSString *str = @"ae\u0301z";
  NSLog(@"str = [%@]", str);                         // str = [aéz]
  NSLog(@"length = %lu", [str length]);              // length = 4
  NSLog(@"char_0 = [%c]", [str characterAtIndex:0]); // char_0 = [a]
  NSLog(@"char_1 = [%c]", [str characterAtIndex:1]); // char_1 = [e]
  NSLog(@"char_2 = [%c]", [str characterAtIndex:2]); // char_2 = []
  NSLog(@"char_3 = [%c]", [str characterAtIndex:3]); // char_3 = [z]

  NSRange range0 = [str rangeOfComposedCharacterSequenceAtIndex:0];
  NSLog(@"range0 = (%lu %lu), char_0 = [%@]", range0.location, range0.length, [str substringWithRange:range0]);
  // range0 = (0 1), char_0 = [a]

  NSRange range1 = [str rangeOfComposedCharacterSequenceAtIndex:1];
  NSLog(@"range1 = (%lu %lu), char_1 = [%@]", range1.location, range1.length, [str substringWithRange:range1]);
  // range1 = (1 2), char_1 = [é]

  NSRange range2 = [str rangeOfComposedCharacterSequenceAtIndex:2];
  NSLog(@"range2 = (%lu %lu), char_2 = [%@]", range2.location, range2.length, [str substringWithRange:range2]);
  // range2 = (1 2), char_2 = [é]

  NSRange range3 = [str rangeOfComposedCharacterSequenceAtIndex:3];
  NSLog(@"range3 = (%lu %lu), char_3 = [%@]", range3.location, range3.length, [str substringWithRange:range3]);
  // range3 = (3 1), char_3 = [z]


//  [XYZLogger setup];
//
//  CGRect rect1 = [[UIScreen mainScreen] bounds];
//  CGRect rect2 = [[UIScreen mainScreen] nativeBounds];
//  NSLog(@"%@ %@ %f %f", NSStringFromCGSize(rect1.size), NSStringFromCGSize(rect2.size),
//        [[UIScreen mainScreen] scale], [[UIScreen mainScreen] nativeScale]);
//
//  NSLog(@"%f %f", XYZ_SAFE_AREA_TOP, XYZ_SAFE_AREA_BOT);


//  NSDictionary *dict = @{
//                         @"AA": @"11",
//                         @"DD": @"44",
//                         @"BB": @"22",
//                         @"CC": @"33"
//                         };
//
//  for ( NSString *key in dict ) {
//    NSString *value = [dict objectForKey:key];
//    NSLog(@"%@: %@", key, value);
//  }

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

//  NSString *str = @"After you create an in-app purchase product in App Store Connect, you submit it to Apple for review. If you are submitting your first in-app purchase, you must submit it with a new version of your app. After an app is available on the store with existing in-app purchases, you can submit additional in-app purchase for that app at any time. If you are adding a new in-app purchase type to your app (for example, you usually offer consumables, but want to start offering auto-renewable subscriptions), you must do so with app version update. To submit an in-app purchase for review, it must have the Ready to Submit in-app purchase status. If not, ";
//  NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//  NSString *receipt = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//  NSLog(@"%@", receipt);

//  {
//    NSString *str = @"aes-256-cfb:wildcat@104.36.65.164:443";
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *result = [data base64EncodedStringWithOptions:0];
//    NSLog(@"<%@>", result);
//    //[dt writeToFile:[XYZGlobal pathGlobal:@"aaa.txt"] atomically:YES];
//  }
//  {
//    NSString *str = @"YWVzLTI1Ni1jZmI6d2lsZGNhdEAxMDQuMzYuNjUuMTY0OjQ0Mw";//@"YmYtY2ZiOnRlc3RAMTkyLjE2OC4xMDAuMTo4ODg4Cg";
//    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:0];
//    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"<%@>", result);
//    //[dt writeToFile:NSString *path = [XYZGlobal pathGlobal:@"bbb.txt"]; atomically:YES];
//  }



  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  _window.backgroundColor = [UIColor whiteColor];
  UIViewController *vc = [[GPRootViewController alloc] init];
  UINavigationController *nc = [[XYZNavigationController alloc] initWithRootViewController:vc];
  nc.navigationBarHidden = YES;
  //nc.delegate = self;
  _window.rootViewController = nc;


//  YYFPSLabel *FPSLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0.0, XYZ_SCREEN_HET-30.0, 50.0, 30.0)];
//  [nc.view addSubview:FPSLabel];


  UISwipeGestureRecognizer *gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
  [_window addGestureRecognizer:gr];

  [_window makeKeyAndVisible];

  // 前面显示某个加载页面，这里设置数据库和一些其它必备的功能，如果这些必备功能失败，软件应该
  // 告诉用户出现了某个致命错误，用户可以重启或重装软件。
  // 有些用户比较笨，不会退出软件再打开，只会退到后台，然后再打开。所以，这些操作应该在进入前
  // 台的时候就做一遍。当然，这些操作要能检查重复。

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
