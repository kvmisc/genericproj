//
//  XYZCoverView.h
//  GenericProj
//
//  Created by Kevin Wu on 12/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XYZCoverContentView.h"

typedef enum : NSUInteger {
  XYZCoverViewStatusUnknown = 0,
  XYZCoverViewStatusShowing,
  XYZCoverViewStatusPresented,
  XYZCoverViewStatusHiding,
} XYZCoverViewStatus;

@interface XYZCoverView : XYZBaseView

@property (nonatomic, strong, readonly) UIImageView *backgroundView;

@property (nonatomic, strong, readonly) XYZCoverContentView *contentView;

@property (nonatomic, assign, readonly) XYZCoverViewStatus status;

// 点击灰色的遮罩隐藏此视图，默认 YES
@property (nonatomic, assign) BOOL touchBackgroundToHide;
// 完成隐藏的时候调用
@property (nonatomic, copy) void (^completion)(void);


// 清除以前的延时调用、未完成动画等，准备重新开始
- (void)prepareForPresent;

- (void)layoutForViewport:(UIView *)viewport;

- (void)addContentView:(XYZCoverContentView *)contentView;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end
