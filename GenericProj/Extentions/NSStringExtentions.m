//
//  NSStringExtentions.m
//  GenericProj
//
//  Created by Kevin Wu on 21/11/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "NSStringExtentions.h"

@implementation NSString (Extentions)

- (CGSize)tk_sizeWithFont:(UIFont *)font
{
  NSAssert((font!=nil), @"font should not be nil");

  CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
  return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (CGSize)tk_sizeWithFont:(UIFont *)font width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
  NSAssert((font!=nil), @"font should not be nil");
  NSAssert((width>0.0), @"width should not be negtive");

  NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
  paragraph.lineBreakMode = lineBreakMode;

  NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];

  CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraph}
                                   context:context];

  return CGSizeMake(MAX(ceil(width), ceil(rect.size.width)), ceil(rect.size.height));
}

@end
