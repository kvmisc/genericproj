//
//  UIButtonExtentions.m
//  GenericProj
//
//  Created by Kevin Wu on 9/8/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "UIButtonExtentions.h"
#import <objc/runtime.h>

@implementation UIButton (Extentions)

- (void)tk_centerHorizontally:(CGFloat)spacing
{
  CGFloat offset = ceil(spacing/2.0);
  self.imageEdgeInsets = UIEdgeInsetsMake(0.0, -offset, 0.0, offset);
  self.titleEdgeInsets = UIEdgeInsetsMake(0.0, offset, 0.0, -offset);
}

- (void)tk_swapAndCenterHorizontally:(CGFloat)spacing
{
  CGSize imageSize = self.imageView.frame.size;
  CGSize titleSize = self.titleLabel.frame.size;

  CGFloat imageOffsetH = titleSize.width+spacing/2.0;
  CGFloat titleOffsetH = imageSize.width+spacing/2.0;

  self.imageEdgeInsets = UIEdgeInsetsMake(0.0, imageOffsetH, 0.0, -imageOffsetH);
  self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -titleOffsetH, 0.0, titleOffsetH);
}


- (void)tk_centerVertically:(CGFloat)spacing
{
  CGSize imageSize = self.imageView.image.size;
  CGSize titleSize = self.titleLabel.frame.size;

  CGFloat titleOffsetV = (imageSize.height+spacing)/2.0;
  self.titleEdgeInsets = UIEdgeInsetsMake(titleOffsetV, -imageSize.width, -titleOffsetV, 0.0);

  CGFloat imageOffsetV = (titleSize.height+spacing)/2.0;
  CGFloat imageOffsetH = titleSize.width/2.0;
  self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetV, imageOffsetH, imageOffsetV, -imageOffsetH);
}


- (void)tk_removeAllTargets
{
  [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

@end
