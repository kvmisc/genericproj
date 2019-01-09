//
//  XYZBaseViewController.h
//  GenericProj
//
//  Created by Kevin Wu on 12/29/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYZBaseViewControllerActivityProtocol <NSObject>

// (1)第一次进入此页面，在此方法中启动动画、跑马灯等。(32)从其它页面返回进入此页面，在此方法中重
//    启动画、跑马灯等。
- (void)startActivities;

// (2)离开页面(返回、进入下级页面)，在此方法中停止动画、跑马灯等，这里仅仅停止而不清理对象。
- (void)stopActivities;

// (31)如果是返回操作导致离开此页面，此页面应该被销毁，程序员应该取消此页面包含的各种延时操作，放
//     弃此页面中包含的对此页面的强引用，让此页面被系统回收。
- (void)destroyActivities;

@end


@interface XYZBaseViewController : UIViewController <XYZBaseViewControllerActivityProtocol>

@property (nonatomic, assign, readonly) BOOL viewAppeared;
@property (nonatomic, assign, readonly) BOOL appearedEver;

@property (nonatomic, strong, readonly) UIView *contentView;


- (void)viewDidLoad;

- (void)didReceiveMemoryWarning;

- (void)updateViewConstraints;


- (BOOL)shouldLoadContentView;

- (void)loadContentViewIfNeeded;

@end
