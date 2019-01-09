//
//  GPKVOViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 9/12/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPKVOViewController.h"
#import "GPKVOObject.h"

@implementation GPKVOViewController {
  GPKVOObject *_object;
}

#ifdef DEBUG
- (void)dealloc
{
  XYZPrintMethod();
}
#endif


- (void)viewDidLoad
{
  [super viewDidLoad];

  _object = [[GPKVOObject alloc] init];

  [self.KVOController observe:_object keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
    NSLog(@"observer: %@", observer);
    NSLog(@"object: %@", object);
    NSLog(@"change: %@", change);
  }];

  _object.name = @"asdf";

  _object.name = @"asdf";

}

@end
