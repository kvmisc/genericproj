//
//  XYZActionContentView.h
//  GenericProj
//
//  Created by Kevin Wu on 5/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYZCoverView;

@interface XYZActionContentView : XYZBaseView

@property (nonatomic, weak, readonly) XYZCoverView *coverView;


- (void)presentInView:(UIView *)inView;

- (void)dismiss;

@end
