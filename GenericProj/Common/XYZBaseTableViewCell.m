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
      _aboveLine.backgroundColor = [UIColor redColor];
      [self.contentView addSubview:_aboveLine];
    }
    _aboveLine.hidden = NO;
  } else {
    _aboveLine.hidden = YES;
  }
  [_aboveLine tk_bringToFront];

  if ( !_belowLine ) {
    _belowLine = [[UIView alloc] init];
    _belowLine.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_belowLine];
  }
  [_belowLine tk_bringToFront];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
}

@end
