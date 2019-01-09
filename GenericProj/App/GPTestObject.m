//
//  GPTestObject.m
//  GenericProj
//
//  Created by Haiping Wu on 2018/11/21.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "GPTestObject.h"

//@implementation Singleton
//+ (id)sharedObject
//{
//  static Singleton *SharedSingleton = nil;
//  @synchronized([Singleton class]) {
//    if ( !SharedSingleton ) {
//      SharedSingleton = [[self alloc] init];
//    }
//    return SharedSingleton;
//  }
//  return nil;
//}
//@end
//
//
//
//@implementation PizzaBuilder
//- (void)prepareNewPizza
//{
//  _pizza = [[Pizza alloc] init];
//}
//- (void)buildDough
//{
//}
//- (void)buildSauce
//{
//}
//- (void)buildTopping
//{
//}
//@end
//
//@implementation HawaiianPizzaBuilder
//- (void)buildDough
//{
//  self.pizza.dough = @"cross";
//}
//- (void)buildSauce
//{
//  self.pizza.sauce = @"mild";
//}
//- (void)buildTopping
//{
//  self.pizza.topping = @"ham+pineapple";
//}
//@end
//
//@implementation SpicyPizzaBuilder
//- (void)buildDough
//{
//  self.pizza.dough = @"pan baked";
//}
//- (void)buildSauce
//{
//  self.pizza.sauce = @"hot";
//}
//- (void)buildTopping
//{
//  self.pizza.topping = @"pepperoni+salami";
//}
//@end
//
//
//@implementation Waiter
//- (void)constructPizza
//{
//  [_builder prepareNewPizza];
//  [_builder buildDough];
//  [_builder buildSauce];
//  [_builder buildTopping];
//}
//- (Pizza *)getPizza
//{
//  return _builder.pizza;
//}
//@end
//
//void sample()
//{
//  Waiter *waiter = [[Waiter alloc] init];
//  PizzaBuilder *builder1 = [[HawaiianPizzaBuilder alloc] init];
//  //PizzaBuilder *builder2 = [[SpicyPizzaBuilder alloc] init];
//  waiter.builder = builder1;
//  [waiter constructPizza];
//  Pizza *pizza = [waiter getPizza];
//}
