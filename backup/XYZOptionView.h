//
//  XYZOptionView.h
//  GenericProj
//
//  Created by Kevin Wu on 5/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XYZOptionContentView.h"

@interface XYZOptionView : UIView

@property (nonatomic, strong, readonly) UIImageView *backgroundView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign, readonly) BOOL showing;
@property (nonatomic, assign, readonly) BOOL presented;
@property (nonatomic, assign, readonly) BOOL hiding;

// 点击灰色的遮罩隐藏此视图，默认 YES
@property (nonatomic, assign) BOOL touchBackgroundToHide;


- (BOOL)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
