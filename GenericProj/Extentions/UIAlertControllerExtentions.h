//
//  UIAlertControllerExtentions.h
//  GenericProj
//
//  Created by Kevin Wu on 14/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extentions)

- (UIAlertAction *)tk_addAction:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

- (UIAlertAction *)tk_addCancelAction:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

- (UIAlertAction *)tk_addDestructiveAction:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;


+ (UIAlertController *)tk_presentAlert:(NSString *)title
                               message:(NSString *)message
                               confirm:(NSString *)confirm
                            completion:(void (^)(void))completion;

+ (UIAlertController *)tk_presentConfirm:(NSString *)title
                                 message:(NSString *)message
                                  cancel:(NSString *)cancel
                                 confirm:(NSString *)confirm
                              completion:(void (^)(BOOL result))completion;
+ (UIAlertController *)tk_presentConfirm:(NSString *)title
                                 message:(NSString *)message
                                 confirm:(NSString *)confirm
                                  cancel:(NSString *)cancel
                              completion:(void (^)(BOOL result))completion;

+ (UIAlertController *)tk_presentInput:(NSString *)title
                               message:(NSString *)message
                                 field:(void (^)(UITextField *textField))field
                                cancel:(NSString *)cancel
                               confirm:(NSString *)confirm
                            completion:(void (^)(BOOL result, NSString *string))completion;
+ (UIAlertController *)tk_presentInput:(NSString *)title
                               message:(NSString *)message
                                 field:(void (^)(UITextField *textField))field
                               confirm:(NSString *)confirm
                                cancel:(NSString *)cancel
                            completion:(void (^)(BOOL result, NSString *string))completion;

@end
