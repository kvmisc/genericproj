//
//  XYZGlobal.m
//  GenericProj
//
//  Created by Kevin Wu on 8/15/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import "XYZGlobal.h"

@implementation XYZGlobal

+ (UIWindow *)visibleTopmostWindow
{
  NSArray *windowAry = [[UIApplication sharedApplication] windows];
  for ( UIWindow *wnd in [windowAry reverseObjectEnumerator] ) {
    if ( !(wnd.hidden) ) {
      return wnd;
    }
  }
  return nil;
}

+ (UIViewController *)topmostViewController
{
  UIWindow *window = [XYZ_APP_DELEGATE window];
  UIViewController *front = window.rootViewController;
  while ( front.presentedViewController ) {
    front = front.presentedViewController;
  }
  return front;
}



+ (BOOL)isVersionValid:(NSString *)ver
{
  if ( ver.length<=0 ) {
    // 长度为0，版本号无效
    return NO;
  }

  NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
  for ( NSUInteger i=0; i<[ver length]; ++i ) {
    if ( ![set characterIsMember:[ver characterAtIndex:i]] ) {
      // 含有非法字符，版本号无效
      return NO;
    }
  }

  NSArray *ary = [ver componentsSeparatedByString:@"."];
  for ( NSString *com in ary ) {
    if ( com.length<=0 ) {
      // 某一段为空，版本号无效
      return NO;
    }
    if ( [com hasPrefix:@"0"] && ([com integerValue]>0) ) {
      // 某一段以0开头，值却不是0，版本号无效
      return NO;
    }
  }

  return YES;
}
+ (BOOL)isVersion:(NSString *)ver1 equalTo:(NSString *)ver2
{
  NSAssert2(([self isVersionValid:ver1]&&[self isVersionValid:ver2]), @"ver1:%@, ver2:%@", ver1, ver2);
  NSComparisonResult result = [self compareVersion:ver1 version:ver2];
  return (result==NSOrderedSame);
}
+ (BOOL)isVersion:(NSString *)ver1 lessThan:(NSString *)ver2
{
  NSAssert2(([self isVersionValid:ver1]&&[self isVersionValid:ver2]), @"ver1:%@, ver2:%@", ver1, ver2);
  NSComparisonResult result = [self compareVersion:ver1 version:ver2];
  return (result==NSOrderedAscending);
}
+ (BOOL)isVersion:(NSString *)ver1 lessOrEqual:(NSString *)ver2
{
  NSAssert2(([self isVersionValid:ver1]&&[self isVersionValid:ver2]), @"ver1:%@, ver2:%@", ver1, ver2);
  NSComparisonResult result = [self compareVersion:ver1 version:ver2];
  return ((result==NSOrderedSame) || (result==NSOrderedAscending));
}
+ (BOOL)isVersion:(NSString *)ver1 greaterThan:(NSString *)ver2
{
  NSAssert2(([self isVersionValid:ver1]&&[self isVersionValid:ver2]), @"ver1:%@, ver2:%@", ver1, ver2);
  NSComparisonResult result = [self compareVersion:ver1 version:ver2];
  return (result==NSOrderedDescending);
}
+ (BOOL)isVersion:(NSString *)ver1 greaterOrEqual:(NSString *)ver2
{
  NSAssert2(([self isVersionValid:ver1]&&[self isVersionValid:ver2]), @"ver1:%@, ver2:%@", ver1, ver2);
  NSComparisonResult result = [self compareVersion:ver1 version:ver2];
  return ((result==NSOrderedSame) || (result==NSOrderedDescending));
}
+ (NSComparisonResult)compareVersion:(NSString *)ver1 version:(NSString *)ver2
{
  NSArray *ary1 = [ver1 componentsSeparatedByString:@"."];
  NSArray *ary2 = [ver2 componentsSeparatedByString:@"."];
  NSUInteger maxCount = MAX([ary1 count], [ary2 count]);

  for ( NSUInteger i=0; i<maxCount; ++i ) {
    NSString *com1 = [ary1 tk_objectOrNilAtIndex:i];
    NSString *com2 = [ary2 tk_objectOrNilAtIndex:i];

    if ( com1.length>0 ) {
      if ( com2.length>0 ) {
        // 同时不为空
        if ( [com1 integerValue]<[com2 integerValue] ) {
          return NSOrderedAscending; // 已经有结果，升
        } else if ( [com1 integerValue]>[com2 integerValue] ) {
          return NSOrderedDescending; // 已经有结果，降
        } else {
          continue; // 相同，比较下一组
        }
      } else {
        // 第一段不空，第二段空
        return NSOrderedDescending; // 不管第一段是啥，降
      }
    } else {
      if ( com2.length>0 ) {
        // 第一段空，第二段不空
        return NSOrderedAscending; // 不管第二段是啥，升
      } else {
        // 同时为空
        continue; // 相同，比较下一组
      }
    }
  }

  return NSOrderedSame;
}



+ (CGFloat)boundFlt:(CGFloat)value left:(CGFloat)left right:(CGFloat)right
{
  if ( value<=left ) { return left; }
  if ( value>=right ) { return right; }
  return value;
}
+ (NSInteger)boundInt:(NSInteger)value left:(NSInteger)left right:(NSInteger)right
{
  if ( value<=left ) { return left; }
  if ( value>=right ) { return right; }
  return value;
}



+ (NSString *)pathGlobal:(NSString *)relativePath
{
  return TKPathForDocumentResource(relativePath);
}
+ (NSString *)pathGlobal:(NSString *)service file:(NSString *)file
{
  NSString *path = TKPathForDocumentResource(nil);
  if ( service.length>0 ) {
    path = [path stringByAppendingPathComponent:service];
    return [path stringByAppendingPathComponent:file];
  }
  return path;
}
+ (NSString *)pathUser:(NSString *)uid relativePath:(NSString *)relativePath
{
  NSString *path = TKPathForDocumentResource(@"Users");
  if ( uid.length>0 ) {
    path = [path stringByAppendingPathComponent:uid];
    return [path stringByAppendingPathComponent:relativePath];
  }
  return path;
}
+ (NSString *)pathUser:(NSString *)uid service:(NSString *)service file:(NSString *)file
{
  NSString *path = TKPathForDocumentResource(@"Users");
  if ( uid.length>0 ) {
    path = [path stringByAppendingPathComponent:uid];
    if ( service.length>0 ) {
      path = [path stringByAppendingPathComponent:service];
      return [path stringByAppendingPathComponent:file];
    }
  }
  return path;
}

#ifdef DEBUG
+ (void)testPath
{
  NSLog(@"Begin Test Path ========================================");
  NSLog(@"%@", [self pathGlobal:nil]);
  NSLog(@"%@", [self pathGlobal:@""]);
  NSLog(@"%@", [self pathGlobal:@"aaa"]);

  NSLog(@"%@", [self pathGlobal:nil file:nil]);
  NSLog(@"%@", [self pathGlobal:nil file:@"bbb"]);
  NSLog(@"%@", [self pathGlobal:@"aaa" file:nil]);
  NSLog(@"%@", [self pathGlobal:@"aaa" file:@"bbb"]);

  NSLog(@"%@", [self pathUser:nil relativePath:nil]);
  NSLog(@"%@", [self pathUser:nil relativePath:@"aaa"]);
  NSLog(@"%@", [self pathUser:@"u123456" relativePath:nil]);
  NSLog(@"%@", [self pathUser:@"u123456" relativePath:@"aaa"]);

  NSLog(@"%@", [self pathUser:nil service:nil file:nil]);
  NSLog(@"%@", [self pathUser:nil service:nil file:@"bbb"]);
  NSLog(@"%@", [self pathUser:nil service:@"aaa" file:nil]);
  NSLog(@"%@", [self pathUser:nil service:@"aaa" file:@"bbb"]);
  NSLog(@"%@", [self pathUser:@"u123456" service:nil file:nil]);
  NSLog(@"%@", [self pathUser:@"u123456" service:nil file:@"bbb"]);
  NSLog(@"%@", [self pathUser:@"u123456" service:@"aaa" file:nil]);
  NSLog(@"%@", [self pathUser:@"u123456" service:@"aaa" file:@"bbb"]);
  NSLog(@"End Test Path ==========================================");
}
#endif



+ (BOOL)migrateDatabase:(FMDatabaseQueue *)queue prefix:(NSString *)prefix
{
  if ( !queue ) { return NO; }

  __block NSUInteger fromVersion = 0;
  [queue inDatabase:^(FMDatabase *db) { fromVersion = db.userVersion; }];

  NSUInteger toVersion = XYZ_DATABASE_VERSION;

  XYZLogDebug(@"db", @"get user_version: %lu, to_version: %lu", (unsigned long)fromVersion, (unsigned long)toVersion);

  __block BOOL result = YES;

  if ( fromVersion<toVersion ) {
    // 需要升级数据库
    NSMutableString *sql = [[NSMutableString alloc] init];
    for ( NSUInteger i=(fromVersion+1); i<=XYZ_DATABASE_VERSION; ++i ) {
      NSString *scriptName = nil;
      if ( prefix.length>0 ) {
        scriptName = [NSString stringWithFormat:@"%@/v%lu.sql", prefix, (unsigned long)i];
      } else {
        scriptName = [NSString stringWithFormat:@"v%lu.sql", (unsigned long)i];
      }
      NSString *scriptPath = TKPathForBundleResource(nil, scriptName);
      NSString *string = [[NSString alloc] initWithContentsOfFile:scriptPath
                                                         encoding:NSUTF8StringEncoding
                                                            error:NULL];
      if ( string.length>0 ) {
        [sql appendString:string];
      }
    }
    if ( sql.length>0 ) {
      [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeStatements:sql];
        db.userVersion = XYZ_DATABASE_VERSION;
        XYZLogDebug(@"db", @"set user_version: %d", XYZ_DATABASE_VERSION);
        // 升级失败则回滚
        if ( !result ) { *rollback = YES; }
      }];
    }
  } else if ( fromVersion==toVersion ) {
    // 版本相同，不用处理
    result = YES;
  } else {
    // 永远不应该出现这种情况
    result = NO;
  }
  return result;
}

@end
