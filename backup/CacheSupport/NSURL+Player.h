//
//  NSURL+Player.h
//  Foobar
//
//  Created by Haiping Wu on 16/6/28.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Player)

- (NSURL *)fb_customSchemeURL;

- (NSURL *)fb_originalSchemeURL;

@end
