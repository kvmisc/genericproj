//
//  GPSourceView.m
//  GenericProj
//
//  Created by Kevin Wu on 13/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPSourceView.h"

@interface GPSourceView ()
@property (nonatomic, assign) CGRect beginFrame;
@end

@implementation GPSourceView

- (id)init
{
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor redColor];
  }
  return self;
}

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport
{
  [super prepareForView:inView viewport:viewport];

  @weakify(self);

  CGFloat contentHeight = 200.0;

  self.frame = CGRectMake(0.0,
                          self.coverView.frame.size.height,
                          self.coverView.frame.size.width,
                          contentHeight);

  self.showAnimation = ^(CGFloat progress) {
    @strongify(self);
    self.frame = CGRectMake(self.beginFrame.origin.x + progress * (0.0-self.beginFrame.origin.x),
                            self.beginFrame.origin.y + progress * (self.coverView.frame.size.height-contentHeight-self.beginFrame.origin.y),
                            self.beginFrame.size.width + progress * (self.coverView.frame.size.width-self.beginFrame.size.width),
                            self.beginFrame.size.height + progress * (contentHeight-self.beginFrame.size.height));
  };

  self.hideAnimation = ^(CGFloat progress) {
    @strongify(self);
    self.frame = CGRectMake(self.beginFrame.origin.x + progress * (0.0-self.beginFrame.origin.x),
                            self.beginFrame.origin.y + progress * (self.coverView.frame.size.height-self.beginFrame.origin.y),
                            self.beginFrame.size.width + progress * (self.coverView.frame.size.width-self.beginFrame.size.width),
                            self.beginFrame.size.height + progress * (contentHeight-self.beginFrame.size.height));
  };
}

- (void)prepareForAnimation
{
  _beginFrame = self.frame;
}

@end

