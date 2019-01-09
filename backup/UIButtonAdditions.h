//
//  UIButtonAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton (TapKit)

///-------------------------------
/// Handy methods
///-------------------------------

@property (nonatomic, copy) NSString *tk_normalTitle;
@property (nonatomic, copy) NSString *tk_highlightedTitle;
@property (nonatomic, copy) NSString *tk_disabledTitle;
@property (nonatomic, copy) NSString *tk_selectedTitle;

@property (nonatomic, strong) UIColor *tk_normalTitleColor;
@property (nonatomic, strong) UIColor *tk_highlightedTitleColor;
@property (nonatomic, strong) UIColor *tk_disabledTitleColor;
@property (nonatomic, strong) UIColor *tk_selectedTitleColor;

@property (nonatomic, strong) UIColor *tk_normalTitleShadowColor;
@property (nonatomic, strong) UIColor *tk_highlightedTitleShadowColor;
@property (nonatomic, strong) UIColor *tk_disabledTitleShadowColor;
@property (nonatomic, strong) UIColor *tk_selectedTitleShadowColor;

@property (nonatomic, strong) UIImage *tk_normalImage;
@property (nonatomic, strong) UIImage *tk_highlightedImage;
@property (nonatomic, strong) UIImage *tk_disabledImage;
@property (nonatomic, strong) UIImage *tk_selectedImage;

@property (nonatomic, strong) UIImage *tk_normalBackgroundImage;
@property (nonatomic, strong) UIImage *tk_highlightedBackgroundImage;
@property (nonatomic, strong) UIImage *tk_disabledBackgroundImage;
@property (nonatomic, strong) UIImage *tk_selectedBackgroundImage;

@end
