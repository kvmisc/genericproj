//
//  GPPerson.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/3/25.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPPerson.h"

@implementation GPPerson
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.name = @"";
//    _gender = 2;
//    _grade = 3;
  }
  return self;
}
//+ (void)initialize { NSLog(@"p"); }
//- (instancetype)init
//{
//  self = [super init];
//  if (self) {
//    NSLog(@"%@", [self class]);
//    NSLog(@"%@", [self superclass]);
//    NSLog(@"------");
//    NSLog(@"%@", [super class]);
//    NSLog(@"%@", [super superclass]);
//  }
//  return self;
//}
//- (void)dealloc { NSLog(@"dlc"); }
@end
//@implementation GPPerson (P2)
//+ (void)initialize { NSLog(@"p2"); }
//@end
//@implementation GPPerson (P1)
//+ (void)initialize { NSLog(@"p1"); }
//@end

@implementation GPStudent
//- (instancetype)init
//{
//  self = [super init];
//  if (self) {
////    _age = 17;
////    _gender = 18;
////    _grade = 19;
//  }
//  return self;
//}
//+ (void)initialize { NSLog(@"s"); }
- (void)setName:(NSString *)name
{
  [super setName:@"xx"];
}
@end
//@implementation GPStudent (S1)
//+ (void)initialize { NSLog(@"s1"); }
//@end
//@implementation GPStudent (S2)
//+ (void)initialize { NSLog(@"s2"); }
//@end
