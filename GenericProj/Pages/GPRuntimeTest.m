//
//  GPRuntimeTest.m
//  GenericProj
//
//  Created by Haiping Wu on 08/03/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "GPRuntimeTest.h"

void OtherFoobar(id self, SEL _cmd)
{
  NSLog(@"imp: %p %s", self, sel_getName(_cmd));
}

@implementation GPRuntimeTest

- (void)otherFoobar
{
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
  NSLog(@"resolve: %@", NSStringFromSelector(sel));
  if ( sel==@selector(foobar) ) {
//    // 添加 C 方法
//    class_addMethod([self class], sel, (IMP)OtherFoobar, "v@:");
    // 添加成员方法
    Method method = class_getInstanceMethod(self, @selector(otherFoobar));
    class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
    return YES;
  }
  return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)sel
{
  NSLog(@"fast forward: %@", NSStringFromSelector(sel));
//  if ( sel==@selector(foobar) ) {
//    return [[GPOtherRuntimeObject alloc] init];
//  }
  return [super forwardingTargetForSelector:sel];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  NSLog(@"normal forward: %@", NSStringFromSelector(sel));
//  NSMethodSignature *sig = [_forwardObject methodSignatureForSelector:sel];
  NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
  if ( sig ) {
    return sig;
  }
  return [[self class] instanceMethodSignatureForSelector:@selector(forAnyMethod)];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  // 修改消息接收者 1
//  [anInvocation invokeWithTarget:[[GPOtherRuntimeObject alloc] init]];

  // 修改消息接收者 2，并修改调用方法名
//  anInvocation.target = [[GPOtherRuntimeObject alloc] init];
//  anInvocation.selector = @selector(otherFoobar);
//  [anInvocation invoke];
}

- (void)forAnyMethod
{
  NSLog(@"in any");
}

@end
