//
//  XYZDateFormatter.h
//  SmartCombat
//
//  Created by Kevin Wu on 11/12/2017.
//  Copyright © 2017 Kevin Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

// yyyy-MM-dd HH:mm:ss
extern NSDateFormatter *XYZDateFormatter01;

// yyyy-MM-dd
extern NSDateFormatter *XYZDateFormatter21;
// yyyy-MM
extern NSDateFormatter *XYZDateFormatter22;

// HH:mm:ss
extern NSDateFormatter *XYZDateFormatter41;


@interface XYZDateFormatter : NSObject

+ (void)setup;

@end
