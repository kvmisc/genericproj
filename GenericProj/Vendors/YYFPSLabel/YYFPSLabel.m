//
//  YYFPSLabel.m
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYFPSLabel.h"
#import "YYWeakProxy.h"

@implementation YYFPSLabel {
  CADisplayLink *_link;
  NSUInteger _count;
  NSTimeInterval _lastTime;
}

- (id)init
{
  self = [super initWithFrame:CGRectMake(0.0, XYZ_SCREEN_HET-10.0, 32.0, 10.0)];
  if (self) {

    self.font = [UIFont systemFontOfSize:8.0];
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor blackColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;


    // 如果直接用 self 或者 weakSelf，都不能解决循环引用问题

    // 将 timer 的 target 从 self ，变成了中间人 NSProxy
    // timer 调用 target 的 selector 时，会被 NSProxy 内部转调用 self 的 selector
    _link = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
    //__weak typeof(self) weakSelf = self;
    //_link = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

  }
  return self;
}

- (void)dealloc
{
  [_link invalidate];
  XYZLog(@"timer release");
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return CGSizeMake(32.0, 10.0);
}

- (void)tick:(CADisplayLink *)link
{
  if (_lastTime == 0) {
    _lastTime = link.timestamp;
    return;
  }

  _count++;
  NSTimeInterval delta = link.timestamp - _lastTime;
  if (delta < 1) return;
  _lastTime = link.timestamp;
  float fps = _count / delta;
  _count = 0;

  self.text = [NSString stringWithFormat:@"FPS: %d",(int)round(fps)];
}

@end

