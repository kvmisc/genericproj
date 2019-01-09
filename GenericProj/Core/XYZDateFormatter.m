//
//  XYZDateFormatter.m
//  SmartCombat
//
//  Created by Kevin Wu on 11/12/2017.
//  Copyright © 2017 Kevin Wu. All rights reserved.
//

#import "XYZDateFormatter.h"

// yyyy-MM-dd HH:mm:ss
NSDateFormatter *XYZDateFormatter01 = nil;

// yyyy-MM-dd
NSDateFormatter *XYZDateFormatter21 = nil;
// yyyy-MM
NSDateFormatter *XYZDateFormatter22 = nil;

// HH:mm:ss
NSDateFormatter *XYZDateFormatter41 = nil;


@implementation XYZDateFormatter

+ (void)setup
{
  // yyyy-MM-dd HH:mm:ss
  XYZDateFormatter01 = [[NSDateFormatter alloc] init];
  [XYZDateFormatter01 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  [XYZDateFormatter01 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
  [XYZDateFormatter01 setTimeZone:[NSTimeZone systemTimeZone]];

  // yyyy-MM-dd
  XYZDateFormatter21 = [[NSDateFormatter alloc] init];
  [XYZDateFormatter21 setDateFormat:@"yyyy-MM-dd"];
  [XYZDateFormatter21 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
  [XYZDateFormatter21 setTimeZone:[NSTimeZone systemTimeZone]];
  // yyyy-MM
  XYZDateFormatter22 = [[NSDateFormatter alloc] init];
  [XYZDateFormatter22 setDateFormat:@"yyyy-MM"];
  [XYZDateFormatter22 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
  [XYZDateFormatter22 setTimeZone:[NSTimeZone systemTimeZone]];

  // HH:mm:ss
  XYZDateFormatter41 = [[NSDateFormatter alloc] init];
  [XYZDateFormatter41 setDateFormat:@"HH:mm:ss"];
  [XYZDateFormatter41 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
  [XYZDateFormatter41 setTimeZone:[NSTimeZone systemTimeZone]];
}

@end
