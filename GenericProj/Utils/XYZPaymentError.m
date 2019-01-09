//
//  XYZPaymentError.m
//  GenericProj
//
//  Created by Haiping Wu on 2018/10/17.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "XYZPaymentError.h"

@implementation XYZPaymentError

+ (NSError *)invalidProductError
{
  return [self errorWithCode:XYZ_ERROR_CODE_PAYMENT_INVALID_PRODUCT
                      reason:NSLocalizedString(@"无效的产品", @"")];
}

+ (NSError *)parentalControlError
{
  return [self errorWithCode:XYZ_ERROR_CODE_PAYMENT_PARENTAL_CONTROL
                      reason:NSLocalizedString(@"无法购买（多为家长控制）", @"")];
}

+ (NSError *)productEmptyError
{
  return [self errorWithCode:XYZ_ERROR_CODE_PAYMENT_PRODUCT_EMPTY
                      reason:NSLocalizedString(@"购买的产品不存在", @"")];
}

+ (NSError *)requestFailedError
{
  return [self errorWithCode:XYZ_ERROR_CODE_PAYMENT_REQUEST_FAILED
                      reason:NSLocalizedString(@"不能完成请求", @"")];
}

+ (NSError *)userCancelledError
{
  return [self errorWithCode:XYZ_ERROR_CODE_PAYMENT_USER_CANCELLED
                      reason:NSLocalizedString(@"用户取消交易", @"")];
}

+ (NSError *)otherFailureError
{
  return [self errorWithCode:XYZ_ERROR_CODE_PAYMENT_OTHER_FAILURE
                      reason:NSLocalizedString(@"其它错误", @"")];
}

+ (NSError *)errorWithCode:(NSInteger)code reason:(NSString *)reason
{
  if ( reason.length>0 ) {
    return [[NSError alloc] initWithDomain:XYZ_ERROR_DOMAIN_PAYMENT
                                      code:code
                                  userInfo:@{NSLocalizedFailureReasonErrorKey:reason}];
  }
  return [[NSError alloc] initWithDomain:XYZ_ERROR_DOMAIN_PAYMENT code:code userInfo:nil];
}

@end
