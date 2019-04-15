//
//  GPNavigationTransitionViewController.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/8.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPNavigationTransitionViewController.h"
#import "GPKeyframeAnimationView.h"
#import "../Common/XYZCoverAlertView.h"
#import "../Common/XYZCoverActionView.h"
#import "../Common/XYZCoverSpringView.h"

@interface GPNavigationTransitionViewController () <
    CAAnimationDelegate
>
@property (nonatomic, strong) GPKeyframeAnimationView *animationView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) XYZCoverAlertView *alertView;
@property (nonatomic, strong) XYZCoverActionView *actionView;
@end

@implementation GPNavigationTransitionViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

//  self.view.backgroundColor = [UIColor lightGrayColor];

//  _animationView = [[GPKeyframeAnimationView alloc] init];
//  [self.view addSubview:_animationView];
//  [self.view setNeedsUpdateConstraints];


//  _redView = [[UIView alloc] init];
//  _redView.backgroundColor = [UIColor redColor];
//  //_redView.layer.opacity = 0.0;
//  _redView.frame = CGRectMake(50, 50, 100, 100);
//  [self.view addSubview:_redView];
//
//  CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
//  animation1.fromValue = [NSValue valueWithCGPoint:_redView.layer.position];
//  animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
//  animation1.duration = 3.0;
//  animation1.removedOnCompletion = NO;
//  animation1.delegate = self;
//  animation1.fillMode = kCAFillModeForwards;
//  [_redView.layer addAnimation:animation1 forKey:@"ani"];
//
//  NSLog(@"PRE: %@", _redView.layer.presentationLayer);

//  _alertView = [[XYZCoverAlertView alloc] init];
//  [_alertView prepareForView:self.view viewport:nil];
//  [_alertView.coverView show:YES];
}

//- (void)animationDidStart:(CAAnimation *)anim
//{
//  NSLog(@"animation start: %@", anim);
//}
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//  NSLog(@"animation stop: %@ %d", anim, flag);
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//  _redView.layer.position = _redView.layer.presentationLayer.position;
//  [_redView.layer removeAllAnimations];

//  NSLog(@"PRE: %@", _redView.layer.presentationLayer);
//
//  NSLog(@"%@ %@ %@", NSStringFromCGRect(_redView.frame), NSStringFromCGPoint(_redView.layer.position), NSStringFromCGPoint(_redView.layer.presentationLayer.position));

//  _alertView = [[XYZCoverAlertView alloc] init];
//  [_alertView prepareForView:self.view viewport:nil];
//  [_alertView.coverView show:YES];
//  [_alertView.coverView hide:YES afterDelay:3.0];

  _actionView = [[XYZCoverActionView alloc] init];
  [_actionView prepareForView:self.view viewport:nil];
  [_actionView.coverView show:YES];
//  [_actionView.coverView hide:YES afterDelay:3.0];

//  XYZCoverSpringView *springView = [[XYZCoverSpringView alloc] init];
//  [springView prepareForView:self.view viewport:nil];
//  [springView.coverView show:YES];
}

//- (void)updateViewConstraints
//{
//  @weakify(self);
//  [_animationView mas_updateConstraints:^(MASConstraintMaker *make) {
//    @strongify(self);
//    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
//  }];
//  [super updateViewConstraints];
//}

@end
