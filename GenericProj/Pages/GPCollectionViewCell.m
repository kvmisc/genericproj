//
//  GPCollectionViewCell.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/3/11.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPCollectionViewCell.h"

@implementation GPCollectionViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];

  self.contentView.layer.borderWidth = 1.0;
  self.contentView.layer.borderColor = [[UIColor blackColor] CGColor];
}

@end
