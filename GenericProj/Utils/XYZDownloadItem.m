//
//  XYZDownloadItem.m
//  GenericProj
//
//  Created by Kevin Wu on 31/10/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZDownloadItem.h"

@implementation XYZDownloadItem

#ifdef DEBUG
- (void)dealloc { XYZPrintMethod(); }
#endif

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if (self) {
    _url = [[coder decodeObjectForKey:@"kUrl"] copy];
    _status = [coder decodeIntegerForKey:@"kStatus"];
    NSNumber *totalUnit = [coder decodeObjectForKey:@"kTotalUnit"];
    NSNumber *completedUnit = [coder decodeObjectForKey:@"kCompletedUnit"];
    if ( totalUnit && completedUnit ) {
      _progress = [NSProgress progressWithTotalUnitCount:[totalUnit unsignedIntegerValue]];
      _progress.completedUnitCount = [completedUnit unsignedIntegerValue];
    }
    _destinationFile = [[coder decodeObjectForKey:@"kDestinationFile"] copy];
    _temporaryFile = [[coder decodeObjectForKey:@"kTemporaryFile"] copy];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:_url forKey:@"kUrl"];
  [coder encodeInteger:_status forKey:@"kStatus"];
  if ( _progress ) {
    NSNumber *totalUnit = [NSNumber numberWithUnsignedInteger:(NSUInteger)(_progress.totalUnitCount)];
    [coder encodeObject:totalUnit forKey:@"kTotalUnit"];
    NSNumber *completedUnit = [NSNumber numberWithUnsignedInteger:(NSUInteger)(_progress.completedUnitCount)];
    [coder encodeObject:completedUnit forKey:@"kCompletedUnit"];
  }
  [coder encodeObject:_destinationFile forKey:@"kDestinationFile"];
  [coder encodeObject:_temporaryFile forKey:@"kTemporaryFile"];
}

- (void)setUpProgressAndSpeed:(NSProgress *)progress
{
  if ( !_progress ) {
    XYZLog(@"[down][%p][progress] old[nil]: 0/0, new[%p]: %lld/%lld", self, progress, progress.completedUnitCount, progress.totalUnitCount);
    // 前一个进度为空，不能算出速度，速度为 0
    _speed = 0;
    _progress = progress;
    _lastReceiveDate = [NSDate date];
  } else {
    if ( !progress ) {
      XYZLog(@"[down][%p][progress] old[%p]: %lld/%lld, new[nil]: 0/0", self, _progress, _progress.completedUnitCount, _progress.totalUnitCount);
      // 进度为空，应该是下载结束，速度为 0
      _speed = 0;
      _progress = nil;
      _lastReceiveDate = nil;
    } else {
      XYZLog(@"[down][%p][progress] old[%p]: %lld/%lld, new[%p]: %lld/%lld", self, _progress, _progress.completedUnitCount, _progress.totalUnitCount, progress, progress.completedUnitCount, progress.totalUnitCount);
      NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:_lastReceiveDate];
      NSUInteger unit = (NSUInteger)(progress.completedUnitCount - _progress.completedUnitCount);
      _speed = (unit / time);
      _progress = progress;
      _lastReceiveDate = [NSDate date];

    }
  }
}

@end
