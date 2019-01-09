//
//  XYZHTTPError.m
//  GenericProj
//
//  Created by Kevin Wu on 9/12/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZHTTPError.h"

@implementation XYZHTTPError

+ (NSError *)unknownError
{
  return [self errorWithCode:XYZ_ERROR_CODE_HTTP_UNKNOWN reason:NSLocalizedString(@"请求出错", @"")];
}

+ (NSError *)emptyResponseError
{
  return [self errorWithCode:XYZ_ERROR_CODE_HTTP_EMPTY_RESPONSE reason:NSLocalizedString(@"请求出错", @"")];
}

+ (NSError *)invalidResponseError
{
  return [self errorWithCode:XYZ_ERROR_CODE_HTTP_INVALID_RESPONSE reason:NSLocalizedString(@"请求出错", @"")];
}

+ (NSError *)operationFailedError
{
  return [self errorWithCode:XYZ_ERROR_CODE_HTTP_OPERATION_FAILED reason:NSLocalizedString(@"请求出错", @"")];
}

+ (NSError *)errorWithCode:(NSInteger)code reason:(NSString *)reason
{
  if ( reason.length>0 ) {
    return [[NSError alloc] initWithDomain:XYZ_ERROR_DOMAIN_HTTP
                                      code:code
                                  userInfo:@{NSLocalizedFailureReasonErrorKey:reason}];
  }
  return [[NSError alloc] initWithDomain:XYZ_ERROR_DOMAIN_HTTP code:code userInfo:nil];
}

@end
