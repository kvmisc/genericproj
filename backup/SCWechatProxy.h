//
//  SCWechatProxy.h
//  SmartCombat
//
//  Created by Kevin Wu on 04/12/2017.
//  Copyright © 2017 Kevin Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WechatOpenSDK/WXApi.h>
#import <WechatOpenSDK/WXApiObject.h>
#import <WechatOpenSDK/WechatAuthSDK.h>

////////////////////////////////////////////////////////////////////////////////
//
//  pod 'WechatOpenSDK'
//
////////////////////////////////////////////////////////////////////////////////

typedef void(^SCWechatProxyCompletionHandler)(BOOL completed, id object);

@interface SCWechatProxy : NSObject <
    WXApiDelegate
>

+ (SCWechatProxy *)sharedObject;

+ (void)setSharedObject:(SCWechatProxy *)object;


- (void)setup;


- (void)send:(id)content scene:(NSInteger)scene completion:(SCWechatProxyCompletionHandler)completion;

@end
