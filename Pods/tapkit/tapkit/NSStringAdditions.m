//
//  NSStringAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSStringAdditions.h"
#import "NSDataAdditions.h"

@implementation NSString (TapKit)

#pragma mark - Hash

- (NSString *)tk_MD5HashString
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] tk_MD5HashString];
}

- (NSString *)tk_SHA1HashString
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] tk_SHA1HashString];
}

@end
