//
//  XYZCVView.h
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XYZCVContentView.h"

typedef enum : NSUInteger {
  XYZCVViewStatusUnknown = 0,
  XYZCVViewStatusShowing,
  XYZCVViewStatusShowFailed,
  XYZCVViewStatusPresented,
  XYZCVViewStatusHiding,
  XYZCVViewStatusHideFailed,
} XYZCVViewStatus;

@interface XYZCVView : UIView

@property (nonatomic, strong, readonly) UIImageView *backgroundView;

@property (nonatomic, strong, readonly) XYZCVContentView *contentView;

@property (nonatomic, assign, readonly) XYZCVViewStatus status;

// 点击灰色的遮罩隐藏此视图，默认 YES
@property (nonatomic, assign) BOOL touchBackgroundToHide;
// 完成隐藏的时候调用
@property (nonatomic, copy) void (^completion)(void);


- (void)cancelDelayHide;

- (void)updateStateFromAnimation:(BOOL)completion;

- (void)removeAllAnimations;

- (void)layoutForViewport:(UIView *)viewport;

- (void)addContentView:(XYZCVContentView *)contentView;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end
