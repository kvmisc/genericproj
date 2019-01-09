//
//  XYZCancelableBlock.m
//  GenericProj
//
//  Created by Kevin Wu on 8/11/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import "XYZCancelableBlock.h"

xyz_cancelable_block_t xyz_dispatch_after_delay(CGFloat delay, dispatch_block_t block)
{
  // 如果任务闭包为空，直接返回，没有任务要做就不浪费时间。
  if ( !block ) {
    return nil;
  }

  __block dispatch_block_t task_block = [block copy];


  __block xyz_cancelable_block_t cancelable_block = nil;
  // 这是调用者拿到的闭包，也是下面延迟执行的闭包。
  xyz_cancelable_block_t delay_block = ^(BOOL cancel){
    // 如果调用者取消闭包，会跳过这里；
    // 如果延迟调执行闭包，会执行这里。
    if ( (!cancel) && (task_block) ) {
      dispatch_async(dispatch_get_main_queue(), task_block);
    }

    // 如果调用者取消闭包，会执行这里，清空句柄，然后后面的延迟执行检测到句柄为空，就不会做任
    // 何操作，也就达到了取消的效果；
    // 如果延迟执行闭包，会执行这里，清空句柄，及时释放内存。
    task_block = nil;
    cancelable_block = nil;
  };
  cancelable_block = [delay_block copy];


  // 延迟调用，闭包句柄不为空表示未被取消过，执行。
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if ( cancelable_block ) {
      cancelable_block(NO);
    }
  });

  // 返回闭包句柄，调用者应该保存这个句柄。
  return cancelable_block;
}

void xyz_cancel_block(xyz_cancelable_block_t block)
{
  if ( block ) {
    block(YES);
  }
}
