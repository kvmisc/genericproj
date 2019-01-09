//
//  XYZPaymentManager.h
//  GenericProj
//
//  Created by Haiping Wu on 2018/10/17.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "XYZPaymentError.h"

typedef void(^XYZPaymentCompletionBlock)(id result, NSError *error);

@interface XYZPaymentManager : NSObject <
    SKProductsRequestDelegate,
    SKPaymentTransactionObserver
>

@property (nonatomic, readonly) BOOL working;

+ (id)sharedObject;

// 返回值表示购买流程是否启动成功
- (BOOL)purchase:(NSString *)productId forUser:(NSString *)uid completion:(XYZPaymentCompletionBlock)completion;

// 恢复已经购买的产品，一般将此方法绑定到某按钮上
// 如果有多个产品被恢复，completion 会被调用多次
- (void)restore:(XYZPaymentCompletionBlock)completion;

@end
