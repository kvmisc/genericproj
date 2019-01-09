//
//  NSDictionaryParameter.h
//  GenericProj
//
//  Created by Haiping Wu on 2018/6/22.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Parameter)

// parameter 传 nil 的时候清除
// key 为空字符串的时候调用无效

- (void)tk_setParameters:(NSDictionary *)parameters;

- (void)tk_setParameterInt:(NSInteger)parameter forKey:(NSString *)key; // 值 > 0
- (void)tk_setParameterInt:(NSInteger)parameter forKey:(NSString *)key condition:(BOOL)condition;

- (void)tk_setParameterFlt:(CGFloat)parameter forKey:(NSString *)key; // 值 > 0.0
- (void)tk_setParameterFlt:(CGFloat)parameter forKey:(NSString *)key condition:(BOOL)condition;

- (void)tk_setParameterStr:(NSString *)parameter forKey:(NSString *)key; // 长度 > 0
- (void)tk_setParameterStr:(NSString *)parameter forKey:(NSString *)key condition:(BOOL)condition;

- (void)tk_removeParameterForKey:(NSString *)key;
- (void)tk_removeAllParameters;

@end
