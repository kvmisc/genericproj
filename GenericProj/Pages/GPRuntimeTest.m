//
//  GPRuntimeTest.m
//  GenericProj
//
//  Created by Haiping Wu on 08/03/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "GPRuntimeTest.h"

void IMPFoobar(id self, SEL _cmd)
{
  NSLog(@"imp: %p %s", self, sel_getName(_cmd));
}

@implementation GPRuntimeTest

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
  NSLog(@"resolve: %@", NSStringFromSelector(sel));
//  if ( strcmp(sel_getName(sel), "foobar")==0 )
//  {
//    class_addMethod([self class], sel, (IMP)IMPFoobar, "v@:");
//    return YES;
//  }
  return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)sel
{
  NSLog(@"fast forward: %@", NSStringFromSelector(sel));
//  if ( strcmp(sel_getName(sel), "foobar")==0 )
//  {
//    return _forwardObject;
//  }
  return [super forwardingTargetForSelector:sel];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  NSLog(@"normal forward: %@", NSStringFromSelector(sel));
  NSMethodSignature *sig = [_forwardObject methodSignatureForSelector:sel];
  if ( sig ) {
    return sig;
  }
  return [[self class] instanceMethodSignatureForSelector:@selector(forAnyMethod)];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  SEL selector = [anInvocation selector];
  if ( [_forwardObject respondsToSelector:selector] ) {
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
      @strongify(self);
      [anInvocation invokeWithTarget:self.forwardObject];
    });
  }
}

- (void)forAnyMethod
{
  NSLog(@"in any");
}

@end
