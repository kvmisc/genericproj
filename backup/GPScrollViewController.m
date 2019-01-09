//
//  GPScrollViewController.m
//  GenericProj
//
//  Created by Haiping Wu on 08/02/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "GPScrollViewController.h"

#import "GPScrollSectionView.h"

@interface GPScrollViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GPScrollViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.automaticallyAdjustsScrollViewInsets = NO;

//  UILabel *label = [UILabel tk_labelWithFont:[UIFont systemFontOfSize:14.0] textColor:[UIColor blackColor]];
//  label.backgroundColor = [UIColor darkGrayColor];
//  label.textAlignment = NSTextAlignmentCenter;
//  label.text = @"Loading ...";
//  [_scrollView tk_addSubview:label];

//  //@weakify(self);
//  [label mas_updateConstraints:^(MASConstraintMaker *make) {
//    //@strongify(self);
//    make.left.equalTo(@(20.0));
//    make.top.equalTo(@(20.0));
//    make.right.equalTo(@(20.0));
//  }];


  GPScrollSectionView *sectionView = [[GPScrollSectionView alloc] init];
  sectionView.backgroundColor = [UIColor brownColor];
  [_scrollView tk_addSubview:sectionView];

  [_scrollView tk_updateConstraints];
}

@end
