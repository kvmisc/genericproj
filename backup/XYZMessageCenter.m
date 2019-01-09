//
//  XYZMessageCenter.m
//  GenericProj
//
//  Created by Kevin Wu on 1/10/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZMessageCenter.h"

@implementation XYZMC

// 显示系统消息窗口
+ (void)SYS:(NSString *)message
{
  [self SYS:nil message:message];
}
+ (void)SYS:(NSString *)title message:(NSString *)message
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
  if ( [UIAlertController class] ) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];

    UIViewController *top = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while ( top.presentedViewController ) { top = top.presentedViewController; }

    [top presentViewController:alertController animated:YES completion:NULL];
  } else
#endif
  {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
  }
}


// 显示 HUD 窗口，仅仅包含 UIActivityIndicatorView
+ (XYZProgressHUD *)ATV:(UIView *)inView
{ return [self ATV:inView viewport:nil complete:NULL]; }
+ (XYZProgressHUD *)ATV:(UIView *)inView complete:(XYZProgressHUDHandler)complete
{ return [self ATV:inView viewport:nil complete:complete]; }
+ (XYZProgressHUD *)ATV:(UIView *)inView viewport:(UIView *)viewport complete:(XYZProgressHUDHandler)complete
{
  return [self presentHUDInView:inView activity:YES text:nil cancel:NULL viewport:viewport complete:complete];
}

// 显示 HUD 窗口，用于表示事务进行中，不可取消，事务完成后自动消失
+ (XYZProgressHUD *)TXT:(UIView *)inView text:(NSString *)text
{ return [self TXT:inView text:text viewport:nil complete:NULL]; }
+ (XYZProgressHUD *)TXT:(UIView *)inView text:(NSString *)text complete:(XYZProgressHUDHandler)complete
{ return [self TXT:inView text:text viewport:nil complete:complete]; }
+ (XYZProgressHUD *)TXT:(UIView *)inView text:(NSString *)text viewport:(UIView *)viewport complete:(XYZProgressHUDHandler)complete
{
  return [self presentHUDInView:inView activity:YES text:text cancel:NULL viewport:viewport complete:complete];
}

// 显示 HUD 窗口，用于表示事务进行中，可以取消，事务完成后自动消失
+ (XYZProgressHUD *)CNL:(UIView *)inView text:(NSString *)text cancel:(XYZProgressHUDHandler)cancel
{ return [self CNL:inView text:text cancel:cancel viewport:nil complete:NULL]; }
+ (XYZProgressHUD *)CNL:(UIView *)inView text:(NSString *)text cancel:(XYZProgressHUDHandler)cancel complete:(XYZProgressHUDHandler)complete
{ return [self CNL:inView text:text cancel:cancel viewport:nil complete:complete]; }
+ (XYZProgressHUD *)CNL:(UIView *)inView text:(NSString *)text cancel:(XYZProgressHUDHandler)cancel viewport:(UIView *)viewport complete:(XYZProgressHUDHandler)complete
{
  return [self presentHUDInView:inView activity:YES text:text cancel:cancel viewport:viewport complete:complete];
}

// 显示 HUD 窗口，用于提示信息，几秒后自动隐藏
+ (XYZProgressHUD *)INF:(UIView *)inView info:(NSString *)info
{ return [self INF:inView info:info viewport:nil complete:NULL]; }
+ (XYZProgressHUD *)INF:(UIView *)inView info:(NSString *)info complete:(XYZProgressHUDHandler)complete
{ return [self INF:inView info:info viewport:nil complete:complete]; }
+ (XYZProgressHUD *)INF:(UIView *)inView info:(NSString *)info viewport:(UIView *)viewport complete:(XYZProgressHUDHandler)complete
{
  XYZProgressHUD *hud = [self presentHUDInView:inView activity:NO text:info cancel:NULL viewport:viewport complete:complete];
  [hud hide:YES afterDelay:3.0];
  return hud;
}

+ (XYZCoverView *)doInView:(UIView *)inView
                    activity:(BOOL)activity
                        text:(NSString *)text
                      cancel:(XYZProgressHUDHandler)cancel
                    viewport:(UIView *)viewport
                    complete:(XYZProgressHUDHandler)complete
{
  if ( !inView ) {
    // 载体视图为空，没地方显示，不行
    return nil;
  }

  XYZCoverView *coverView = [self doHUDInView:inView];
  XYZHUDView *hud = nil;
  if ( coverView ) {
    [coverView prepareForPresent];
    hud = (XYZHUDView *)(coverView.contentView);
  } else {
    hud = [[XYZHUDView alloc] init];
    coverView = [hud prepareForView:inView style:kXYZCoverViewStyleAlert viewport:viewport];
  }

  [hud configWithActivity:activity text:text cancel:cancel];

  coverView.completion = complete;

  [coverView show:YES];

  return coverView;
}

+ (XYZProgressHUD *)presentHUDInView:(UIView *)inView
                            activity:(BOOL)activity
                                text:(NSString *)text
                              cancel:(XYZProgressHUDHandler)cancel
                            viewport:(UIView *)viewport
                            complete:(XYZProgressHUDHandler)complete
{
  if ( !inView ) {
    // 载体视图为空，没地方显示，不行
    return nil;
  }

  XYZProgressHUD *hud = [self HUDInView:inView];
  //XYZLogDebug(@"hud", @"%@", hud);
  if ( hud ) {
    // 找到 hud，马上取消它内部可能安排的延迟消失请求
    [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    if ( hud.hiding ) {
      hud.completeHandler = NULL;
      // 载体视图中已经存在 hud，并且正在被隐藏，直接将它移除
      [hud removeFromSuperview];
      // 创建新的 hud
      hud = [[XYZProgressHUD alloc] init];
      hud.alpha = 0.0;
      [inView addSubview:hud];
    }
  } else {
    hud = [[XYZProgressHUD alloc] init];
    hud.alpha = 0.0;
    [inView addSubview:hud];
  }

  if ( activity ) {
    // Activity, Text, Cancellation
    if ( cancel ) {
      [hud.contentView configForMode:XYZProgressHUDContentModeCancellation];
    } else {
      if ( TK_S_NONEMPTY(text) ) {
        [hud.contentView configForMode:XYZProgressHUDContentModeText];
      } else {
        [hud.contentView configForMode:XYZProgressHUDContentModeActivity];
      }
    }
  } else {
    // Info
    [hud.contentView configForMode:XYZProgressHUDContentModeInfo];
  }


  hud.contentView.textLabel.text = text;

  hud.cancelHandler = cancel;

  hud.completeHandler = complete;

  
  [hud updateViewport:viewport];

  [hud updateEvent];


  [hud show:YES];

  return hud;
}

+ (void)HideHUD:(UIView *)inView
{
  [self HideHUD:inView delay:0.0];
}
+ (void)HideHUD:(UIView *)inView delay:(NSTimeInterval)delay
{
  XYZProgressHUD *hud = [self HUDInView:inView];
  [hud hide:YES afterDelay:delay];
}

+ (XYZProgressHUD *)HUDInView:(UIView *)inView
{
  if ( inView ) {
    for ( UIView *subview in inView.subviews ) {
      if ( [subview isKindOfClass:[XYZProgressHUD class]] ) {
        return (XYZProgressHUD *)subview;
      }
    }
  }
  return nil;
}

+ (XYZCoverView *)doHUDInView:(UIView *)inView
{
  if ( inView ) {
    for ( UIView *sub1 in inView.subviews ) {
      if ( [sub1 isKindOfClass:[XYZCoverView class]] ) {

        for ( UIView *sub2 in sub1.subviews ) {
          if ( [sub2 isKindOfClass:[XYZHUDView class]] ) {
            return (XYZCoverView *)sub1;
          }
        }

      }
    }
  }
  return nil;
}

@end
