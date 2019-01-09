//
//  XYZMessageCenter.h
//  GenericProj
//
//  Created by Kevin Wu on 14/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XYZHUDView.h"

@interface XYZMC : NSObject

// 如果用这些方法显示的位置不适合，可以取得返回的 XYZCoverView，并对其中的 contentView 重新布局
// 如果 inView 传空，HUD 会显示到顶端窗口中


// 显示 HUD 窗口，仅仅包含 AIV，用于表示事务进行中，不可取消，事务完成后程序员自己调用消失方法
+ (XYZCoverView *)ATV:(UIView *)inView;
+ (XYZCoverView *)ATV:(UIView *)inView complete:(void (^)(void))complete;
+ (XYZCoverView *)ATV:(UIView *)inView viewport:(UIView *)viewport complete:(void (^)(void))complete;
// 显示 HUD 窗口，用于表示事务进行中，不可取消，事务完成后程序员自己调用消失方法
+ (XYZCoverView *)TXT:(UIView *)inView text:(NSString *)text;
+ (XYZCoverView *)TXT:(UIView *)inView text:(NSString *)text complete:(void (^)(void))complete;
+ (XYZCoverView *)TXT:(UIView *)inView text:(NSString *)text viewport:(UIView *)viewport complete:(void (^)(void))complete;
// 显示 HUD 窗口，用于表示事务进行中，可以取消，事务完成后程序员自己调用消失方法
+ (XYZCoverView *)CCL:(UIView *)inView text:(NSString *)text cancel:(void (^)(void))cancel;
+ (XYZCoverView *)CCL:(UIView *)inView text:(NSString *)text cancel:(void (^)(void))cancel complete:(void (^)(void))complete;
+ (XYZCoverView *)CCL:(UIView *)inView text:(NSString *)text cancel:(void (^)(void))cancel viewport:(UIView *)viewport complete:(void (^)(void))complete;
// 显示 HUD 窗口，用于提示信息，几秒后自动隐藏
+ (XYZCoverView *)INF:(UIView *)inView info:(NSString *)info;
+ (XYZCoverView *)INF:(UIView *)inView info:(NSString *)info complete:(void (^)(void))complete;
+ (XYZCoverView *)INF:(UIView *)inView info:(NSString *)info viewport:(UIView *)viewport complete:(void (^)(void))complete;

// 隐藏 HUD 窗口
+ (void)hideHUD:(UIView *)inView;
+ (void)hideHUD:(UIView *)inView delay:(NSTimeInterval)delay;
+ (void)hideHUD:(UIView *)inView animated:(BOOL)animated;
+ (void)hideHUD:(UIView *)inView animated:(BOOL)animated delay:(NSTimeInterval)delay;

// 获取视图内的 HUD 窗口
+ (XYZCoverView *)HUDInView:(UIView *)inView;

@end
