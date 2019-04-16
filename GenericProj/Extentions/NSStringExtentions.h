//
//  NSStringExtentions.h
//  GenericProj
//
//  Created by Kevin Wu on 21/11/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extentions)

- (CGSize)tk_sizeWithFont:(UIFont *)font;

- (CGSize)tk_sizeWithFont:(UIFont *)font width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;


- (NSString *)tk_base64EncodedString;

- (NSString *)tk_base64DecodedString;

#ifdef DEBUG
+ (void)tk_testBase64;
#endif

@end
