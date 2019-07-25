//
//  FBMainViewController.h
//  Foobar
//
//  Created by Kevin Wu on 2019/7/5.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBHomeViewController.h"
#import "FBHotViewController.h"
#import "FBCategoryViewController.h"
#import "FBRoleViewController.h"

@interface FBMainViewController : UIViewController

@property (nonatomic, strong, readonly) FBHomeViewController *homeViewController;
@property (nonatomic, strong, readonly) FBHotViewController *hotViewController;
@property (nonatomic, strong, readonly) FBCategoryViewController *categoryViewController;
@property (nonatomic, strong, readonly) FBRoleViewController *roleViewController;

- (void)changeToPage:(NSUInteger)idx;

@end
