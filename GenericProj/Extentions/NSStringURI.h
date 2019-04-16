//
//  NSStringURI.h
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/15.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URI)

// Input:  http://api.xxx.com/timeline
//         @{@"aa":@"1&1", @"b&b":@"", @"cc":@"33"}
// Result: http://api.xxx.com/timeline?aa=1%261&b%26b=&cc=33
// 字符串可以是: "http://xxx"、"asdf" 或 ""
// 参数应该是未编码状态
// 字符串为空时，返回值前面会有问号；字符串中已经包含的 query 会替换为新的
- (NSString *)tk_stringByAddingQueryDictionary:(NSDictionary *)map;
// Input:  http://api.xxx.com/timeline
//         aa=1%261&b%26b=&cc=33
// Result: http://api.xxx.com/timeline?aa=1%261&b%26b=&cc=33
// 字符串可以是: "http://xxx"、"asdf" 或 ""
// 参数必须是已编码状态
// 字符串为空时，返回值前面会有问号；字符串中已经包含的 query 会替换为新的
- (NSString *)tk_stringByAddingQueryString:(NSString *)str;


// Input:  http://api.xxx.com/timeline?aa=1%261&b%26b=&cc=33#chaper_1
// Result: @{@"aa":@"1&1", @"b&b":@"", @"cc":@"33"}
// 字符串可以是 "http://xxx?query"、"asdf?query#fragment"、"?query" 或 "query"
// 返回值是已解码状态
- (NSDictionary *)tk_queryDictionary;
// Input:  http://api.xxx.com/timeline?aa=1%261&b%26b=&cc=33#chaper_1
// Result:                             aa=1%261&b%26b=&cc=33
// 字符串可以是 "http://xxx?query"、"asdf?query#fragment"、"?query" 或 "query"
// 返回值是未解码状态
- (NSString *)tk_queryString;


- (NSString *)tk_URLEncodedString;
- (NSString *)tk_URLDecodedString;

#ifdef DEBUG
+ (void)tk_testAddingQueryDictionary;
+ (void)tk_testAddingQueryString;
+ (void)tk_testQueryDictionary;
+ (void)tk_testQueryString;
#endif
@end


@interface NSMutableString (URI)
- (void)tk_addQueryDictionary:(NSDictionary *)map;
- (void)tk_addQueryString:(NSString *)str;
@end


@interface NSDictionary (URI)
// Input:  @{@"":@"", @"":@"11", @"aa":@"", @"bb":@"22", @"c+c":@"3&3", @"dd":@"4👴🏻👮🏽4"}
// Result: aa=&bb=22&c%2Bc=3%263&dd=4%F0%9F%91%B4%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD4
// 返回值为已编码状态
- (NSString *)tk_queryString;
#ifdef DEBUG
+ (void)tk_testQueryString;
#endif
@end
