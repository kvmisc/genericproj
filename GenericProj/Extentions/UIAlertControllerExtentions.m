//
//  UIAlertControllerExtentions.m
//  GenericProj
//
//  Created by Kevin Wu on 14/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "UIAlertControllerExtentions.h"

@implementation UIAlertController (Extentions)

- (UIAlertAction *)tk_addAction:(NSString *)title handler:(void (^)(UIAlertAction *action))handler
{
  UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                   style:UIAlertActionStyleDefault
                                                 handler:handler];
  [self addAction:action];
  return action;
}
- (UIAlertAction *)tk_addCancelAction:(NSString *)title handler:(void (^)(UIAlertAction *action))handler
{
  UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                   style:UIAlertActionStyleCancel
                                                 handler:handler];
  [self addAction:action];
  return action;
}
- (UIAlertAction *)tk_addDestructiveAction:(NSString *)title handler:(void (^)(UIAlertAction *action))handler
{
  UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                   style:UIAlertActionStyleDestructive
                                                 handler:handler];
  [self addAction:action];
  return action;
}


+ (UIAlertController *)tk_presentAlert:(NSString *)title message:(NSString *)message confirm:(NSString *)confirm completion:(void (^)(void))completion
{
  UIAlertController *ac = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  [ac tk_addAction:confirm handler:^(UIAlertAction *action) { if ( completion ) { completion(); } }];
  [[XYZGlobal topmostViewController] presentViewController:ac animated:YES completion:NULL];
  return ac;
}

+ (UIAlertController *)tk_presentConfirm:(NSString *)title
                                 message:(NSString *)message
                                  cancel:(NSString *)cancel
                                 confirm:(NSString *)confirm
                              completion:(void (^)(BOOL result))completion
{
  UIAlertController *ac = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  [ac tk_addAction:cancel handler:^(UIAlertAction *action) { if ( completion ) { completion(NO); } }];
  ac.preferredAction =
  [ac tk_addAction:confirm handler:^(UIAlertAction *action) { if ( completion ) { completion(YES); } }];
  [[XYZGlobal topmostViewController] presentViewController:ac animated:YES completion:NULL];
  return ac;
}
+ (UIAlertController *)tk_presentConfirm:(NSString *)title
                                 message:(NSString *)message
                                 confirm:(NSString *)confirm
                                  cancel:(NSString *)cancel
                              completion:(void (^)(BOOL result))completion
{
  UIAlertController *ac = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  [ac tk_addAction:confirm handler:^(UIAlertAction *action) { if ( completion ) { completion(YES); } }];
  ac.preferredAction =
  [ac tk_addAction:cancel handler:^(UIAlertAction *action) { if ( completion ) { completion(NO); } }];
  [[XYZGlobal topmostViewController] presentViewController:ac animated:YES completion:NULL];
  return ac;
}

+ (UIAlertController *)tk_presentInput:(NSString *)title
                               message:(NSString *)message
                                 field:(void (^)(UITextField *textField))field
                                cancel:(NSString *)cancel
                               confirm:(NSString *)confirm
                            completion:(void (^)(BOOL result, NSString *string))completion;
{
  UIAlertController *ac = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  [ac addTextFieldWithConfigurationHandler:field];
  @weakify(ac);
  [ac tk_addAction:cancel handler:^(UIAlertAction *action) {
    @strongify(ac);
    if ( completion ) { completion(NO, ac.textFields[0].text); }
  }];
  ac.preferredAction =
  [ac tk_addAction:confirm handler:^(UIAlertAction *action) {
    @strongify(ac);
    if ( completion ) { completion(YES, ac.textFields[0].text); }
  }];
  [ac addTextFieldWithConfigurationHandler:field];
  [[XYZGlobal topmostViewController] presentViewController:ac animated:YES completion:NULL];
  return ac;
}
+ (UIAlertController *)tk_presentInput:(NSString *)title
                               message:(NSString *)message
                                 field:(void (^)(UITextField *textField))field
                               confirm:(NSString *)confirm
                                cancel:(NSString *)cancel
                            completion:(void (^)(BOOL result, NSString *string))completion;
{
  UIAlertController *ac = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  [ac addTextFieldWithConfigurationHandler:field];
  @weakify(ac);
  [ac tk_addAction:confirm handler:^(UIAlertAction *action) {
    @strongify(ac);
    if ( completion ) { completion(YES, ac.textFields[0].text); }
  }];
  ac.preferredAction =
  [ac tk_addAction:cancel handler:^(UIAlertAction *action) {
    @strongify(ac);
    if ( completion ) { completion(NO, ac.textFields[0].text); }
  }];
  [ac addTextFieldWithConfigurationHandler:field];
  [[XYZGlobal topmostViewController] presentViewController:ac animated:YES completion:NULL];
  return ac;
}

@end
