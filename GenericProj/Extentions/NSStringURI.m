//
//  NSStringURI.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/15.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "NSStringURI.h"

@implementation NSString (URI)

- (NSString *)tk_stringByAddingQueryDictionary:(NSDictionary *)map
{
  return [self tk_stringByAddingQueryString:[map tk_queryString]];
}

- (NSString *)tk_stringByAddingQueryString:(NSString *)str
{
  if ( str.length<=0 ) { return self; }

  NSURLComponents *components = [[NSURLComponents alloc] initWithString:self];
  components.percentEncodedQuery = str;
  return components.string;
}


- (NSDictionary *)tk_queryDictionary
{
  if ( self.length<=0 ) { return nil; }

  NSMutableDictionary *queryMap = [[NSMutableDictionary alloc] init];

  NSString *string = [self tk_queryString];
  NSArray *pairAry = [string componentsSeparatedByString:@"&"];
  for ( NSString *pair in pairAry ) {
    NSArray *ary = [pair componentsSeparatedByString:@"="];
    NSString *key = [ary tk_objectOrNilAtIndex:0];
    NSString *value = [ary tk_objectOrNilAtIndex:1];
    if ( (key.length>0) && (value) ) {
      // key 必须非空字符串
      // value 必须有值，可以为空字符串
      [queryMap setObject:[value tk_URLDecodedString]
                   forKey:[key tk_URLDecodedString]];
    }
  }
  if ( queryMap.count>0 ) {
    return queryMap;
  }
  return nil;
}

- (NSString *)tk_queryString
{
  if ( self.length<=0 ) { return nil; }

  NSString *string = self;
  if ( ![self containsString:@"?"] ) {
    string = [NSString stringWithFormat:@"?%@", self];
  }

  NSURLComponents *components = [[NSURLComponents alloc] initWithString:string];
  return components.percentEncodedQuery;
}


- (NSString *)tk_URLEncodedString
{
  static NSCharacterSet *allowedCharacterSet = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    //allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"-_.~/?0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
  });
  return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
}

- (NSString *)tk_URLDecodedString
{
  return [self stringByRemovingPercentEncoding];
}

#ifdef DEBUG
+ (void)tk_TestAddingQueryDictionary
{
}
+ (void)tk_TestAddingQueryString
{
  NSLog(@"Begin Test Adding Query String ========================================");
  NSArray *urlAry = @[
                      @"http://api.xxx.com/timeline",
                      @"asdf",
                      @"",
                      @"http://api.xxx.com/timeline?xx=99&yy=qwerty#chapter_1",
                      @"http://api.xxx.com/timeline#chapter_1"
                      ];
  for ( NSInteger i=0; i<[urlAry count]; ++i ) {
    NSLog(@"%@", [urlAry[i] tk_stringByAddingQueryString:@"aa=1%261&b%26b=&cc=33"]);
  }
  NSLog(@"End Test Adding Query String ==========================================");
}
+ (void)tk_TestQueryDictionary
{
  NSLog(@"Begin Test Query Dictionary ========================================");
  NSArray *urlAry = @[
                      @"http://api.xxx.com/timeline?aa=1%261&b%26b=&cc=33#chaper_1",
//                      @"http://api.xxx.com/timeline?aa=1%261&b%26b=&cc=33#",
//                      @"http://api.xxx.com/timeline?aa=1%261&b%26b=&cc=33",
//                      @"asdf?aa=1%261&b%26b=&cc=33#chapter_1",
//                      @"asdf?aa=1%261&b%26b=&cc=33#",
//                      @"asdf?aa=1%261&b%26b=&cc=33",
//                      @"?aa=1%261&b%26b=&cc=33",
//                      @"aa=1%261&b%26b=&cc=33"
                      ];
  for ( NSInteger i=0; i<[urlAry count]; ++i ) {
    NSLog(@"%@", [urlAry[i] tk_queryDictionary]);
  }
  NSLog(@"End Test Query Dictionary ==========================================");
}
+ (void)tk_TestQueryString
{
  NSLog(@"Begin Test Query String ========================================");
  NSArray *urlAry = @[
                      @"http://api.xxx.com/timeline?aa=1%261&b%26b=&cc=33#chaper_1",
                      @"http://api.xxx.com/timeline?aa=1%261&b%26b=&cc=33#",
                      @"http://api.xxx.com/timeline?aa=1%261&b%26b=&cc=33",
                      @"asdf?aa=1%261&b%26b=&cc=33#chapter_1",
                      @"asdf?aa=1%261&b%26b=&cc=33#",
                      @"asdf?aa=1%261&b%26b=&cc=33",
                      @"?aa=1%261&b%26b=&cc=33",
                      @"aa=1%261&b%26b=&cc=33"
                      ];
  for ( NSInteger i=0; i<[urlAry count]; ++i ) {
    NSLog(@"%@", [urlAry[i] tk_queryString]);
  }
  NSLog(@"End Test Query String ==========================================");
}

#endif

@end

@implementation NSMutableString (Query)

- (void)tk_addQueryDictionary:(NSDictionary *)map
{
  [self setString:[self tk_stringByAddingQueryDictionary:map]];
}

- (void)tk_addQueryString:(NSString *)str
{
  [self setString:[self tk_stringByAddingQueryString:str]];
}

@end

@implementation NSDictionary (URI)

- (NSString *)tk_queryString
{
  if ( self.count<=0 ) { return nil; }

  NSMutableArray *pairAry = [[NSMutableArray alloc] init];
  [self enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    if ( key.length>0 ) {
      if ( obj.length>0 ) {
        NSString *pair = [NSString stringWithFormat:@"%@=%@", [key tk_URLEncodedString], [obj tk_URLEncodedString]];
        [pairAry addObject:pair];
      } else {
        NSString *pair = [NSString stringWithFormat:@"%@=", [key tk_URLEncodedString]];
        [pairAry addObject:pair];
      }
    }
  }];
  NSString *queryString = [pairAry componentsJoinedByString:@"&"];
  if ( queryString.length>0 ) {
    return queryString;
  }
  return nil;
}

#ifdef DEBUG
+ (void)tk_TestQueryString
{
  NSLog(@"Begin Test Query String ========================================");
  NSDictionary *map = @{
                        @"":@"",
                        @"":@"11",
                        @"aa":@"",
                        @"bb":@"22",
                        @"c+c":@"3&3",
                        @"dd":@"4👴🏻👮🏽4"
                        };
  NSLog(@"%@", [map tk_queryString]);
  NSLog(@"Begin Test Query String ========================================");
}
#endif

@end
