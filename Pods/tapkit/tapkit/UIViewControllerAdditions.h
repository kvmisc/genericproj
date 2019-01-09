//
//  UIViewControllerAdditions.h
//  TapKitDemo
//
//  Created by Kevin on 7/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController (TapKit)

///-------------------------------
/// Content management
///-------------------------------

- (void)tk_presentChildViewController:(UIViewController *)childViewController inView:(UIView *)containerView;

- (void)tk_dismissChildViewController:(UIViewController *)childViewController;

@end
