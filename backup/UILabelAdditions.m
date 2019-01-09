//
//  UILabelAdditions.m
//  TapKitDemo
//
//  Created by Kevin on 7/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UILabelAdditions.h"

@implementation UILabel (TapKit)

#pragma mark - Handy methods

+ (id)tk_labelWithFont:(UIFont *)font
             textColor:(UIColor *)textColor
{
  return [self tk_labelWithFont:font
                      textColor:textColor
                  textAlignment:NSTextAlignmentLeft
                  lineBreakMode:NSLineBreakByTruncatingTail
                  numberOfLines:1
                backgroundColor:[UIColor clearColor]];
}

+ (id)tk_labelWithFont:(UIFont *)font
             textColor:(UIColor *)textColor
         textAlignment:(NSTextAlignment)textAlignment
         lineBreakMode:(NSLineBreakMode)lineBreakMode
         numberOfLines:(NSInteger)numberOfLines
       backgroundColor:(UIColor *)backgroundColor
{
  UILabel *label = [[self alloc] init];
  label.font            = font;
  label.textColor       = (textColor       )  ? (textColor      ) : ([UIColor blackColor]     );
  label.textAlignment   = (textAlignment>=0)  ? (textAlignment  ) : (NSTextAlignmentLeft      );
  label.lineBreakMode   = (lineBreakMode>=0)  ? (lineBreakMode  ) : (NSLineBreakByWordWrapping);
  label.numberOfLines   = (numberOfLines>=0)  ? (numberOfLines  ) : (0                        );
  label.backgroundColor = (backgroundColor )  ? (backgroundColor) : ([UIColor clearColor]     );
  label.adjustsFontSizeToFitWidth = NO;
  return label;
}

@end
