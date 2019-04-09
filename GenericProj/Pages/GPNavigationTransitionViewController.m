//
//  GPNavigationTransitionViewController.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/8.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPNavigationTransitionViewController.h"
#import "GPKeyframeAnimationView.h"

@interface GPNavigationTransitionViewController ()
@property (nonatomic, strong) GPKeyframeAnimationView *animationView;
@end

@implementation GPNavigationTransitionViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor lightGrayColor];

  _animationView = [[GPKeyframeAnimationView alloc] init];
  [self.view addSubview:_animationView];
  [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
  @weakify(self);
  [_animationView mas_updateConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
  }];
  [super updateViewConstraints];
}

@end
