//
//  UITextXXXMaxLength.h
//  GenericProj
//
//  Created by Kevin Wu on 9/8/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (MaxLength)

@property (nonatomic, assign) NSUInteger tk_maxLength;

@end


@interface UITextView (MaxLength)

@property (nonatomic, assign) NSUInteger tk_maxLength;

@end
