//
//  SCWechatProxy.m
//  SmartCombat
//
//  Created by Kevin Wu on 04/12/2017.
//  Copyright © 2017 Kevin Wu. All rights reserved.
//

#import "SCWechatProxy.h"

@interface SCWechatProxy ()
// 当前操作的回调，开始新操作后此值会被覆盖
@property (nonatomic, copy) SCWechatProxyCompletionHandler completion;
@end


@implementation SCWechatProxy

static SCWechatProxy *WechatProxy = nil;

+ (SCWechatProxy *)sharedObject
{
  if ( !WechatProxy ) {
    WechatProxy = [[self alloc] init];
  }
  return WechatProxy;
}

+ (void)setSharedObject:(SCWechatProxy *)object
{
  WechatProxy = object;
}


- (void)setup
{
  [WXApi registerApp:@"wx006e361d6d59ce44"];
}



- (void)send:(id)content scene:(NSInteger)scene completion:(SCWechatProxyCompletionHandler)completion
{
  if ( content ) {

    if ( _completion ) {
      _completion(NO, nil);
    }
    self.completion = completion;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];

    if ( [content isKindOfClass:[NSString class]] ) {
      req.text = content;
      req.bText = YES;
    } else if ( [content isKindOfClass:[WXMediaMessage class]] ) {
      req.message = content;
      req.bText = NO;
    }

    req.scene = (int)scene;

    [WXApi sendReq:req];

  }
}


- (void)onReq:(BaseReq *)req
{
}

- (void)onResp:(BaseResp *)resp
{
  if ( [resp isKindOfClass:[SendMessageToWXResp class]] ) {
    SCLogDebug(@"Wechat", @"Send Message Response: %d %@", resp.errCode, resp.errStr);
    if ( _completion ) {
      _completion(YES, resp);
      _completion = NULL;
    }
  }
}

@end
