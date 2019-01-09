//
//  UILabelAdditions.h
//  TapKitDemo
//
//  Created by Kevin on 7/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel (TapKit)

///-------------------------------
/// Handy methods
///-------------------------------

+ (id)tk_labelWithFont:(UIFont *)font
             textColor:(UIColor *)textColor;

+ (id)tk_labelWithFont:(UIFont *)font
             textColor:(UIColor *)textColor
         textAlignment:(NSTextAlignment)textAlignment
         lineBreakMode:(NSLineBreakMode)lineBreakMode
         numberOfLines:(NSInteger)numberOfLines
       backgroundColor:(UIColor *)backgroundColor;

@end
