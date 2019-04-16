//
//  XYZBaseViewController.h
//  GenericProj
//
//  Created by Kevin Wu on 12/29/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZBaseViewController : UIViewController

@property (nonatomic, assign, readonly) BOOL viewAppeared;
@property (nonatomic, assign, readonly) BOOL appearedEver;

@property (nonatomic, strong, readonly) UIView *contentView;


- (void)disableContentInsetAdjustment:(UIScrollView *)scrollView;

// to override
- (BOOL)shouldLoadContentView;

@end
