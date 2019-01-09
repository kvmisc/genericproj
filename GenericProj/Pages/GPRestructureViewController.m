//
//  GPRestructureViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 9/8/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPRestructureViewController.h"

@implementation GPRestructureViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.contentView.backgroundColor = [UIColor blueColor];
}


- (void)updateViewConstraints
{
  [super updateViewConstraints];

  if ( self.contentView ) {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(30, 30, 30, 30));
    }];
  }
}

//- (BOOL)shouldLoadContentView
//{
//  return NO;
//}

@end
