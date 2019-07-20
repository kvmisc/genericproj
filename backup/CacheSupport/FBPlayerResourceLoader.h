//
//  FBPlayerResourceLoader.h
//  Foobar
//
//  Created by Haiping Wu on 2019/7/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "FBPlayerResourceRequest.h"

@class FBPlayerResourceLoader;

@protocol FBPlayerResourceLoaderDelegate <NSObject>
- (void)loader:(FBPlayerResourceLoader *)loader didStart:(NSInteger)totalLength;
- (void)loader:(FBPlayerResourceLoader *)loader didUpdateCache:(NSInteger)length;
- (void)loader:(FBPlayerResourceLoader *)loader didComplete:(NSError *)error;
@end


@interface FBPlayerResourceLoader : NSObject <
    AVAssetResourceLoaderDelegate,
    FBPlayerResourceRequestDelegate
>

@property (nonatomic, weak) id<FBPlayerResourceLoaderDelegate> delegate;

@property (nonatomic, strong) NSError *error;

- (void)stopLoading;

- (void)resumeLoading;

@end
