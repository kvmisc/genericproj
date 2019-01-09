//
//  TKCache.h
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKCache : NSObject

///-------------------------------
/// Initiation
///-------------------------------

- (id)initWithPath:(NSString *)path;


+ (TKCache *)sharedObject;

+ (void)saveObject:(TKCache *)object;


///-------------------------------
/// Accessing caches
///-------------------------------

- (id)objectForKey:(NSString *)key;

- (void)setObject:(id)object forKey:(NSString *)key withTimeout:(NSTimeInterval)timeout;

- (void)removeCacheForKey:(NSString *)key;

- (BOOL)hasCacheForKey:(NSString *)key;


///-------------------------------
/// Reorganize cache
///-------------------------------

- (void)clearAll;

- (void)cleanUp;


///-------------------------------
/// Miscellaneous
///-------------------------------

- (NSString *)pathForKey:(NSString *)key;

- (void)prepareForDeallocate;

@end



@interface TKCacheItem : NSObject<NSCoding>

///-------------------------------
/// Properties
///-------------------------------

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSDate *expiry;

@property (nonatomic, assign) NSUInteger size;

@property (nonatomic, strong) id object;


///-------------------------------
/// Validity
///-------------------------------

- (BOOL)expired;

@end
