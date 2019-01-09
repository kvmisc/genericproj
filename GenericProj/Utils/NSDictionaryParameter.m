//
//  NSDictionaryParameter.m
//  GenericProj
//
//  Created by Haiping Wu on 2018/6/22.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "NSDictionaryParameter.h"

@implementation NSDictionary (Parameter)

- (void)tk_setParameters:(NSDictionary *)parameters
{
  [(NSMutableDictionary *)self removeAllObjects];
  @weakify(self);
  [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    @strongify(self);
    if ( key.length>0 ) {
      [(NSMutableDictionary *)self setObject:obj forKey:key];
    }
  }];
}

- (void)tk_setParameterInt:(NSInteger)parameter forKey:(NSString *)key
{
  [self tk_setParameterInt:parameter forKey:key condition:(parameter>0)];
}
- (void)tk_setParameterInt:(NSInteger)parameter forKey:(NSString *)key condition:(BOOL)condition
{
  if ( key.length>0 ) {
    if ( condition ) {
      [(NSMutableDictionary *)self setObject:[@(parameter) stringValue] forKey:key];
    }
  }
}

- (void)tk_setParameterFlt:(CGFloat)parameter forKey:(NSString *)key
{
  [self tk_setParameterFlt:parameter forKey:key condition:(parameter>0.0)];
}
- (void)tk_setParameterFlt:(CGFloat)parameter forKey:(NSString *)key condition:(BOOL)condition
{
  if ( key.length>0 ) {
    if ( condition ) {
      [(NSMutableDictionary *)self setObject:[@(parameter) stringValue] forKey:key];
    }
  }
}

- (void)tk_setParameterStr:(NSString *)parameter forKey:(NSString *)key
{
  [self tk_setParameterStr:parameter forKey:key condition:parameter.length>0];
}
- (void)tk_setParameterStr:(NSString *)parameter forKey:(NSString *)key condition:(BOOL)condition
{
  if ( key.length>0 ) {
    if ( parameter ) {
      if ( condition ) {
        [(NSMutableDictionary *)self setObject:parameter forKey:key];
      }
    } else {
      [(NSMutableDictionary *)self removeObjectForKey:key];
    }
  }
}


- (void)tk_removeParameterForKey:(NSString *)key
{
  [(NSMutableDictionary *)self removeObjectForKey:key];
}
- (void)tk_removeAllParameters
{
  [(NSMutableDictionary *)self removeAllObjects];
}

@end
