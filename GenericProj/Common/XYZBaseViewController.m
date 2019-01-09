//
//  XYZBaseViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 12/29/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import "XYZBaseViewController.h"

@interface XYZBaseViewController ()
@property (nonatomic, assign) BOOL appearedEver;
@end

@implementation XYZBaseViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  if ( @available(iOS 11.0, *) ) {
    // TODO: ...
    //_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  } else {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }

  [self loadContentViewIfNeeded];

  // 在 viewDidDisappear: 调用完成后再修改 appearedEver 的值，这样在子类中任何时候检测此字
  // 段都能取到真正的值。
  @weakify(self);
  [self aspect_hookSelector:@selector(viewDidDisappear:)
                withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval
                 usingBlock:^{ @strongify(self); self.appearedEver = YES; }
                      error:NULL];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints
{
  if ( _contentView ) {
    @weakify(self);
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0));
    }];
  }

  // 必须在最后调用父类实现。
  [super updateViewConstraints];
}



//- (void)viewWillAppear:(BOOL)animated
//{
//  [super viewWillAppear:animated];
//}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  _viewAppeared = YES;

  [self startActivities];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//  [super viewWillDisappear:animated];
//}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];

  if ( self.isMovingFromParentViewController ) {
    [self destroyActivities];
  } else {
    [self stopActivities];
  }

  _viewAppeared = NO;
}



- (void)startActivities
{
}

- (void)stopActivities
{
}

- (void)destroyActivities
{
}



- (BOOL)shouldLoadContentView
{
  return YES;
}

- (void)loadContentViewIfNeeded
{
  if ( ![self shouldLoadContentView] ) {
    return;
  }

  if ( _contentView ) {
    return;
  }


  _contentView = [self.view.subviews firstObject];
  if ( _contentView ) {
    [_contentView removeFromSuperview];
  } else {
    _contentView = [[UIView alloc] init];
  }
  [self.view insertSubview:_contentView atIndex:0];

  [self updateViewConstraints];
}

@end
