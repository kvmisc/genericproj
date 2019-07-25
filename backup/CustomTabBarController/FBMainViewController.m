//
//  FBMainViewController.m
//  Foobar
//
//  Created by Kevin Wu on 2019/7/5.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "FBMainViewController.h"
#import "FBRootTabBar.h"
#import "FBRotationNavigationController.h"

@interface FBMainViewController () <
    UINavigationControllerDelegate
>

@property (nonatomic, strong) NSArray *pageAry;
@property (nonatomic, strong) UIViewController *currentPage;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) FBRootTabBar *tabBar;

@end

@implementation FBMainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self setupPages];
  [self setupContentView];
  [self setupTabBar];

  [self showPageAtIndex:0];
}

//- (void)viewWillLayoutSubviews
//{
//  [super viewWillLayoutSubviews];
//  self.contentView.frame = self.view.bounds;
//  _currentPage.view.frame = self.contentView.bounds;
//
//  // 为了 Push 时候的动画效果，TabBar 可能会加入到 NavRoot 上，那时就不应该在此布局了
//  if ( _tabBar.superview==self.view ) {
//    _tabBar.frame = CGRectMake(0.0,
//                               FB_SCREEN_HET-FB_SAFE_AREA_BOT-kFBRootTabBarHeight,
//                               FB_SCREEN_WID,
//                               FB_SAFE_AREA_BOT+kFBRootTabBarHeight);
//  }
//}
- (void)updateViewConstraints
{
  @weakify(self);

  [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.edges.equalTo(self.view);
  }];

  [_currentPage.view mas_remakeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.edges.equalTo(self.contentView);
  }];

  if ( (_tabBar) && (_tabBar.superview==self.view) ) {
    [_tabBar mas_remakeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.left.right.bottom.equalTo(self.view);
      make.height.equalTo(@(FB_SAFE_AREA_BOT+kFBRootTabBarHeight));
    }];
  }

  [super updateViewConstraints];
}

#pragma mark - Public methods

- (void)changeToPage:(NSUInteger)idx
{
  if ( [_tabBar isIndexValid:idx] ) {
    _tabBar.selectedIndex = idx;
    [self showPageAtIndex:idx];
    [self adjustTabBarSuperviewIfNeeded];
  }
}

#pragma mark - Private methods

- (void)showPageAtIndex:(NSUInteger)idx
{
  [(UINavigationController *)_currentPage setDelegate:nil];

  [self fb_dismissChildViewController:_currentPage];
  UIViewController *pageToShow = [_pageAry objectAtIndex:idx];
  [self fb_presentChildViewController:pageToShow inView:self.contentView];
  _currentPage = pageToShow;

  [(UINavigationController *)_currentPage setDelegate:self];

  [self.view setNeedsUpdateConstraints];
}

- (void)adjustTabBarSuperviewIfNeeded
{
  UINavigationController *nc = (UINavigationController *)_currentPage;
  if ( nc.viewControllers.count>1 ) {
    // 显示的是非根，TabBar 需要隐藏，且要位于 NavRoot 中
    FBBaseViewController *root = [nc.viewControllers firstObject];
    [self addTabBarToNavRootIfNeeded:root];
  } else {
    // 显示的是根，TabBar 不需要隐藏，且要位于 Root 中
    [self addTabBarToRootIfNeeded];
  }
}

- (void)addTabBarToNavRootIfNeeded:(FBBaseViewController *)root
{
  if ( _tabBar.superview!=root.toolBar ) {
    NSLog(@"add to nav root: %@", root);
    [_tabBar removeFromSuperview];
    [root.toolBar setContentView:_tabBar];
    //_tabBar.frame = root.toolBar.bounds;
  }
}

- (void)addTabBarToRootIfNeeded
{
  if ( _tabBar.superview!=self.view ) {
    NSLog(@"add to root: %@", self);
    [_tabBar removeFromSuperview];
    [self.view addSubview:_tabBar];
    [self.view setNeedsUpdateConstraints];
  }
}

#pragma mark - Setup subviews

- (void)setupPages
{
  _homeViewController = [[FBHomeViewController alloc] init];
  _homeViewController.hidesBottomBarWhenPushed = YES;
  UINavigationController *nc1 = [[FBRotationNavigationController alloc] initWithRootViewController:_homeViewController];
  nc1.navigationBarHidden = YES;

  _hotViewController = [[FBHotViewController alloc] init];
  _hotViewController.hidesBottomBarWhenPushed = YES;
  UINavigationController *nc2 = [[FBRotationNavigationController alloc] initWithRootViewController:_hotViewController];
  nc2.navigationBarHidden = YES;

  _categoryViewController = [[FBCategoryViewController alloc] init];
  _categoryViewController.hidesBottomBarWhenPushed = YES;
  UINavigationController *nc3 = [[FBRotationNavigationController alloc] initWithRootViewController:_categoryViewController];
  nc3.navigationBarHidden = YES;

  _roleViewController = [[FBRoleViewController alloc] init];
  _roleViewController.hidesBottomBarWhenPushed = YES;
  UINavigationController *nc4 = [[FBRotationNavigationController alloc] initWithRootViewController:_roleViewController];
  nc4.navigationBarHidden = YES;

  _pageAry = @[nc1, nc2, nc3, nc4];
}

- (void)setupContentView
{
  _contentView = [[UIView alloc] init];
  [self.view addSubview:_contentView];
}

- (void)setupTabBar
{
  @weakify(self);
  _tabBar = [[FBRootTabBar alloc] init];
  [self.view addSubview:_tabBar];
  _tabBar.didSelect = ^(NSUInteger idx) {
    @strongify(self);
    [self showPageAtIndex:idx];
    [self adjustTabBarSuperviewIfNeeded];
  };
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  //NSLog(@"will show: %@ %@", viewController, navigationController.viewControllers);
  FBBaseViewController *root = [navigationController.viewControllers firstObject];
  if ( root!=viewController ) {
    // 即将显示非根，如果 TabBar 不在 NavRoot 中，将其移过去，这样 TabBar 会随着 NavRoot 被 Push 隐藏
    [self addTabBarToNavRootIfNeeded:root];
  }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  //NSLog(@"did show: %@ %@", viewController, navigationController.viewControllers);
  FBBaseViewController *root = [navigationController.viewControllers firstObject];
  if ( root==viewController ) {
    // 已经显示根，如果 TabBar 不在 Root 中，将其移过来
    [self addTabBarToRootIfNeeded];
  }
}



- (BOOL)shouldAutorotate
{
  if ( _currentPage ) {
    return [_currentPage shouldAutorotate];
  }
  return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  if ( _currentPage ) {
    return [_currentPage supportedInterfaceOrientations];
  }
  return UIInterfaceOrientationMaskPortrait;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
  return _currentPage;
}

@end
