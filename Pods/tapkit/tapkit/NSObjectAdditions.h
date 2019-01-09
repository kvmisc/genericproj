//
//  NSObjectAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TapKit)

///-------------------------------
/// Key-Value Coding
///-------------------------------

- (BOOL)tk_isValueForKeyPath:(NSString *)keyPath equalTo:(id)value;

- (BOOL)tk_isValueForKeyPath:(NSString *)keyPath identicalTo:(id)value;

@end
