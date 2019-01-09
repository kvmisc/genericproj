//
//  XYZBaseView.m
//  GenericProj
//
//  Created by Kevin Wu on 8/12/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import "XYZBaseView.h"

@implementation XYZBaseView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}



- (void)setup
{
  XYZPrintMethod();
}



- (void)awakeFromNib
{
  // 必须调用父类的实现。
  [super awakeFromNib];

  XYZPrintMethod();
  // 做些 xib 加载完成后的工作。
  // ...
}



- (void)updateConstraints
{
  XYZPrintMethod();
  // 更新约束。
  // ...

  // 必须在最后调用父类实现。
  [super updateConstraints];
}



+ (BOOL)requiresConstraintBasedLayout
{
  // 基于约束的布局是懒触发的，只有在添加了约束的情况下，系统才会自动调用 updateConstraints
  // 方法，如果把所有的约束放在 updateConstraints 中，那么系统将会不知道你的布局方式是基于
  // 约束的，所以重写 requiresConstraintBasedLayout 并返回 YES 就是明确告诉系统：“虽然
  // 之前没有添加约束，但我确实是基于约束的布局。”这样可以保证系统一定会调用
  // updateConstraints 方法，从而正确添加约束。
  return YES;
}

@end
