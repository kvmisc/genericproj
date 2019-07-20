//
//  FBPlayerResourceRequest.h
//  Foobar
//
//  Created by Haiping Wu on 2019/7/12.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBPlayerResourceRequest;

@protocol FBPlayerResourceRequestDelegate <NSObject>
- (void)request:(FBPlayerResourceRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(FBPlayerResourceRequest *)request didReceiveData:(NSData *)data;
- (void)request:(FBPlayerResourceRequest *)request didCompleteWithError:(NSError *)error;
@end

@interface FBPlayerResourceRequest : NSObject

@property (nonatomic, weak) id<FBPlayerResourceRequestDelegate> delegate;
@property (nonatomic, strong) NSURL *requestURL;

@property (nonatomic, assign) long requestOffset;
//@property (nonatomic, assign) long requestLength;

@property (nonatomic, assign) long cachedLength;
@property (nonatomic, assign) long totalLength;

@property (nonatomic, assign) BOOL cancelled;

- (void)start;
- (void)cancel;

@end
