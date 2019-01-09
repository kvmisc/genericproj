//
//  XYZProgressHUDContentView.h
//  GenericProj
//
//  Created by Kevin Wu on 3/14/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  XYZProgressHUDContentModeActivity = 0,
  XYZProgressHUDContentModeText,
  XYZProgressHUDContentModeCancellation,
  XYZProgressHUDContentModeInfo
} XYZProgressHUDContentMode;


@interface XYZProgressHUDContentView : UIView

@property (nonatomic, strong, readonly) UIImageView *backgroundView;

@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityView;
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIButton *cancelButton;


@property (nonatomic, assign) CGFloat paddingHorizontal;
@property (nonatomic, assign) CGFloat paddingVertical;

@property (nonatomic, assign) CGFloat spacingAT;
@property (nonatomic, assign) CGFloat spacingTC;
@property (nonatomic, assign) CGFloat spacingAC;

@property (nonatomic, assign) CGFloat textHeight;

@property (nonatomic, assign) CGFloat cancelWidth;
@property (nonatomic, assign) CGFloat cancelHeight;


- (void)configForMode:(XYZProgressHUDContentMode)mode;

@end
