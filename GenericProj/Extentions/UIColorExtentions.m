//
//  UIColorExtentions.m
//  GenericProj
//
//  Created by Kevin Wu on 9/8/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "UIColorExtentions.h"

@implementation UIColor (Extentions)

+ (UIColor *)tk_colorWithHexString:(NSString *)string
{
  NSString *cleanString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
  if( [cleanString length]==3 ) {
    cleanString = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@",
                   [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                   [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                   [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
  }
  if ( [cleanString length]!=6 ) { return nil; }

  unsigned int baseValue = 0;
  [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

  return [self tk_colorWithHexInteger:baseValue];
}

+ (UIColor *)tk_colorWithHexInteger:(NSInteger)integer
{
  return [UIColor colorWithRed:((float)((integer & 0xFF0000) >> 16))/255.0
                         green:((float)((integer & 0x00FF00) >>  8))/255.0
                          blue:((float) (integer & 0x0000FF)       )/255.0
                         alpha:1.0];
}

@end
