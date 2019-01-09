//
//  UIViewAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (TapKit)

///-------------------------------
/// Nib file
///-------------------------------

+ (id)tk_loadFromNib;

+ (id)tk_loadFromNibNamed:(NSString *)name;


///-------------------------------
/// Image content
///-------------------------------

- (UIImage *)tk_imageRep;


///-------------------------------
/// Finding
///-------------------------------

- (UIView *)tk_descendantOrSelfWithClass:(Class)cls;

- (UIView *)tk_ancestorOrSelfWithClass:(Class)cls;


- (UIView *)tk_findFirstResponder;


///-------------------------------
/// Hierarchy
///-------------------------------

- (void)tk_bringToFront;

- (void)tk_sendToBack;

- (BOOL)tk_isInFront;

- (BOOL)tk_isAtBack;

@end
