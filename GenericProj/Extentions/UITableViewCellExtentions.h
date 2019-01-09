//
//  UITableViewCellExtentions.h
//  GenericProj
//
//  Created by Kevin Wu on 10/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Extentions)

+ (void)tk_registerInTableView:(UITableView *)tableView hasNib:(BOOL)yesOrNo;
+ (void)tk_registerInTableView:(UITableView *)tableView identifier:(NSString *)identifier hasNib:(BOOL)yesOrNo;

@end
