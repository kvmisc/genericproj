//
//  NSURL+Player.m
//  Foobar
//
//  Created by Haiping Wu on 16/6/28.
//  Copyright © 2016年 firefly.com. All rights reserved.
//

#import "NSURL+Player.h"

@implementation NSURL (Player)

- (NSURL *)fb_customSchemeURL {
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return [components URL];
}

- (NSURL *)fb_originalSchemeURL {
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    return [components URL];
}

@end
