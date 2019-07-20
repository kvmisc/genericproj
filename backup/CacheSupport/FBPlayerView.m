//
//  FBPlayerView.m
//  Foobar
//
//  Created by Haiping Wu on 2019/7/7.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "FBPlayerView.h"
#import "FBPlayerResourceLoader.h"
#import "NSURL+Player.h"

#define TOP_HET 40.0
#define BOT_HET 40.0

@interface FBPlayerView ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL seeking;
@property (nonatomic, assign) NSInteger timeLimit;

@property (nonatomic, assign) CGFloat playedTime;
@property (nonatomic, assign) CGFloat cachedTime;
@property (nonatomic, assign) CGFloat totalTime;

@property (nonatomic, strong) id playedTimeObserver;

@property (nonatomic, strong) FBPlayerResourceLoader *resourceLoader;

@end

@implementation FBPlayerView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
    [self setupGestureRecognizer];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
    [self setupGestureRecognizer];
  }
  return self;
}

- (void)setup
{
  self.backgroundColor = [UIColor blackColor];

  _titleView = [[FBPlayerTitleView alloc] init];
  _titleView.operable = NO;
  [self addSubview:_titleView];
  _titleView.layer.zPosition = 20;

  _controlView = [[FBPlayerControlView alloc] init];
  [_controlView.playButton addTarget:self
                              action:@selector(playButtonClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
  [_controlView.progressView.playView addTarget:self
                                         action:@selector(sliderValueChanged:forEvent:)
                               forControlEvents:UIControlEventValueChanged];
  [_controlView.backwardButton addTarget:self
                              action:@selector(wardButtonClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
  [_controlView.forwardButton addTarget:self
                                  action:@selector(wardButtonClicked:)
                        forControlEvents:UIControlEventTouchUpInside];
  _controlView.operable = NO;
  [self addSubview:_controlView];
  _controlView.layer.zPosition = 20;

  _infoView = [[FBPlayerInfoView alloc] init];
  [self addSubview:_infoView];
  _infoView.layer.zPosition = 20;
}
- (void)layoutSubviews
{
  [super layoutSubviews];

  _titleView.frame = CGRectMake(0.0,
                                0.0,
                                self.bounds.size.width,
                                TOP_HET);

  _controlView.frame = CGRectMake(0.0,
                                  self.bounds.size.height-BOT_HET,
                                  self.bounds.size.width,
                                  BOT_HET);

  _infoView.frame = CGRectMake(0.0,
                               TOP_HET,
                               self.bounds.size.width,
                               self.bounds.size.height-TOP_HET-BOT_HET);

  _playerLayer.frame = self.bounds;
}

- (void)setupGestureRecognizer
{
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
  [self addGestureRecognizer:tapGestureRecognizer];
}
- (void)tap:(UITapGestureRecognizer *)gr
{
  if ( _titleView.hidden ) {
    _titleView.hidden = NO;
    _controlView.hidden = NO;
  } else {
    CGPoint point = [gr locationInView:self];
    if ( (point.y>TOP_HET) && (point.y<self.bounds.size.height-BOT_HET) ) {
      _titleView.hidden = YES;
      _controlView.hidden = YES;
    }
  }
}



- (void)addObservers
{
  @weakify(self);

  ////////////////////////////////////////
  // 播放器状态改变、资源状态改变

  // 播放器状态
  [self.KVOController observe:_player keyPath:@"status" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
    @strongify(self);
    [self playerOrItemStatusChanged];
  }];
  // 资源状态
  [self.KVOController observe:_playerItem keyPath:@"status" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
    @strongify(self);
    [self playerOrItemStatusChanged];
  }];


  ////////////////////////////////////////
  // 播放时间改变、资源加载时间改变

  // 播放时间
  _playedTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0)
                                                              queue:dispatch_get_main_queue()
                                                         usingBlock:^(CMTime time)
                         {
                           @strongify(self);
                           CGFloat playedTime = CMTimeGetSeconds(time);
                           CGFloat totalTime = CMTimeGetSeconds(self.playerItem.duration);
                           self.playedTime = playedTime;
                           if ( totalTime>0.0 ) {
                             self.totalTime = totalTime;
                             CGFloat progress = playedTime/totalTime;
                             //NSLog(@"[player] play progress: %d/%d=%02f", (int)playedTime, (int)totalTime, progress);
                             self.controlView.beginLabel.text = [self formatedTime:self.playedTime];
                             self.controlView.endLabel.text = [self formatedTime:self.totalTime];
                             if ( (!self.controlView.progressView.playView.dragging) && (!self.seeking) ) {
                               self.controlView.progressView.playView.value = progress;
                             }
                           }

                           if ( [self timeLimitExceeded:playedTime] ) {
                             // 非会员播放超过时间了，停止播放。
                             [self.player pause];
                           }
                         }];

  // 资源加载时间
  [self.KVOController observe:_playerItem
                      keyPath:@"loadedTimeRanges"
                      options:NSKeyValueObservingOptionNew
                        block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
                          @strongify(self);
                          CGFloat bufferedTime = 0.0;
                          NSArray *array = self.playerItem.loadedTimeRanges;
                          NSMutableString *info = [[NSMutableString alloc] initWithString:@"buffered:"];
                          for ( NSInteger i=0; i<[array count]; ++i ) {
                            CMTimeRange timeRange = [[array objectAtIndex:i] CMTimeRangeValue];
                            CGFloat start = CMTimeGetSeconds(timeRange.start);
                            CGFloat duration = CMTimeGetSeconds(timeRange.duration);
                            CGFloat end = start+duration;
                            [info appendFormat:@" [%.2f-%.2f]", start, end];
                            if ( bufferedTime<end ) {
                              bufferedTime = end;
                            }
                          }
                          self.cachedTime = bufferedTime;
                          NSLog(@"[player] %@", info);
                          if ( self.totalTime>0.0 ) {
                            CGFloat progress = bufferedTime/self.totalTime;
                            self.controlView.progressView.loadView.progress = progress;
                          } else {
                          }

                          // 给十秒的空间
                          if ( [self timeLimitExceeded:bufferedTime-10.0] ) {
                            // 非会员播放超过时间了，停止加载。
                            [self.resourceLoader stopLoading];
                          }
                        }];


  ////////////////////////////////////////
  // 播放状态/暂停状态
  [self.KVOController observe:_player keyPath:@"rate" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
    @strongify(self);
    [self playOrPauseStatusChanged];
  }];

  // 是否卡顿状态
  [self.KVOController observe:_playerItem
                      keyPath:@"playbackLikelyToKeepUp"
                      options:NSKeyValueObservingOptionNew
                        block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
                          @strongify(self);
                          NSLog(@"playbackLikelyToKeepUp: %d %f", self.playerItem.playbackLikelyToKeepUp, self.player.rate);
                          if ( (self.player.status==AVPlayerStatusReadyToPlay) && (self.playerItem.status==AVPlayerItemStatusReadyToPlay) ) {
                            if ( self.playerItem.playbackLikelyToKeepUp ) {
                              [self.infoView hide];
                            } else {
                              [self.infoView showLoading];
                            }
                          }
                        }];

  // 通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(itemDidPlayToEndTime:)
                                               name:AVPlayerItemDidPlayToEndTimeNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(itemFailedToPlayToEndTime:)
                                               name:AVPlayerItemFailedToPlayToEndTimeNotification
                                             object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(itemPlaybackStalled:)
//                                               name:AVPlayerItemPlaybackStalledNotification
//                                             object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(itemTimeJumped:)
//                                               name:AVPlayerItemTimeJumpedNotification
//                                             object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(itemNewErrorLogEntry:)
//                                               name:AVPlayerItemNewErrorLogEntryNotification
//                                             object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(itemNewAccessLogEntry:)
//                                               name:AVPlayerItemNewAccessLogEntryNotification
//                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didEnterBackground:)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(willEnterForeground:)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
}
- (void)removeObservers
{
  [self.KVOController unobserveAll];

  [_player removeTimeObserver:_playedTimeObserver];
  _playedTimeObserver = nil;

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)playButtonClicked:(FBPlayerSwitchButton *)sender
{
  if ( [self timeLimitExceeded:_playedTime] ) {
    return;
  }

  if ( sender.on ) {
    NSLog(@"to play");
    [_player play];
  } else {
    NSLog(@"to pause");
    [_player pause];
  }
}

- (void)sliderValueChanged:(FBPlayerSliderView *)sender forEvent:(UIEvent *)event
{
  UITouch *touch = [[event allTouches] anyObject];
  switch ( touch.phase ) {
    case UITouchPhaseBegan:
      //NSLog(@"handle drag began: %f", sender.value);
      sender.dragging = YES;
      break;
    case UITouchPhaseMoved:
      //NSLog(@"handle drag moved: %f", sender.value);
      sender.dragging = YES;
      break;
    case UITouchPhaseStationary:
      //NSLog(@"handle drag stationary: %f", sender.value);
      sender.dragging = YES;
      break;
    case UITouchPhaseEnded:
      //NSLog(@"handle drag ended: %f", sender.value);
      sender.dragging = NO;
      break;
    case UITouchPhaseCancelled:
      //NSLog(@"handle drag cancelled: %f", sender.value);
      sender.dragging = NO;
      break;
    default:
      break;
  }

  CGFloat seconds = _totalTime * sender.value;

  if ( sender.dragging ) {
    NSLog(@"[player] slider dragging");
    _controlView.beginLabel.text = [self formatedTime:seconds];
  } else {
    NSLog(@"[player] seek began if possible");
    [self seekToSecondsIfPossible:seconds];
  }
}
- (void)seekToSecondsIfPossible:(CGFloat)seconds
{
  BOOL seekable = NO;

  CGFloat time = 0.0;

  if ( seconds<=0 ) {
    time = 1.0;
    seekable = YES;
  } else if ( seconds>_totalTime ) {
    time = (int)_totalTime-1.0;
    seekable = YES;
  } else {
    if ( _timeLimit>0 ) {
      // 有时间限制，看时间是否超过限制
      seekable = (seconds<_timeLimit);
    } else {
      // 无时间限制，一定能 seek
      seekable = YES;
    }
  }

  if ( seekable ) {
    NSLog(@"[player] seek began");
    _seeking = YES;
    [_player pause];
    @weakify(self);
    [_player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
      NSLog(@"[player] seek end: %d", finished);
      @strongify(self);
      self.seeking = NO;
      [self.player play];
    }];
  } else {
    NSLog(@"[player] seek can not");
  }
}

- (void)wardButtonClicked:(FBPlayerWardButton *)sender
{
  if ( !_seeking ) {
    [self seekToSecondsIfPossible:_playedTime+sender.wardValue];
  }
}



- (void)playWithURL:(NSString *)url restricted:(BOOL)restricted
{
  if ( url.length<0 ) { return; }

  [self removeObservers];

  _startPlayingWhenReady = YES;

  if ( restricted ) {
    _timeLimit = FB_PLAYER_DEFAULT_TIME_LIMIT;

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[[NSURL URLWithString:url] fb_customSchemeURL] options:nil];
    _resourceLoader = [[FBPlayerResourceLoader alloc] init];
    [asset.resourceLoader setDelegate:_resourceLoader queue:dispatch_get_main_queue()];

    _playerItem = [AVPlayerItem playerItemWithAsset:asset];
  } else {
    _timeLimit = 0;

    _playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
  }

  if ( !_player ) {
    _player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
  } else {
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
  }

  [_playerLayer removeFromSuperlayer];
  _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
  [self.layer addSublayer:_playerLayer];

  [_infoView showLoading];

  [self addObservers];
}



- (BOOL)playing
{
  if ( (_player.rate<0.0) || (_player.rate>1.0) ) {
    return NO;
  } else {
    if ( ABS(_player.rate-0.0)<DBL_EPSILON ) {
      return NO;
    } else {
      return YES;
    }
  }
  return NO;
}

- (void)playerOrItemStatusChanged
{
  NSMutableString *info = [[NSMutableString alloc] initWithString:@"state: "];
  if ( _player.status==AVPlayerItemStatusUnknown ) {
    [info appendString:@"unknown"];
  } else if ( _player.status==AVPlayerItemStatusReadyToPlay ) {
    [info appendString:@"ready to play"];
  } else if ( _player.status==AVPlayerItemStatusFailed ) {
    [info appendString:@"failed"];
  }
  if ( _playerItem.status==AVPlayerStatusUnknown ) {
    [info appendString:@", unknown"];
  } else if ( _playerItem.status==AVPlayerStatusReadyToPlay ) {
    [info appendString:@", ready to play"];
  } else if ( _playerItem.status==AVPlayerStatusFailed ) {
    [info appendString:@", failed"];
  }
  NSLog(@"[player] %@", info);

  if ( (_player.status==AVPlayerStatusFailed) || (_playerItem.status==AVPlayerItemStatusFailed) ) {
    // 任意哪个状态变成错误，禁用界面，让用户不能操作
    NSLog(@"[player] disable ui");
    //_titleView.operable = NO;
    _controlView.operable = NO;
  }
  if ( (_player.status==AVPlayerStatusReadyToPlay) && (_playerItem.status==AVPlayerItemStatusReadyToPlay) ) {
    // 两个都变成就绪
    NSLog(@"[player] enable ui");
    _titleView.operable = YES;
    _controlView.operable = YES;
    if ( (_startPlayingWhenReady) && ![self playing] ) {
      //[_player play];
      @weakify(self);
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.player play];
      });
    }
  }
}

- (void)playOrPauseStatusChanged
{
  if ( [self playing] ) {
    NSLog(@"[player] state: playing");
    self.controlView.playButton.on = NO;
    [self.infoView hide];
  } else {
    NSLog(@"[player] state: paused");
    self.controlView.playButton.on = YES;
  }
}

- (void)itemDidPlayToEndTime:(NSNotification *)noti
{
  NSLog(@"itemDidPlayToEndTime");

  @weakify(self);
  dispatch_async(dispatch_get_main_queue(), ^{
    @strongify(self);
    self.controlView.playButton.on = YES;
    [self.player seekToTime:kCMTimeZero];
  });
}
- (void)itemFailedToPlayToEndTime:(NSNotification *)noti
{
  NSLog(@"itemFailedToPlayToEndTime");
}
//- (void)itemPlaybackStalled:(NSNotification *)noti
//{
//  NSLog(@"itemPlaybackStalled");
//  [_infoView showLoading];
//}
//- (void)itemTimeJumped:(NSNotification *)noti
//{
//  NSLog(@"itemTimeJumped");
//}
//- (void)itemNewErrorLogEntry:(NSNotification *)noti
//{
//  AVPlayerItemErrorLog *errorLog = _playerItem.errorLog;
//  NSLog(@"itemNewErrorLogEntry %@", errorLog);
//}
//- (void)itemNewAccessLogEntry:(NSNotification *)noti
//{
//  AVPlayerItemAccessLog *accessLog = _playerItem.accessLog;
//  NSLog(@"itemNewAccessLogEntry %@", accessLog);
//}

- (void)didEnterBackground:(NSNotification *)noti
{
  [_player pause];
  [_resourceLoader stopLoading];
}
- (void)willEnterForeground:(NSNotification *)noti
{
  [_resourceLoader resumeLoading];
}




- (NSString *)formatedTime:(NSInteger)time
{
  int left = (int)time;
  int hours = left / 3600;
  left = left % 3600;
  int minutes = left / 60;
  left = left % 60;
  int seconds = left;
  if ( hours>0 ) {
    // 1:02:03
    return [[NSString alloc] initWithFormat:@"%d:%02d:%02d", hours, minutes, seconds];
  } else {
    if ( minutes>0 ) {
      // 02:03
      return [[NSString alloc] initWithFormat:@"%02d:%02d", minutes, seconds];
    } else {
      // 00:03
      return [[NSString alloc] initWithFormat:@"00:%02d", seconds];
    }
  }
  return @"--:--";
}

- (BOOL)timeLimitExceeded:(CGFloat)seconds
{
  if ( (_timeLimit>0) && (_timeLimit<=(NSInteger)seconds) ) {
    // 非会员播放超过时间了，停止。
    return YES;
  }
  return NO;
}

//- (void)loader:(FBPlayerResourceLoader *)loader didStart:(NSInteger)totalLength
//{}
//- (void)loader:(FBPlayerResourceLoader *)loader didUpdateCache:(NSInteger)length
//{}
//- (void)loader:(FBPlayerResourceLoader *)loader didComplete:(NSError *)error
//{}

@end
