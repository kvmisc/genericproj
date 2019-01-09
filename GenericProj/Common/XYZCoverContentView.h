//
//  XYZCoverContentView.h
//  GenericProj
//
//  Created by Kevin Wu on 13/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYZCoverView;

@interface XYZCoverContentView : XYZBaseView

@property (nonatomic, weak, readonly) XYZCoverView *coverView;

@property (nonatomic, copy) void (^showAnimation)(CGFloat progress);
@property (nonatomic, copy) void (^hideAnimation)(CGFloat progress);

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport;

// 记录当前的状态，动画会从当前状态开始
- (void)prepareForAnimation;

@end
