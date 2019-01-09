//
//  UIScrollViewExtentions.h
//  GenericProj
//
//  Created by Haiping Wu on 08/02/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Extentions)

- (UIView *)tk_contentView;

- (NSArray *)tk_subviews;
- (void)tk_addSubview:(UIView *)view;
- (void)tk_removeAllSubviews;

- (void)tk_updateConstraints;

@end
