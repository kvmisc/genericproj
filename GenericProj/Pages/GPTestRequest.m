//
//  GPTestRequest.m
//  GenericProj
//
//  Created by Kevin Wu on 9/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPTestRequest.h"

@implementation GPTestRequest

- (void)setup
{
  self.address = @"http://kevinsblog.cn/";
  self.address = @"http://twitter.com/";

  self.method = @"POST";

  [self.headers setValue:@"h3v" forKey:@"h3"];
  [self.headers setValue:@"h1v" forKey:@"h1"];

  [self.queries setValue:@"q1v" forKey:@"qa"];
  [self.queries setValue:@"q2v" forKey:@"qb"];

  [self.parameters setValue:@"p1v" forKey:@"pa"];
  [self.parameters setValue:@"p2v" forKey:@"pb"];

  //self.body = [[NSData alloc] initWithBytes:"jkhjal" length:6];
}

- (void)parse:(id)object
{
  // ...
}

@end
