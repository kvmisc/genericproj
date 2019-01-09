//
//  XYZMultilineButton.m
//  GenericProj
//
//  Created by Haiping Wu on 11/02/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "XYZMultilineButton.h"

@implementation XYZMultilineButton

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  }
  return self;
}

- (CGSize)intrinsicContentSize
{
  return self.titleLabel.intrinsicContentSize;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
  [super layoutSubviews];
}

@end
