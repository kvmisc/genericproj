//
//  XYZAnimation.m
//  GenericProj
//
//  Created by Haiping Wu on 29/03/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "XYZAnimation.h"

@implementation XYZAnimation

- (CGFloat)progress
{
  return (CACurrentMediaTime() - _startTime) / _duration;
}

- (void)tick
{
  if ( _animations ) {
    _animations(self.progress);
  }
}

- (void)complete:(BOOL)finished
{
  if ( _completion ) {
    _completion(finished);
  }
}

@end
