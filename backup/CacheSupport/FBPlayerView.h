//
//  FBPlayerView.h
//  Foobar
//
//  Created by Haiping Wu on 2019/7/7.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FBPlayerTitleView.h"
#import "FBPlayerControlView.h"
#import "FBPlayerInfoView.h"

#define FB_PLAYER_DEFAULT_TIME_LIMIT 60

@interface FBPlayerView : UIView

@property (nonatomic, strong) FBPlayerTitleView *titleView;
@property (nonatomic, strong) FBPlayerControlView *controlView;
@property (nonatomic, strong) FBPlayerInfoView *infoView;

@property (nonatomic, strong, readonly) AVPlayer *player;
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;

@property (nonatomic, assign) BOOL startPlayingWhenReady;

- (void)playWithURL:(NSString *)url restricted:(BOOL)restricted;

- (BOOL)playing;

@end
