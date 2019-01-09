//
//  UIViewAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UIViewAdditions.h"

UIView *TK_FindFirstResponderInView(UIView *topView)
{
  if ( [topView isFirstResponder] ) {
    return topView;
  }
  for ( UIView *subview in topView.subviews ) {
    if ( [subview isFirstResponder] ) {
      return subview;
    }
    UIView *responder = TK_FindFirstResponderInView(subview);
    if ( responder ) {
      return responder;
    }
  }
  return nil;
}

@implementation UIView (TapKit)

#pragma mark - Nib file

+ (id)tk_loadFromNib
{
  return [self tk_loadFromNibNamed:NSStringFromClass(self)];
}

+ (id)tk_loadFromNibNamed:(NSString *)name
{
  if ( name.length>0 ) {
    return [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject];
  }
  return nil;
}



#pragma mark - Image content

- (UIImage *)tk_imageRep
{
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
  [self.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}



#pragma mark - Finding

- (UIView *)tk_descendantOrSelfWithClass:(Class)cls
{
  if ( [self isKindOfClass:cls] ) {
    return self;
  }
  for ( UIView *subview in self.subviews ) {
    UIView *view = [subview tk_descendantOrSelfWithClass:cls];
    if ( view ) {
      return view;
    }
  }
  return nil;
}

- (UIView *)tk_ancestorOrSelfWithClass:(Class)cls
{
  if ( [self isKindOfClass:cls] ) {
    return self;
  } else if ( self.superview ) {
    return [self.superview tk_ancestorOrSelfWithClass:cls];
  }
  return nil;
}


- (UIView *)tk_findFirstResponder
{
  return TK_FindFirstResponderInView(self);
}



#pragma mark - Hierarchy

- (void)tk_bringToFront
{
  [self.superview bringSubviewToFront:self];
}

- (void)tk_sendToBack
{
  [self.superview sendSubviewToBack:self];
}

- (BOOL)tk_isInFront
{
  NSArray *subviewAry = self.superview.subviews;
  return ( [subviewAry lastObject]==self );
}

- (BOOL)tk_isAtBack
{
  NSArray *subviewAry = self.superview.subviews;
  return ( [subviewAry firstObject]==self );
}

@end
