//
//  GPTestViewController.h
//  GenericProj
//
//  Created by Kevin Wu on 5/25/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifdef DAILY_DEBUG

// 用命令行打包，release 配置，debug 服务器
#define BASE_URL @"http://daily.debug"

#elif defined DAILY_RELEASE

// 用命令行打包，release 配置，release 服务器
#define BASE_URL @"http://daily.release"

#elif defined DEBUG

// 用 xcode 运行，debug 配置，debug 服务器
#define BASE_URL @"http://debug"

#else

// 用 xcode 运行，release 配置，release 服务器
// App Store 发布，release 配置，release 服务器
#define BASE_URL @"http://release"

#endif


@interface GPTestViewController : XYZBaseViewController <
    CALayerDelegate
>

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UIView *greenView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *displayView;

@end
