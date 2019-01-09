//
//  UITableViewCellExtentions.m
//  GenericProj
//
//  Created by Kevin Wu on 10/12/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "UITableViewCellExtentions.h"

@implementation UITableViewCell (Extentions)

+ (void)tk_registerInTableView:(UITableView *)tableView hasNib:(BOOL)yesOrNo
{
  [self tk_registerInTableView:tableView identifier:NSStringFromClass(self) hasNib:yesOrNo];
}

+ (void)tk_registerInTableView:(UITableView *)tableView identifier:(NSString *)identifier hasNib:(BOOL)yesOrNo
{
  if ( tableView ) {
    if ( identifier.length>0 ) {
      if ( yesOrNo ) {
        [tableView registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:identifier];
      } else {
        [tableView registerClass:self forCellReuseIdentifier:identifier];
      }
    }
  }
}

@end
