//
//  GPFlowHeadView.m
//  GenericProj
//
//  Created by Kevin Wu on 1/12/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPFlowHeadView.h"

@implementation GPFlowHeadView

- (CGSize)intrinsicContentSize
{
  return CGSizeMake(UIViewNoIntrinsicMetric, 40.0);
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"[GPFlowHeadView] title=%@", self.titleLabel.text];
}

@end
