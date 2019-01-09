//
//  UIScrollViewExtentions.m
//  GenericProj
//
//  Created by Haiping Wu on 08/02/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "UIScrollViewExtentions.h"

@implementation UIScrollView (Extentions)

- (UIView *)tk_contentView
{
  UIView *contentView = objc_getAssociatedObject(self, @selector(tk_contentView));
  if ( !contentView ) {
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    objc_setAssociatedObject(self, @selector(tk_contentView), contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return contentView;
}


- (NSArray *)tk_subviews
{
  return [[self tk_contentView] subviews];
}

- (void)tk_addSubview:(UIView *)view
{
  if ( view ) {
    UIView *contentView = [self tk_contentView];
    if ( view.superview!=contentView ) {
      [view removeFromSuperview];
      [contentView addSubview:view];
    }
  }
}

- (void)tk_removeAllSubviews
{
  [[[self tk_contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


- (void)tk_updateConstraints
{
  @weakify(self);

  UIView *contentView = [self tk_contentView];

  NSArray *itemAry = [self tk_subviews];
  UIView *prev = nil;
  for ( NSUInteger i=0; i<[itemAry count]; ++i ) {
    UIView *it = [itemAry objectAtIndex:i];
    @weakify(prev);
    [it mas_remakeConstraints:^(MASConstraintMaker *make) {
      @strongify(self, prev);
      make.left.right.equalTo(self.tk_contentView);
      make.top.equalTo(prev ? prev.mas_bottom : self.tk_contentView.mas_top);
    }];
    prev = it;
  }

  @weakify(prev);
  [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self, prev);
    make.edges.equalTo(self);
    make.width.equalTo(self);
    if ( prev ) {
      make.bottom.equalTo(prev.mas_bottom);
    } else {
      make.height.equalTo(@(0.0));
    }
  }];
}

@end
