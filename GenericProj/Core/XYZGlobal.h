//
//  XYZGlobal.h
//  GenericProj
//
//  Created by Kevin Wu on 8/15/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/* [CONFIGURABLE_VALUE] */
#define XYZ_DATABASE_VERSION 3


@interface XYZGlobal : NSObject

+ (UIWindow *)visibleTopmostWindow;
+ (UIViewController *)topmostViewController;


+ (BOOL)isVersionValid:(NSString *)ver;
+ (BOOL)isVersion:(NSString *)ver1 equalTo:(NSString *)ver2;
+ (BOOL)isVersion:(NSString *)ver1 lessThan:(NSString *)ver2;
+ (BOOL)isVersion:(NSString *)ver1 lessOrEqual:(NSString *)ver2;
+ (BOOL)isVersion:(NSString *)ver1 greaterThan:(NSString *)ver2;
+ (BOOL)isVersion:(NSString *)ver1 greaterOrEqual:(NSString *)ver2;
+ (NSComparisonResult)compareVersion:(NSString *)ver1 version:(NSString *)ver2;


+ (CGFloat)boundFlt:(CGFloat)value left:(CGFloat)left right:(CGFloat)right;
+ (NSInteger)boundInt:(NSInteger)value left:(NSInteger)left right:(NSInteger)right;


// /xxx/xxx/Documents/${relativePath}
+ (NSString *)pathGlobal:(NSString *)relativePath;
// /xxx/xxx/Documents/${service}/${file}
+ (NSString *)pathGlobal:(NSString *)service file:(NSString *)file;
// /xxx/xxx/Documents/Users/${uid}/${relativePath}
+ (NSString *)pathUser:(NSString *)uid relativePath:(NSString *)relativePath;
// /xxx/xxx/Documents/Users/${uid}/${service}/${file}
+ (NSString *)pathUser:(NSString *)uid service:(NSString *)service file:(NSString *)file;


+ (BOOL)migrateDatabase:(FMDatabaseQueue *)queue prefix:(NSString *)prefix;

@end
