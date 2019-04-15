//
//  NSStringQuery.h
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/15.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Query)
- (NSString *)tk_stringByAppendingQueryDictionary:(NSDictionary *)dictionary;
- (NSString *)tk_queryString;
- (NSDictionary *)tk_queryDictionary;
@end

@interface NSMutableString (Query)
- (void)appendQueryDictionary:(NSDictionary *)dictionary;
@end

@interface NSDictionary (Query)
- (NSString *)tk_queryString;
@end
