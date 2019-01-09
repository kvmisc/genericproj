//
//  UITextXXXMaxLength.m
//  GenericProj
//
//  Created by Kevin Wu on 9/8/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "UITextXXXMaxLength.h"
#import <objc/runtime.h>

@implementation UITextField (MaxLength)

- (NSUInteger)tk_maxLength
{
  NSNumber *length = objc_getAssociatedObject(self, @selector(tk_maxLength));
  return [length unsignedIntegerValue];
}

- (void)setTk_maxLength:(NSUInteger)maxLength
{
  NSNumber *length = [NSNumber numberWithUnsignedInteger:maxLength];
  objc_setAssociatedObject(self, @selector(tk_maxLength), length, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

  if ( maxLength>0 ) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tk_textDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
  } else {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self];
  }
}

- (void)tk_textDidChange:(NSNotification *)notification
{
  if ( self.tk_maxLength<=0 ) { return; }
  if ( self!=[notification object] ) { return; }
  if ( self.text.length<=0 ) { return; }

  if ( ![self markedTextRange] ) {
    NSString *text = [self.text copy];
    NSString *trimmed = [text tk_stringByTruncatingToLength:self.tk_maxLength];

    if ( ![text isEqualToString:trimmed] ) {
      self.text = trimmed;
    }
  }
}

@end


@implementation UITextView (MaxLength)

- (NSUInteger)tk_maxLength
{
  NSNumber *length = objc_getAssociatedObject(self, @selector(tk_maxLength));
  return [length unsignedIntegerValue];
}

- (void)setTk_maxLength:(NSUInteger)maxLength
{
  NSNumber *length = [NSNumber numberWithUnsignedInteger:maxLength];
  objc_setAssociatedObject(self, @selector(tk_maxLength), length, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

  if ( maxLength>0 ) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tk_textDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
  } else {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
  }
}

- (void)tk_textDidChange:(NSNotification *)notification
{
  if ( self.tk_maxLength<=0 ) { return; }
  if ( self!=[notification object] ) { return; }
  if ( self.text.length<=0 ) { return; }

  if ( ![self markedTextRange] ) {
    NSString *text = [self.text copy];
    NSString *trimmed = [text tk_stringByTruncatingToLength:self.tk_maxLength];

    if ( ![text isEqualToString:trimmed] ) {
      self.text = trimmed;
    }
  }
}

@end
