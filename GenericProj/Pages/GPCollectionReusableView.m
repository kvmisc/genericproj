//
//  GPCollectionReusableView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/3/11.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPCollectionReusableView.h"

@implementation GPCollectionReusableView

- (void)awakeFromNib
{
  [super awakeFromNib];

  self.layer.borderWidth = 1.0;
  self.layer.borderColor = [[UIColor blackColor] CGColor];
}

@end
