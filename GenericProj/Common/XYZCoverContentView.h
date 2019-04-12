//
//  XYZCoverContentView.h
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYZCoverView;


@interface XYZCoverContentView : UIView

@property (nonatomic, weak, readonly) XYZCoverView *coverView;

- (void)prepareForView:(UIView *)inView viewport:(UIView *)viewport;

- (void)updateStateFromAnimation:(BOOL)completion;

- (CAAnimation *)showAnimation;
- (CAAnimation *)hideAnimation;

@end
