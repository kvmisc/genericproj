//
//  NSObjectExtentions.h
//  GenericProj
//
//  Created by Kevin Wu on 9/8/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extentions)

@property (nonatomic, retain) id tk_theInfo;


- (void)tk_encoding:(NSCoder *)coder;

- (void)tk_decoding:(NSCoder *)coder;

+ (NSArray *)tk_propertyNames;

@end
