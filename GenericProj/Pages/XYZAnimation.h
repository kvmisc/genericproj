//
//  XYZAnimation.h
//  GenericProj
//
//  Created by Haiping Wu on 29/03/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZAnimation : NSObject

@property (nonatomic, readonly) NSInteger animationId;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval startTime;
@property (nonatomic, readonly) CGFloat progress;
@property (nonatomic, copy) void (^animations)(CGFloat progress);
@property (nonatomic, copy) void (^completion)(BOOL finished);

@property (nonatomic, weak) XYZAnimation *nextAnimation;

- (void)tick;
- (void)complete:(BOOL)finished;

@end
