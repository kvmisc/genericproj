//
//  XYZPaymentError.h
//  GenericProj
//
//  Created by Haiping Wu on 2018/10/17.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XYZ_ERROR_DOMAIN_PAYMENT @"com.firefly.ios.payment"

#define XYZ_ERROR_CODE_PAYMENT_UNKNOWN 2000
#define XYZ_ERROR_CODE_PAYMENT_INVALID_PRODUCT 2001
#define XYZ_ERROR_CODE_PAYMENT_PARENTAL_CONTROL 2002
#define XYZ_ERROR_CODE_PAYMENT_PRODUCT_EMPTY 2003
#define XYZ_ERROR_CODE_PAYMENT_REQUEST_FAILED 2004
#define XYZ_ERROR_CODE_PAYMENT_USER_CANCELLED 2005
#define XYZ_ERROR_CODE_PAYMENT_OTHER_FAILURE 2006

@interface XYZPaymentError : NSObject

+ (NSError *)invalidProductError;

+ (NSError *)parentalControlError;

+ (NSError *)productEmptyError;

+ (NSError *)requestFailedError;

+ (NSError *)userCancelledError;

+ (NSError *)otherFailureError;

@end
