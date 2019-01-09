//
//  GPFlowLineView.m
//  GenericProj
//
//  Created by Kevin Wu on 1/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPFlowLineView.h"

@implementation GPFlowLineView

- (CGSize)intrinsicContentSize
{
  return CGSizeMake(UIViewNoIntrinsicMetric, 60.0);
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"[GPFlowLineView] tag=%ld", (long)(self.colorView.tag)];
}

@end
