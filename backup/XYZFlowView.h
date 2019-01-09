//
//  XYZFlowView.h
//  GenericProj
//
//  Created by Kevin Wu on 1/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XYZFlowSectionView;


@interface XYZFlowView : UIScrollView

@property (nonatomic, strong, readonly) UIView *contentView;


- (XYZFlowSectionView *)addSectionView;

- (void)removeSectionViewAtIndex:(NSUInteger)idx;
- (void)removeAllSectionViews;


- (void)layoutSectionViews;

@end



@interface XYZFlowSectionView : UIView

@property (nonatomic, assign) NSInteger yIndex;

@property (nonatomic, strong) NSArray *lineAry;

- (void)addLineView:(UIView *)lineView;

@end
