//
//  XYZLanguageManager.h
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/18.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////
// 本地化宏
extern NSBundle *XYZLanguageBundle;
#define XYZLS(key) [XYZLanguageBundle localizedStringForKey:(key) value:@"" table:nil]
////////////////////////////////////////////////////////////////////////////////



#define XYZ_LANGUAGE_CODE_EN @"en"
#define XYZ_LANGUAGE_CODE_ZH_HANS @"zh-Hans"
#define XYZ_LANGUAGE_CODE_ZH_HANT @"zh-Hant"

#define XYZLanguageDidChangeNotification @"XYZLanguageDidChangeNotification"

@interface XYZLanguageManager : NSObject

+ (void)setup;

+ (NSArray *)availableLanguages;

+ (NSString *)currentLanguage;
+ (void)changeToLanguage:(NSString *)code;
+ (void)changeToSystemLanguage;

@end
