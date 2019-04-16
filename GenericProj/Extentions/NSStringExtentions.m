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


- (NSString *)tk_base64EncodedString
{
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
  return [data base64EncodedStringWithOptions:0];
}

- (NSString *)tk_base64DecodedString
{
  NSData *data = [[NSData alloc] initWithBase64EncodedData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0];
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#ifdef DEBUG
+ (void)tk_TestBase64
{
  NSLog(@"Begin Test Base64 ========================================");
  {
    NSString *str = @"Meet URL Decode and Encode, a simple online tool that does exactly what it says; decodes URL encoding and encodes into it quickly and easily. URL encode your data in a hassle-free way, or decode it into human-readable format.";
    NSString *encoded = [str tk_base64EncodedString];
    NSLog(@"%@", encoded);
    NSString *decoded = [encoded tk_base64DecodedString];
    NSLog(@"%@", decoded);
  }
  {
    NSString *str = @"";
    NSString *encoded = [str tk_base64EncodedString];
    NSLog(@"[%@]", encoded);
    NSString *decoded = [encoded tk_base64DecodedString];
    NSLog(@"[%@]", decoded);
  }
  NSLog(@"End Test Base64 ==========================================");
}
#endif

@end
