//
//  GPObjcViewController.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/3/25.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPObjcViewController.h"
#import "GPPerson.h"
#import <malloc/malloc.h>

@implementation GPObjcViewController {
  GPPerson *_person;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

//  NSLog(@"%@", [self class]);
//  NSLog(@"%@", [self superclass]);
//  NSLog(@"------");
//  NSLog(@"%@", [super class]);
//  NSLog(@"%@", [super superclass]);

//  GPPerson *person = [[GPPerson alloc] init];
//  NSLog(@"%d", [NSObject isKindOfClass:[NSObject class]]);
//  NSLog(@"%d", [GPPerson isKindOfClass:[NSObject class]]);

//  NSLog(@"bk %@", [^{
//    NSLog(@"blk %d", age);
//  } class]);

//  void (^blk)(void) = ^{
//    NSLog(@"blk %d", age);
//  };
//  NSLog(@"%@", [blk class]);

//  _person = [[GPPerson alloc] init];

//  [_person addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew context:NULL];
//  [_person setValue:@(10) forKey:@"height"];

//  [_person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:NULL];
//  [_person setValue:@(10) forKey:@"age"];
//  Class cls = [_person class];

//  NSLog(@"%zd", class_getInstanceSize([NSObject class]));
//  NSLog(@"%zd", class_getInstanceSize([GPPerson class]));
//  NSLog(@"%zd", class_getInstanceSize([GPStudent class]));
//
//  NSLog(@" ");
//  NSLog(@" ");
//
//  NSObject *o = [[NSObject alloc] init];
//  GPPerson *p = [[GPPerson alloc] init];
//  GPStudent *s = [[GPStudent alloc] init];
//  NSLog(@"%zd", malloc_size((__bridge const void *)o));
//  NSLog(@"%zd", malloc_size((__bridge const void *)p));
//  NSLog(@"%zd", malloc_size((__bridge const void *)s));
//
//
//  // 类对象和元类对象不同
//  Class objectClass = [NSObject class];
//  NSLog(@"%d", class_isMetaClass(objectClass));
//  Class objectMetaClass = object_getClass([NSString class]);
//  NSLog(@"%d", class_isMetaClass(objectMetaClass));
//
//  {
//    Class c1 = [o class];
//    Class c2 = object_getClass(c1);
//    Class c3 = object_getClass(c2);
//    NSLog(@"%@ %@ %@", c1, c2, c3);
//  }
//  {
//    Class c1 = [p class];
//    Class c2 = object_getClass(c1);
//    Class c3 = object_getClass(c2);
//    NSLog(@"%@ %@ %@", c1, c2, c3);
//  }
//  {
//    Class c1 = [s class];
//    Class c2 = object_getClass(c1);
//    Class c3 = object_getClass(c2);
//    NSLog(@"%@ %@ %@", c1, c2, c3);
//  }

//  [GPStudent alloc];
//  [GPPerson alloc];
//  [GPStudent alloc];
  CGRect rect1 = CGRectMake(10.5, 11.5, 20.5, 21.5);
  NSLog(@"%@", NSStringFromCGRect(rect1));
  CGRect rect2 = CGRectIntegral(rect1);
  NSLog(@"%@", NSStringFromCGRect(rect2));

  NSLog(@"1 - %@", [NSThread currentThread]);

  dispatch_async(dispatch_get_global_queue(0, 0), ^{

    NSLog(@"2 - %@", [NSThread currentThread]);
//    [self performSelector:@selector(test)
//               withObject:nil
//               afterDelay:0];
//    [[NSRunLoop currentRunLoop] run];
    [self performSelector:@selector(test)
                 onThread:[NSThread currentThread]
               withObject:nil
            waitUntilDone:NO];
    //[[NSRunLoop currentRunLoop] run];
//    [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate distantFuture]];
    NSLog(@"4 - %@", [NSThread currentThread]);
  });
}

- (void)test
{
  NSLog(@"3 - %@", [NSThread currentThread]);
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context
//{
//  NSLog(@"%@ %@", keyPath, object);
//}

@end
