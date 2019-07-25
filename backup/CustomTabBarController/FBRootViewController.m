//
//  FBRootViewController.m
//  Foobar
//
//  Created by Haiping Wu on 2019/7/20.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "FBRootViewController.h"

#import "FBMainViewController.h"
#import "FBAdViewController.h"

#import "FBAdManager.h"


@interface FBRootViewController ()

@property (nonatomic, strong) FBMainViewController *mainVC;
@property (nonatomic, strong) FBAdViewController *adVC;

@property (nonatomic, weak) UIViewController *currentVC;

@end

@implementation FBRootViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(adDidComplete:)
                                               name:FBAdDidCompleteNotification
                                             object:nil];

  if ( [[FBAdManager sharedObject] shouldShowAd] ) {
    _adVC = [[FBAdViewController alloc] init];
    [self fb_presentChildViewController:_adVC inView:self.view];
    _currentVC = _adVC;
  } else {
    _mainVC = [[FBMainViewController alloc] init];
    [self fb_presentChildViewController:_mainVC inView:self.view];
    _currentVC = _mainVC;
  }
  [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
  if ( _currentVC.view.superview==self.view ) {
    @weakify(self);
    [_currentVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.edges.equalTo(self.view);
    }];
  }
  [super updateViewConstraints];
}



- (void)adDidComplete:(NSNotification *)noti
{
  if ( !_mainVC ) {
    _mainVC = [[FBMainViewController alloc] init];
  }
  if ( _currentVC!=_mainVC ) {
    [self performTransition:[self fadeTransition]
                       from:_adVC
                         to:_mainVC
                         in:self.view];
  }
}


#pragma mark - Autorotate

- (BOOL)shouldAutorotate
{
//  if ( _currentVC ) {
//    return [_currentVC shouldAutorotate];
//  }
  return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  if ( _currentVC ) {
    return [_currentVC supportedInterfaceOrientations];
  }
  return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Status bar

//- (UIViewController *)childViewControllerForStatusBarHidden
//{
//  return _currentVC;
//}

@end
