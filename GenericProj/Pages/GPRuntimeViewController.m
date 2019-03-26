//
//  GPRuntimeViewController.m
//  GenericProj
//
//  Created by Haiping Wu on 08/03/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "GPRuntimeViewController.h"

#import "GPRuntimeTest.h"


@implementation GPRuntimeViewController {
  GPRuntimeTest *_test;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  _test = [[GPRuntimeTest alloc] init];
//  _test.forwardObject = self;
  NSLog(@"test: %p", _test);
//  [_test performSelector:NSSelectorFromString(@"foobar")];


//  [GPRuntimeViewController methodForSelector:@selector(someMethod)];
//
//
//
//  SEL theSelector = @selector(someMethodA:);
//  Method theMethod = class_getInstanceMethod([self class], theSelector);
//  MY_IMP theImplementation = (MY_IMP)method_getImplementation(theMethod);
//  //MY_IMP theImplementation = (MY_IMP)[self methodForSelector:theSelector];
//  theImplementation(self, theSelector, 102);
}

- (void)foobar
{
  NSLog(@"forwarded foobar");
}

@end
