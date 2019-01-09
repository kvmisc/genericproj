//
//  XYZHUDView.h
//  GenericProj
//
//  Created by Kevin Wu on 13/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZHUDView : XYZCoverContentView

@property (nonatomic, strong, readonly) UIImageView *backgroundView;

@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityView;
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIButton *cancelButton;

@property (nonatomic, copy) void (^cancellation)(void);

- (void)configWithActivity:(BOOL)activity text:(NSString *)text cancel:(void (^)(void))cancel;

@end
