//
//  XYZSampleObject.m
//  GenericProj
//
//  Created by Haiping Wu on 2018/8/31.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "XYZSampleObject.h"

////////////////////////////////////////////////////////////////////////////////
//
// 私有宏
//
// 放在实现文件中，这个宏的作用域仅在此实现文件，可与其它实现文件中的私有宏同名，不需要前缀，取名
// 应该尽量简短
//
// 私有常量宏
#define ANIMATION_DURATION 2.0
// 私有常量宏（排比性质）
#define STATUS_NORMAL 1
#define STATUS_VIP 2
#define STATUS_BLOCKED 3
// 私有方法宏
#define FindContact(a,b,c) (xxxxxx)


////////////////////////////////////////////////////////////////////////////////
//
// 私有 C 方法（声明和实现）
//
// 命名方式为首单词后添加下划线
//
// 方法名的范围是整个软件，私有方法虽然无法被其它实现文件调用，但是私有方法名却存在于整个链接空间，
// 不允许出现两个相同名称的私有方法实现，所以私有方法与公共方法的差异仅为：名称中添加下划线；不在
// 头文件中声明
//
void TK_FindResponderInView() { /* do nothing here */ }

////////////////////////////////////////////////////////////////////////////////
//
// 公共 C 方法（实现）
//
void TKFindResponderInView(int number) { /* do nothing here */ }



// 在类扩展中声明私有属性。私有方法可以直接写在实现中，不需要声明
@interface XYZUserManager ()
// 这里重新定义 level 属性，添加一个私有写方法
@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *token;

@end


@implementation XYZUserManager {
  // 不需要声明属性的类成员变量
  NSUInteger _age;
}



// 私有方法，命名方式为首单词后添加下划线
- (void)clear_
{
}

- (void)make_User
{
}

@end
