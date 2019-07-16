//
//  FBFileMaper.h
//  Foobar
//
//  Created by Haiping Wu on 2019/7/15.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBFileMaper : NSObject

- (id)initWithPath:(NSString *)path;

+ (BOOL)updateFile:(NSString *)path offset:(long)offset data:(NSData *)data;

@end
