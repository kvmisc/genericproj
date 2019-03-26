//
//  GPMethod.h
//  GenericProj
//
//  Created by Haiping Wu on 2019/3/26.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPMethod : NSObject

@end


// 添加实例方法
//@implementation GPObject
//- (void)otherFunc {}
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//  if ( sel==@selector(func) ) {
//    Method method = class_getInstanceMethod(self, @selector(otherFunc));
//    class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
//    return YES;
//  }
//  return [super resolveInstanceMethod:sel];
//}
//@end

// 添加 C 方法
//void OtherFunc() {}
//@implementation GPObject
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//  if ( sel==@selector(func) ) {
//    class_addMethod([self class], sel, (IMP)OtherFunc, "v@:");
//    return YES;
//  }
//  return [super resolveInstanceMethod:sel];
//}
//@end
