//
//  XYZSampleObject.h
//  GenericProj
//
//  Created by Haiping Wu on 2018/8/31.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////
//
// 公共宏
//
// 放在头文件中，这个宏的作用域不局限于此文件，需要前缀，取名应该包含此模块名称
//
// {{{常量宏名称全部大写，方法宏名称首字母大写}}}
//
// 公共常量宏
#define XYZ_USER_ANIMATION_DURATION 2.0
// 公共常量宏（排比性质）
#define XYZ_USER_STATUS_NORMAL 1
#define XYZ_USER_STATUS_VIP 2
#define XYZ_USER_STATUS_BLOCKED 3
// 公共方法宏
#define XYZUserFindContact(a,b,c) (xxxxxx)


////////////////////////////////////////////////////////////////////////////////
//
// 公共 C 方法（声明）
//
void TKFindResponderInView(int number);


////////////////////////////////////////////////////////////////////////////////
//
// 通知
//
// 通知属于常量宏，但这里例外命名
//
#define XYZUserDidSignInNotification @"XYZUserDidSignInNotification"


@interface XYZUserManager : NSObject

// 在头文件中声明的只读属性，可以在实现文件中重新声明为读写属性，这样的写法会让类的使用者只能读取
// 属性的值，而类的实现者可以修改属性的值
@property (nonatomic, readonly) NSInteger level;

// 属性中不要使用 NSMutableString，字符串和 block 属性都使用 copy 修饰
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) void (^completion)(BOOL result);

@end
