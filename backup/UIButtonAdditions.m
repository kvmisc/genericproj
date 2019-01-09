//
//  UIButtonAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UIButtonAdditions.h"

@implementation UIButton (TapKit)

#pragma mark - Handy methods

- (NSString *)tk_normalTitle
{ return [self titleForState:UIControlStateNormal]; }
- (void)setTk_normalTitle:(NSString *)normalTitle
{ [self setTitle:normalTitle forState:UIControlStateNormal]; }

- (NSString *)tk_highlightedTitle
{ return [self titleForState:UIControlStateHighlighted]; }
- (void)setTk_highlightedTitle:(NSString *)highlightedTitle
{ [self setTitle:highlightedTitle forState:UIControlStateHighlighted]; }

- (NSString *)tk_disabledTitle
{ return [self titleForState:UIControlStateDisabled]; }
- (void)setTk_disabledTitle:(NSString *)disabledTitle
{ [self setTitle:disabledTitle forState:UIControlStateDisabled]; }

- (NSString *)tk_selectedTitle
{ return [self titleForState:UIControlStateSelected]; }
- (void)setTk_selectedTitle:(NSString *)selectedTitle
{ [self setTitle:selectedTitle forState:UIControlStateSelected]; }


- (UIColor *)tk_normalTitleColor
{ return [self titleColorForState:UIControlStateNormal]; }
- (void)setTk_normalTitleColor:(UIColor *)normalTitleColor
{ [self setTitleColor:normalTitleColor forState:UIControlStateNormal]; }

- (UIColor *)tk_highlightedTitleColor
{ return [self titleColorForState:UIControlStateHighlighted]; }
- (void)setTk_highlightedTitleColor:(UIColor *)highlightedTitleColor
{ [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted]; }

- (UIColor *)tk_disabledTitleColor
{ return [self titleColorForState:UIControlStateDisabled]; }
- (void)setTk_disabledTitleColor:(UIColor *)disabledTitleColor
{ [self setTitleColor:disabledTitleColor forState:UIControlStateDisabled]; }

- (UIColor *)tk_selectedTitleColor
{ return [self titleColorForState:UIControlStateSelected];}
- (void)setTk_selectedTitleColor:(UIColor *)selectedTitleColor
{ [self setTitleColor:selectedTitleColor forState:UIControlStateSelected]; }


- (UIColor *)tk_normalTitleShadowColor
{ return [self titleShadowColorForState:UIControlStateNormal]; }
- (void)setTk_normalTitleShadowColor:(UIColor *)normalTitleShadowColor
{ [self setTitleShadowColor:normalTitleShadowColor forState:UIControlStateNormal]; }

- (UIColor *)tk_highlightedTitleShadowColor
{ return [self titleShadowColorForState:UIControlStateHighlighted]; }
- (void)setTk_highlightedTitleShadowColor:(UIColor *)highlightedTitleShadowColor
{ [self setTitleShadowColor:highlightedTitleShadowColor forState:UIControlStateHighlighted]; }

- (UIColor *)tk_disabledTitleShadowColor
{ return [self titleShadowColorForState:UIControlStateDisabled]; }
- (void)setTk_disabledTitleShadowColor:(UIColor *)disabledTitleShadowColor
{ [self setTitleShadowColor:disabledTitleShadowColor forState:UIControlStateDisabled]; }

- (UIColor *)tk_selectedTitleShadowColor
{ return [self titleShadowColorForState:UIControlStateSelected]; }
- (void)setTk_selectedTitleShadowColor:(UIColor *)selectedTitleShadowColor
{ [self setTitleShadowColor:selectedTitleShadowColor forState:UIControlStateSelected]; }


- (UIImage *)tk_normalImage
{ return [self imageForState:UIControlStateNormal]; }
- (void)setTk_normalImage:(UIImage *)normalImage
{ [self setImage:normalImage forState:UIControlStateNormal]; }

- (UIImage *)tk_highlightedImage
{ return [self imageForState:UIControlStateHighlighted]; }
- (void)setTk_highlightedImage:(UIImage *)highlightedImage
{ [self setImage:highlightedImage forState:UIControlStateHighlighted]; }

- (UIImage *)tk_disabledImage
{ return [self imageForState:UIControlStateDisabled]; }
- (void)setTk_disabledImage:(UIImage *)disabledImage
{ [self setImage:disabledImage forState:UIControlStateDisabled]; }

- (UIImage *)tk_selectedImage
{ return [self imageForState:UIControlStateSelected]; }
- (void)setTk_selectedImage:(UIImage *)selectedImage
{ [self setImage:selectedImage forState:UIControlStateSelected]; }


- (UIImage *)tk_normalBackgroundImage
{ return [self backgroundImageForState:UIControlStateNormal]; }
- (void)setTk_normalBackgroundImage:(UIImage *)normalBackgroundImage
{ [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal]; }

- (UIImage *)tk_highlightedBackgroundImage
{ return [self backgroundImageForState:UIControlStateHighlighted]; }
- (void)setTk_highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage
{ [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted]; }

- (UIImage *)tk_disabledBackgroundImage
{ return [self backgroundImageForState:UIControlStateDisabled]; }
- (void)setTk_disabledBackgroundImage:(UIImage *)disabledBackgroundImage
{ [self setBackgroundImage:disabledBackgroundImage forState:UIControlStateDisabled]; }

- (UIImage *)tk_selectedBackgroundImage
{ return [self backgroundImageForState:UIControlStateSelected]; }
- (void)setTk_selectedBackgroundImage:(UIImage *)selectedBackgroundImage
{ [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected]; }

@end
