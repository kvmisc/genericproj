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
  if ( string.length!=8 ) { return nil; }

  unsigned int baseValue = 0;
  [[NSScanner scannerWithString:string] scanHexInt:&baseValue];

  return [self tk_colorWithHexInteger:baseValue];
}

+ (UIColor *)tk_colorWithHexInteger:(NSInteger)integer
{
  return [UIColor colorWithRed:((float)((integer & 0xFF000000) >> 24))/255.0
                         green:((float)((integer & 0x00FF0000) >> 16))/255.0
                          blue:((float)((integer & 0x0000FF00) >>  8))/255.0
                         alpha:((float) (integer & 0x000000FF)      )/255.0];
}

@end
