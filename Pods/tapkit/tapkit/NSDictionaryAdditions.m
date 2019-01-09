//
//  NSDictionaryAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSDictionaryAdditions.h"

@implementation NSDictionary (TapKit)

#pragma mark - Querying

- (id)tk_objectOrNilForKey:(id)key
{
  id object = [self objectForKey:key];
  if ( object!=[NSNull null] ) {
    return object;
  }
  return nil;
}

@end



@implementation NSMutableDictionary (TapKit)

#pragma mark - Content management

- (void)tk_setObject:(id)object forKeyIfNotNil:(id)key
{
  if ( object && key ) {
    [self setObject:object forKey:key];
  }
}

- (void)tk_removeObjectForKeyIfNotNil:(id)key
{
  if ( key ) {
    [self removeObjectForKey:key];
  }
}

@end
