//
//  XYZMessageCenter.h
//  GenericProj
//
//  Created by Kevin Wu on 1/10/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XYZProgressHUD.h"
#import "XYZHUDView.h"

@interface XYZMC : NSObject

// 显示系统消息窗口
+ (void)SYS:(NSString *)message;
+ (void)SYS:(NSString *)title message:(NSString *)message;


// 显示 HUD 窗口，仅仅包含 UIActivityIndicatorView
+ (XYZProgressHUD *)ATV:(UIView *)inView;
+ (XYZProgressHUD *)ATV:(UIView *)inView complete:(XYZProgressHUDHandler)complete;
+ (XYZProgressHUD *)ATV:(UIView *)inView viewport:(UIView *)viewport complete:(XYZProgressHUDHandler)complete;

// 显示 HUD 窗口，用于表示事务进行中，不可取消，事务完成后调用消失方法
+ (XYZProgressHUD *)TXT:(UIView *)inView text:(NSString *)text;
+ (XYZProgressHUD *)TXT:(UIView *)inView text:(NSString *)text complete:(XYZProgressHUDHandler)complete;
+ (XYZProgressHUD *)TXT:(UIView *)inView text:(NSString *)text viewport:(UIView *)viewport complete:(XYZProgressHUDHandler)complete;

// 显示 HUD 窗口，用于表示事务进行中，可以取消，事务完成后调用消失方法
+ (XYZProgressHUD *)CNL:(UIView *)inView text:(NSString *)text cancel:(XYZProgressHUDHandler)cancel;
+ (XYZProgressHUD *)CNL:(UIView *)inView text:(NSString *)text cancel:(XYZProgressHUDHandler)cancel complete:(XYZProgressHUDHandler)complete;
+ (XYZProgressHUD *)CNL:(UIView *)inView text:(NSString *)text cancel:(XYZProgressHUDHandler)cancel viewport:(UIView *)viewport complete:(XYZProgressHUDHandler)complete;

// 显示 HUD 窗口，用于提示信息，几秒后自动隐藏
+ (XYZProgressHUD *)INF:(UIView *)inView info:(NSString *)info;
+ (XYZProgressHUD *)INF:(UIView *)inView info:(NSString *)info complete:(XYZProgressHUDHandler)complete;
+ (XYZProgressHUD *)INF:(UIView *)inView info:(NSString *)info viewport:(UIView *)viewport complete:(XYZProgressHUDHandler)complete;

// 隐藏 HUD 窗口
+ (void)HideHUD:(UIView *)inView;
+ (void)HideHUD:(UIView *)inView delay:(NSTimeInterval)delay;
+ (XYZCoverView *)doInView:(UIView *)inView
                  activity:(BOOL)activity
                      text:(NSString *)text
                    cancel:(XYZProgressHUDHandler)cancel
                  viewport:(UIView *)viewport
                  complete:(XYZProgressHUDHandler)complete;
// 获取视图内的 HUD 窗口
+ (XYZProgressHUD *)HUDInView:(UIView *)inView;

@end
