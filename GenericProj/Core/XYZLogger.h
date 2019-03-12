//
//  XYZLogger.h
//  GenericProj
//
//  Created by Kevin Wu on 8/8/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*******************************************************************************

 Code:

 XYZLogError(@"player", @"Error: %d", 404);


 Output:

 [player] Error: 404


 Log Path:

 Library/Caches/Logs/com.firefly.genericproj 2016-08-08 06-13.log

 ******************************************************************************/

/* [CONFIGURABLE_VALUE] */
#define XYZ_USE_SYSTEM_LOG 1


#if XYZ_USE_SYSTEM_LOG

#define XYZLog(_fmt_, ...)                NSLog(_fmt_, ##__VA_ARGS__)

#define XYZLogError(_dmn_,_fmt_, ...)     NSLog(@"[%@] "_fmt_, _dmn_, ##__VA_ARGS__)
#define XYZLogWarn(_dmn_,_fmt_, ...)      NSLog(@"[%@] "_fmt_, _dmn_, ##__VA_ARGS__)
#define XYZLogInfo(_dmn_,_fmt_, ...)      NSLog(@"[%@] "_fmt_, _dmn_, ##__VA_ARGS__)
#define XYZLogDebug(_dmn_,_fmt_, ...)     NSLog(@"[%@] "_fmt_, _dmn_, ##__VA_ARGS__)
#define XYZLogVerbose(_dmn_,_fmt_, ...)   NSLog(@"[%@] "_fmt_, _dmn_, ##__VA_ARGS__)

#else

#define XYZLog(_fmt_, ...)                DDLogError(_fmt_, ##__VA_ARGS__)

#define XYZLogError(_dmn_,_fmt_, ...)     DDLogError(@"[%@] "_fmt_, _dmn_, ##__VA_ARGS__)
#define XYZLogWarn(_dmn_,_fmt_, ...)      DDLogWarn(@"[%@] "_fmt_, _dmn_, ##__VA_ARGS__)
#define XYZLogInfo(_dmn_,_fmt_, ...)      DDLogInfo(@"[%@] "_fmt_, _dmn_, ##__VA_ARGS__)
#define XYZLogDebug(_dmn_,_fmt_, ...)     DDLogDebug(@"[%@] "_fmt_, _dmn_, ##__VA_ARGS__)
#define XYZLogVerbose(_dmn_,_fmt_, ...)   DDLogVerbose(@"[%@] "_fmt_, _dmn_, ##__VA_ARGS__)

#endif


@interface XYZLogger : NSObject

+ (void)setup;

@end
