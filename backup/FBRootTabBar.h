//
//  FBRootTabBar.h
//  Foobar
//
//  Created by Haiping Wu on 2019/7/11.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFBRootTabBarHeight 49.0
#define kFBRootTabBarFontSize 12.0
#define kFBRootTabBarTextColor 0x000000ff

@interface FBRootTabBar : FBBaseView

@property (nonatomic, copy) void (^didSelect)(NSUInteger idx);

// 新建成功以后默认选中第一个 tab，所以第一次可能不需要设置此属性
@property (nonatomic, assign) NSUInteger selectedIndex;

// 点击当前已选中 tab 时是否通知，默认 NO
@property (nonatomic, assign) BOOL shouldNotifyRepeatedly;


- (BOOL)isIndexValid:(NSUInteger)idx;

@end
