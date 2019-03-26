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

  GPPerson *person = [[GPPerson alloc] init];

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

}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context
//{
//  NSLog(@"%@ %@", keyPath, object);
//}

@end
