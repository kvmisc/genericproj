//
//  XYZBaseTableViewCell.m
//  GenericProj
//
//  Created by Haiping Wu on 2018/4/13.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "XYZBaseTableViewCell.h"

@implementation XYZBaseTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  NSLog(@"setSelected(%d)animated(%d)", selected, animated);
  _aboveLine.backgroundColor = [UIColor redColor];
  _belowLine.backgroundColor = [UIColor blueColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
  [super setHighlighted:highlighted animated:animated];
  NSLog(@"setHighlighted(%d)animated(%d)", highlighted, animated);
  _aboveLine.backgroundColor = [UIColor redColor];
  _belowLine.backgroundColor = [UIColor blueColor];
}

- (void)configLine:(NSInteger)index count:(NSInteger)count
{
  if ( index==0 ) {
    if ( !_aboveLine ) {
      _aboveLine = [[UIView alloc] init];
      [self.contentView addSubview:_aboveLine];
    }
    _aboveLine.backgroundColor = [UIColor redColor];
    @weakify(self);
    [_aboveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.left.top.right.equalTo(self.contentView);
      make.height.equalTo(@(1.0));
    }];
  } else {
    [_aboveLine removeFromSuperview];
    _aboveLine = nil;
  }

  if ( !_belowLine ) {
    _belowLine = [[UIView alloc] init];
    [self.contentView addSubview:_belowLine];
  }
  _belowLine.backgroundColor = [UIColor blueColor];
  @weakify(self);
  [_belowLine mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.bottom.right.equalTo(self.contentView);
    make.height.equalTo(@(1.0));
    if ( (index+1)<count ) {
      make.left.equalTo(self.contentView).offset(10.0);
    } else {
      make.left.equalTo(self.contentView);
    }
  }];
}

@end
