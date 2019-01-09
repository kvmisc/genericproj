//
//  UINavigationControllerExtentions.h
//  GenericProj
//
//  Created by Haiping Wu on 07/02/2018.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extentions)

- (NSArray *)tk_popNumberOfViewControllers:(NSUInteger)count animated:(BOOL)animated;

@end
