//
//  GPCoverViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 12/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPCoverViewController.h"
#import "../Common/XYZCoverSpringView.h"

@implementation GPCoverViewController {
  XYZCoverContentView *_sourceView;

//  CADisplayLink *_displayLink;
//  XYZAnimation *_animation;
//
//  NSInteger _count;
}

- (void)dealloc
{
  XYZPrintMethod();
}

- (void)viewDidLoad
{
  [super viewDidLoad];

//  _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame:)];
//  //displayLink.frameInterval = 1;
//  //displayLink.preferredFramesPerSecond = 2;
//  _displayLink.paused = YES;
//  [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//  NSLog(@"xxx");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  _sourceView = [[XYZCoverSpringView alloc] init];
  [_sourceView prepareForView:_containerView viewport:nil];
  _sourceView.coverView.completion = ^{
    NSLog(@"block: cover done");
  };
  [_sourceView.coverView show:YES];
}

- (IBAction)show:(id)sender
{
  //[_sourceView removeFromSuperview];

//  _sourceView = [[XYZCoverSpringView alloc] init];
//  [_sourceView prepareForView:_containerView viewport:nil];
//  _sourceView.coverView.completion = ^{
//    NSLog(@"block: cover done");
//  };
//  [_sourceView.coverView show:YES];

//  _sourceView = [[XYZCoverActionContentView alloc] init];
//  [_sourceView prepareForView:_containerView viewport:nil];
//  _sourceView.coverView.completion = ^{
//    NSLog(@"xxx: cover done");
//  };
//  [_sourceView.coverView show:YES];

  //[sourceView.coverView hide:YES afterDelay:5.0];


//  [UIView beginAnimations:@"testAnimation" context:nil];
//  [UIView setAnimationDuration:3.0];
//  //[UIView setAnimationDelegate:self];
//  //设置动画将开始时代理对象执行的SEL
//  //[UIView setAnimationWillStartSelector:@selector(animationDoing)];
//
//  //设置动画延迟执行的时间
//  [UIView setAnimationDelay:0];
//
//  //[UIView setAnimationRepeatCount:MAXFLOAT];
//  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//  //设置动画是否继续执行相反的动画
//  [UIView setAnimationRepeatAutoreverses:NO];
//  _blockView.frame = CGRectMake(100, 100, 50, 50);
//  //_blockView.transform = CGAffineTransformMakeScale(1.5, 1.5);
////  self.redView.transform = CGAffineTransformMakeRotation(M_PI);
//
//  [UIView commitAnimations];

//  _layer=[[CALayer alloc]init];
//  _layer.bounds=CGRectMake(0, 0, 87, 32);
//  _layer.position=CGPointMake(160, 284);
//  [self.view.layer addSublayer:_layer];

//  @weakify(self);
//  _animation = [[XYZAnimation alloc] init];
//  _animation.duration = 5.0;
//  _animation.startTime = CACurrentMediaTime();
//  _animation.completion = ^(BOOL finished) {
//    NSLog(@"finished: %d", finished);
//  };
//  _animation.animations = ^(CGFloat progress) {
//    @strongify(self);
//    CGFloat modifier = INTUEaseOutQuintic(progress);
//    self.blockView.frame = CGRectMake(20+200*modifier, 20+200*modifier, 50.0, 50.0);
//  };
//  _displayLink.paused = NO;
}

//- (void)updateFrame:(CADisplayLink *)dl
//{
////  UIImage *image = self.imageArr[_index];
////  _layer.contents = (id)image.CGImage;//更新图片
////  _index = (_index + 1) % IMAGE_COUNT;
//  _count++;
//  NSLog(@"%ld", _count);
//  if ( _animation.progress>=1.0 ) {
//    [_animation complete:YES];
//    _displayLink.paused = YES;
//  } else {
//    [_animation tick];
//  }
//}

- (IBAction)hide:(id)sender
{
//  [_sourceView.coverView hide:YES];
//  NSLog(@"%@", NSStringFromCGRect(_blockView.frame));
  [_sourceView.coverView hide:YES];
}

- (IBAction)delay:(id)sender
{
//  [_sourceView.coverView hide:YES afterDelay:3.0];
}

@end
