//
//  UIColorExtentions.h
//  GenericProj
//
//  Created by Kevin Wu on 9/8/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TKRGB(r, g, b)      [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:1.0]
#define TKRGBA(r, g, b, a)  [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:(a)]

@interface UIColor (Extentions)

// @"00FF00FF"
+ (UIColor *)tk_colorWithHexString:(NSString *)string;

// 定义颜色的时候最好用数字，这样可以省去字符串转换数字的操作，节省时间
// 0x00FF00FF
+ (UIColor *)tk_colorWithHexInteger:(NSInteger)integer;

@end
