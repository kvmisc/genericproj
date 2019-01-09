//
//  UIButtonExtentions.h
//  GenericProj
//
//  Created by Kevin Wu on 9/8/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extentions)

- (void)tk_centerHorizontally:(CGFloat)spacing;

- (void)tk_swapAndCenterHorizontally:(CGFloat)spacing;


- (void)tk_centerVertically:(CGFloat)spacing;


- (void)tk_removeAllTargets;

@end
