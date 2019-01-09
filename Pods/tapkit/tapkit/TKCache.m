//
//  TKCache.m
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKCache.h"
#import "TKCommon.h"

#define CACHE_SETTING @"ad68bddb-7e05-40e3-afb5-d79806d831d0"


@implementation TKCache {
  NSString *_path;

  NSMutableArray *_itemAry;
  NSLock *_lock;
}

#pragma mark - Initiation

- (id)init
{
  self = [super init];
  if (self) {
    [self setup_];
  }
  return self;
}

- (id)initWithPath:(NSString *)path
{
  self = [super init];
  if ( self ) {
    _path = [path copy];
    [self setup_];
  }
  return self;
}

- (void)setup_
{
  _itemAry = [[NSMutableArray alloc] init];
  _lock = [[NSLock alloc] init];

  if ( _path.length>0 ) {
    TKCreateDirectory(_path);

    NSString *path = [self pathForKey:CACHE_SETTING];
    NSArray *itemAry = TKLoadArchivableObject(path);
    for ( TKCacheItem *item in itemAry ) {
      if ( [item expired] ) {
        TKDeleteFileOrDirectory([self pathForKey:item.key]);
      } else {
        [_itemAry addObject:item];
      }
    }
    TKSaveArchivableObject(_itemAry, path);
  }
}


static TKCache *Cache = nil;

+ (TKCache *)sharedObject
{
  return Cache;
}

+ (void)saveObject:(TKCache *)object
{
  Cache = object;
}



#pragma mark - Accessing caches

- (id)objectForKey:(NSString *)key
{
  id object = nil;
  if ( key.length>0 ) {
    [_lock lock];
    TKCacheItem *item = [self item_ByKey:key];
    if ( (item) && (![item expired]) ) {
      if ( _path.length>0 ) {
        object = [[NSData alloc] initWithContentsOfFile:[self pathForKey:item.key]];
      } else {
        object = item.object;
      }
    }
    [_lock unlock];
  }
  [self delay_CleanUp];
  return object;
}

- (void)setObject:(id)object forKey:(NSString *)key withTimeout:(NSTimeInterval)timeout
{
  if ( (key.length>0) && (timeout>0.0) ) {
    [_lock lock];

    TKCacheItem *item = [self item_ByKey:key];
    if ( !item ) {
      item = [[TKCacheItem alloc] init];
      [_itemAry addObject:item];
    }

    item.key = key;
    item.expiry = [[NSDate alloc] initWithTimeIntervalSinceNow:timeout];
    if ( _path.length>0 ) {
      item.size = [object length];
      NSString *path = [self pathForKey:key];
      if ( object ) {
        [object writeToFile:path atomically:YES];
      } else {
        TKDeleteFileOrDirectory(path);
      }
    } else {
      item.object = object;
    }

    TKSaveArchivableObject(_itemAry, [self pathForKey:CACHE_SETTING]);

    [_lock unlock];
  }
  [self delay_CleanUp];
}

- (void)removeCacheForKey:(NSString *)key
{
  if ( key.length>0 ) {
    [_lock lock];
    for ( NSUInteger i=0; i<[_itemAry count]; ++i ) {
      TKCacheItem *item = [_itemAry objectAtIndex:i];
      if ( [key isEqual:item.key] ) {
        TKDeleteFileOrDirectory([self pathForKey:item.key]);
        [_itemAry removeObjectAtIndex:i];
        break;
      }
    }
    TKSaveArchivableObject(_itemAry, [self pathForKey:CACHE_SETTING]);
    [_lock unlock];
  }
  [self delay_CleanUp];
}


- (BOOL)hasCacheForKey:(NSString *)key
{
  BOOL result = NO;
  if ( key.length>0 ) {
    [_lock lock];
    TKCacheItem *item = [self item_ByKey:key];
    result = ( (item) && (![item expired]) );
    [_lock unlock];
  }
  [self delay_CleanUp];
  return result;
}



#pragma mark - Reorganize cache

- (void)clearAll
{
  [_lock lock];
  if ( _path.length>0 ) {
    TKDeleteFileOrDirectory(_path);
    TKCreateDirectory(_path);
  }
  [_itemAry removeAllObjects];
  TKSaveArchivableObject(_itemAry, [self pathForKey:CACHE_SETTING]);
  [_lock unlock];
}

- (void)cleanUp
{
  [self do_CleanUp:nil];
}



#pragma mark - Miscellaneous

- (NSString *)pathForKey:(NSString *)key
{
  return [_path stringByAppendingPathComponent:key];
}

- (void)prepareForDeallocate
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(do_CleanUp:) object:nil];
}



#pragma mark - Private methods

- (TKCacheItem *)item_ByKey:(NSString *)key
{
  for ( TKCacheItem *item in _itemAry ) {
    if ( [key isEqual:item.key] ) {
      return item;
    }
  }
  return nil;
}

- (void)delay_CleanUp
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(do_CleanUp:) object:nil];
  [self performSelector:@selector(do_CleanUp:) withObject:nil afterDelay:1.0];
}

- (void)do_CleanUp:(id)object
{
  [_lock lock];
  for ( NSUInteger i=0; i<[_itemAry count]; /**/ ) {
    TKCacheItem *item = [_itemAry objectAtIndex:i];
    if ( [item expired] ) {
      TKDeleteFileOrDirectory([self pathForKey:item.key]);
      [_itemAry removeObjectAtIndex:i];
    } else {
      ++i;
    }
  }
  TKSaveArchivableObject(_itemAry, [self pathForKey:CACHE_SETTING]);
  [_lock unlock];
}

@end



@implementation TKCacheItem

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if ( self ) {
    _key = [decoder decodeObjectForKey:@"kKey"];
    _expiry = [decoder decodeObjectForKey:@"kExpiry"];

    _size = [decoder decodeIntegerForKey:@"kSize"];

    //_object = [decoder decodeObjectForKey:@"kObject"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:_key forKey:@"kKey"];
  [encoder encodeObject:_expiry forKey:@"kExpiry"];

  [encoder encodeInteger:_size forKey:@"kSize"];

  //[encoder encodeObject:_object forKey:@"kObject"];
}



#pragma mark - Validity

- (BOOL)expired
{
  return ( [_expiry earlierDate:[NSDate date]]==_expiry );
}

@end
