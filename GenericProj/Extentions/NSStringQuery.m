//
//  NSStringQuery.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/15.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "NSStringQuery.h"

@implementation NSString (Query)

- (NSString *)tk_stringByAppendingQueryDictionary:(NSDictionary *)dictionary
{
  NSString *url = nil;
  NSString *string = AFQueryStringFromParameters(dictionary);
  if ( string.length>0 ) {
    if ( [self rangeOfString:@"?"].location!=NSNotFound ) {
      url = [self stringByAppendingFormat:@"&%@", string];
    } else {
      url = [self stringByAppendingFormat:@"?%@", string];
    }
  }
  if ( url.length>0 ) {
    return url;
  }
  return self;
}

- (NSDictionary *)tk_queryDictionary
{
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  NSArray *pairAry = [self componentsSeparatedByString:@"&"];
  for ( NSString *pair in pairAry ) {
    NSArray *componentAry = [pair componentsSeparatedByString:@"="];
    NSString *key = [componentAry tk_objectOrNilAtIndex:0];
    NSString *value = [componentAry tk_objectOrNilAtIndex:1];
    if ( key.length>0 ) {
      if ( value ) {
        if ( value.length>0 ) {
          [dictionary setObject:[value stringByRemovingPercentEncoding]
                         forKey:[key stringByRemovingPercentEncoding]];
        } else {
          [dictionary setObject:@""
                         forKey:[key stringByRemovingPercentEncoding]];
        }
      } else {
        [dictionary setObject:[NSNull null]
                       forKey:[key stringByRemovingPercentEncoding]];
      }
    }
  }
  return dictionary;
}

@end

@implementation NSMutableString (Query)

- (void)appendQueryDictionary:(NSDictionary *)dictionary
{
  NSString *string = AFQueryStringFromParameters(dictionary);
  if ( string.length>0 ) {
    if ( [self rangeOfString:@"?"].location!=NSNotFound ) {
      [self appendFormat:@"&%@", string];
    } else {
      [self appendFormat:@"?%@", string];
    }
  }
}

@end

@implementation NSDictionary (Query)

- (NSString *)tk_queryString
{
  return AFQueryStringFromParameters(self);
}

@end
