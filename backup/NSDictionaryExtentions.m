//
//  NSDictionaryExtentions.m
//  GenericProj
//
//  Created by Haiping Wu on 16/01/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "NSDictionaryExtentions.h"

@implementation NSMutableDictionary (Extentions)

- (void)tk_setParameter:(NSString *)object forKey:(NSString *)key
{
  [self setObject:object forKey:key];
}

- (void)tk_setParameterInt:(NSInteger)object forKey:(NSString *)key
{
  [self setObject:[NSNumber numberWithInteger:object] forKey:key];
}
- (void)tk_setParameterInt:(NSInteger)object forKey:(NSString *)key condition:(BOOL)condition
{
  if ( condition ) {
    [self tk_setParameterInt:object forKey:key];
  }
}

- (void)tk_setParameterFlt:(CGFloat)object forKey:(NSString *)key
{
  [self setObject:[NSNumber numberWithFloat:object] forKey:key];
}
- (void)tk_setParameterFlt:(CGFloat)object forKey:(NSString *)key condition:(BOOL)condition
{
  if ( condition ) {
    [self tk_setParameterFlt:object forKey:key];
  }
}

- (void)tk_setParameterStr:(NSString *)object forKey:(NSString *)key
{
  if ( (object) && [object isKindOfClass:[NSString class]] ) {
    [self setObject:object forKey:key];
  }
}
- (void)tk_setParameterStr:(NSString *)object forKey:(NSString *)key condition:(BOOL)condition
{
  if ( condition ) {
    [self tk_setParameterStr:object forKey:key];
  }
}

@end
