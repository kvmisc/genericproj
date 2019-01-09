//
//  XYZProgressHUD.h
//  GenericProj
//
//  Created by Kevin Wu on 1/10/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XYZProgressHUDContentView.h"

typedef void(^XYZProgressHUDHandler)(void);

@interface XYZProgressHUD : UIView

@property (nonatomic, strong, readonly) UIImageView *backgroundView;

@property (nonatomic, strong, readonly) XYZProgressHUDContentView *contentView;

@property (nonatomic, strong) UIView *customContentView;


@property (nonatomic, assign) CGFloat marginHorizontal;
// 值为负数的时候不起作用
@property (nonatomic, assign) CGFloat marginTop;
@property (nonatomic, assign) CGFloat marginBottom;


@property (nonatomic, copy) XYZProgressHUDHandler cancelHandler;

@property (nonatomic, copy) XYZProgressHUDHandler completeHandler;


@property (nonatomic, assign, readonly) BOOL showing;
@property (nonatomic, assign, readonly) BOOL presented;
@property (nonatomic, assign, readonly) BOOL hiding;


- (void)updateViewport:(UIView *)viewport;

- (void)updateEvent;

- (BOOL)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end
