//
//  XYZAlertContentView.h
//  GenericProj
//
//  Created by Kevin Wu on 13/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYZCoverView;

@interface XYZAlertContentView : XYZBaseView

@property (nonatomic, weak, readonly) XYZCoverView *coverView;


- (void)presentInView:(UIView *)inView;

- (void)dismiss;

@end
