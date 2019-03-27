//
//  XYZPaymentError.m
//  GenericProj
//
//  Created by Haiping Wu on 2018/10/17.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "XYZPaymentError.h"

// NSTimer 依赖于 Runloop，如果 Runloop 任务过于繁重，会导致 NSTimer 不准时。
// GCD 定时器不依赖于 Runloop，会比 NSTimer 更加准时。

@implementation GCDTimerSample

- (void)setUpTimer
{
  // 获取主队列
  dispatch_queue_t queue = dispatch_get_main_queue();
  // 创建定时器, 在主线程中调用
  dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
  // 2秒后执行
  NSTimeInterval start = 2.0;
  // 执行间隔1秒
  NSTimeInterval interval = 1.0;
  // 设置定时器
  dispatch_source_set_timer(timer,
                            dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                            interval * NSEC_PER_SEC,
                            0);
  // 设置回调
  __weak typeof(self) weakSelf = self;
  dispatch_source_set_event_handler(timer, ^{
    [weakSelf timerTest];
  });
  // 启动定时器
  dispatch_resume(timer);
  self.timer = timer;
}

- (void)timerTest
{
  NSLog(@"%s", __func__);
}

- (void)dealloc
{
  NSLog(@"%s", __func__);
}

@end
