//
//  NSObjectAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSObjectAdditions.h"

@implementation NSObject (TapKit)

#pragma mark - Key-Value Coding

- (BOOL)tk_isValueForKeyPath:(NSString *)keyPath equalTo:(id)value
{
  if ( keyPath.length>0 ) {
    id aValue = [self valueForKeyPath:keyPath];

    if ( (!aValue) && (!value) ) {
      return YES;
    }

    return [aValue isEqual:value];
  }
  return NO;
}

- (BOOL)tk_isValueForKeyPath:(NSString *)keyPath identicalTo:(id)value
{
  if ( keyPath.length>0 ) {
    return ( [self valueForKeyPath:keyPath]==value );
  }
  return NO;
}

@end
