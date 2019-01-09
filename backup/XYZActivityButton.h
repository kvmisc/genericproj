//
//  XYZActivityButton.h
//  winlot
//
//  Created by Kevin Wu on 11/3/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZActivityButton : UIButton

@property (nonatomic, copy) XYZVoidIdIdBlock saveAndClearStatus;
@property (nonatomic, copy) XYZVoidIdIdBlock restoreStatus;

@property (nonatomic, assign) BOOL animating;

// 任何实现 startAnimating 和 stopAnimating 的视图都可以作为参数，视图必须有自己的固有尺寸
- (id)initWithActivityView:(UIActivityIndicatorView *)activityView;

@end
