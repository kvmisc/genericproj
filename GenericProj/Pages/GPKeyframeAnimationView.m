//
//  GPKeyframeAnimationView.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/8.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPKeyframeAnimationView.h"

@interface GPKeyframeAnimationView ()
@property (nonatomic, strong) UIView *redView;
@end

@implementation GPKeyframeAnimationView

- (id)init
{
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor darkGrayColor];
    _redView = [[UIView alloc] init];
    _redView.backgroundColor = [UIColor redColor];
    [self addSubview:_redView];
    _redView.frame = CGRectMake(10, 10, 50, 50);
  }
  return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  @weakify(self);
  [UIView animateKeyframesWithDuration:4.0
                                 delay:0.0
                               options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                            animations:^{
                              [UIView addKeyframeWithRelativeStartTime:0.0
                                                      relativeDuration:0.25
                                                            animations:^{
                                                              @strongify(self);
                                                              //self.redView.backgroundColor = [UIColor greenColor];
                                                              //self.redView.center = CGPointMake(200, 35);
                                                              self.redView.frame = CGRectMake(200, 10, 50, 50);
                                                            }];
                              [UIView addKeyframeWithRelativeStartTime:0.25
                                                      relativeDuration:0.25
                                                            animations:^{
                                                              @strongify(self);
                                                              //self.redView.backgroundColor = [UIColor blueColor];
                                                              //self.redView.center = CGPointMake(200, 200);
                                                              self.redView.frame = CGRectMake(200, 200, 50, 50);
                                                            }];
                              [UIView addKeyframeWithRelativeStartTime:0.5
                                                      relativeDuration:0.25
                                                            animations:^{
                                                              @strongify(self);
                                                              //self.redView.backgroundColor = [UIColor blackColor];
                                                              //self.redView.center = CGPointMake(35, 200);
                                                              self.redView.frame = CGRectMake(10, 200, 50, 50);
                                                            }];
                              [UIView addKeyframeWithRelativeStartTime:0.75
                                                      relativeDuration:0.25
                                                            animations:^{
                                                              @strongify(self);
                                                              //self.redView.backgroundColor = [UIColor yellowColor];
                                                              //self.redView.center = CGPointMake(35, 35);
                                                              self.redView.frame = CGRectMake(10, 300, 50, 50);
                                                            }];
                            }
                            completion:^(BOOL finished) {
                              NSLog(@"complete: %d", finished);
                            }];

//  void (^animationBlock)(void) = ^{
//    NSArray *rainbowColors = @[[UIColor orangeColor],
//                               [UIColor yellowColor],
//                               [UIColor greenColor],
//                               [UIColor blueColor],
//                               [UIColor purpleColor],
//                               [UIColor redColor]];
//
//    NSUInteger colorCount = [rainbowColors count];
//    for(NSUInteger i=0; i<colorCount; i++) {
//      [UIView addKeyframeWithRelativeStartTime:i/(CGFloat)colorCount
//                              relativeDuration:1/(CGFloat)colorCount
//                                    animations:^{
//                                      self.redView.backgroundColor = rainbowColors[i];
//                                    }];
//    }
//  };
//
//  [UIView animateKeyframesWithDuration:4.0
//                                 delay:0.0
//                               options:0
//                            animations:animationBlock
//                            completion:^(BOOL finished) {
//                            }];

//  _redView.transform = CGAffineTransformMakeTranslation(300, 0);
//  double frameDuration = 1.0/4.0; // 4 = number of keyframes
//
//  [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:0 animations:^{
//    [UIView addKeyframeWithRelativeStartTime:0*frameDuration relativeDuration:frameDuration animations:^{
//      self.redView.transform = CGAffineTransformMakeTranslation(-10, 0);
//    }];
//    [UIView addKeyframeWithRelativeStartTime:1*frameDuration relativeDuration:frameDuration animations:^{
//      self.redView.transform = CGAffineTransformMakeTranslation(5, 0);
//    }];
//    [UIView addKeyframeWithRelativeStartTime:2*frameDuration relativeDuration:frameDuration animations:^{
//      self.redView.transform = CGAffineTransformMakeTranslation(-2, 0);
//    }];
//    [UIView addKeyframeWithRelativeStartTime:3*frameDuration relativeDuration:frameDuration animations:^{
//      self.redView.transform = CGAffineTransformMakeTranslation(0, 0);
//    }];
//  } completion:nil];
}

@end
