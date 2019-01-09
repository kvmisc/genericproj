//
//  XYZCancelableBlock.h
//  GenericProj
//
//  Created by Kevin Wu on 8/11/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*******************************************************************************

 Usage:

 // 启动延迟任务
 _block = xyz_dispatch_after_delay(5.0, ^{
   NSLog(@"do something");
 });
 
 // 取消之前的延迟任务
 xyz_cancel_block(_block);

 ******************************************************************************/

// 定义闭包类型
typedef void(^xyz_cancelable_block_t)(BOOL cancel);


// 延迟调用闭包
xyz_cancelable_block_t xyz_dispatch_after_delay(CGFloat delay, dispatch_block_t block);

// 取消之前延迟调用的闭包
void xyz_cancel_block(xyz_cancelable_block_t block);
