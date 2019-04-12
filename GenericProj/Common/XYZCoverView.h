//
//  XYZCoverView.h
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XYZCoverContentView.h"
#import "XYZCoverAlertContentView.h"
#import "XYZCoverActionContentView.h"

typedef enum : NSUInteger {
  XYZCoverViewStatusUnknown = 0,
  XYZCoverViewStatusShowing,
  XYZCoverViewStatusShowFailed,
  XYZCoverViewStatusPresented,
  XYZCoverViewStatusHiding,
  XYZCoverViewStatusHideFailed,
} XYZCoverViewStatus;

@interface XYZCoverView : UIView

@property (nonatomic, strong, readonly) UIImageView *backgroundView;

@property (nonatomic, strong) XYZCoverContentView *contentView;

@property (nonatomic, assign) XYZCoverViewStatus status;

// 点击灰色的遮罩隐藏此视图，默认 YES
@property (nonatomic, assign) BOOL touchBackgroundToHide;
// 完成隐藏的时候调用
@property (nonatomic, copy) void (^completion)(void);


- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;


////////////////////////////////////////////////////////////////////////////////

- (void)cancelDelayHide;

// 同步自身状态，contentView 的状态不管
// 只在显示动画或隐藏动画期间有作用，参数为 YES 时直接设置成最终状态，否则同步动画的状态
- (void)updateStateFromAnimation:(BOOL)completion;

- (void)removeAllAnimations;

@end
