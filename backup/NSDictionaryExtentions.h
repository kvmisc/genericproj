//
//  NSDictionaryExtentions.h
//  GenericProj
//
//  Created by Haiping Wu on 16/01/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Extentions)

- (void)tk_setParameter:(NSString *)object forKey:(NSString *)key;

- (void)tk_setParameterInt:(NSInteger)object forKey:(NSString *)key;
- (void)tk_setParameterInt:(NSInteger)object forKey:(NSString *)key condition:(BOOL)condition;

- (void)tk_setParameterFlt:(CGFloat)object forKey:(NSString *)key;
- (void)tk_setParameterFlt:(CGFloat)object forKey:(NSString *)key condition:(BOOL)condition;

- (void)tk_setParameterStr:(NSString *)object forKey:(NSString *)key;
- (void)tk_setParameterStr:(NSString *)object forKey:(NSString *)key condition:(BOOL)condition;

@end
