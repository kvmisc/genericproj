//
//  UINavigationControllerExtentions.m
//  GenericProj
//
//  Created by Haiping Wu on 07/02/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "UINavigationControllerExtentions.h"

@implementation UINavigationController (Extentions)

- (NSArray *)tk_popNumberOfViewControllers:(NSUInteger)count animated:(BOOL)animated
{
  if ( count>=1 ) {
    NSArray *ary = [self viewControllers];
    NSUInteger total = [ary count];
    if ( total>count ) {
      NSMutableArray *ret = [[NSMutableArray alloc] init];
      UIViewController *vc = nil;
      for ( NSUInteger i=0; i<count; ++i ) {
        vc = [ary tk_objectOrNilAtIndex:total-1-i];
        [ret insertObject:vc atIndex:0];
      }
      vc = [ary tk_objectOrNilAtIndex:total-1-count];
      [self popToViewController:vc animated:animated];
      return ret;
    }
  }
  return nil;
}

@end
