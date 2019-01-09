//
//  XYZFlowView.m
//  GenericProj
//
//  Created by Kevin Wu on 1/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "XYZFlowView.h"

@implementation XYZFlowView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self initialize];
  }
  return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
  return YES;
}



- (void)initialize
{
  self.translatesAutoresizingMaskIntoConstraints = NO;

  _contentView = [[UIView alloc] init];
  _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  _contentView.backgroundColor = [UIColor clearColor];
  [self addSubview:_contentView];

  @weakify(self);
  [RACObserve(self, contentOffset) subscribeNext:^(id x) {
    @strongify(self);
    XYZLogInfo(@"FlowView", @"content offset: %f %f", self.contentOffset.x, self.contentOffset.y);
  }];
}


- (XYZFlowSectionView *)addSectionView
{
  XYZFlowSectionView *sectionView = [[XYZFlowSectionView alloc] init];
  [_contentView addSubview:sectionView];
  return sectionView;
}


- (void)removeSectionViewAtIndex:(NSUInteger)idx
{
  NSArray *sortedAry = [self sortedSectionViews];
  XYZFlowSectionView *sectionView = [sortedAry objectOrNilAtIndex:idx];
  [sectionView removeFromSuperview];
}

- (void)removeAllSectionViews
{
  [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}



- (NSArray *)sortedSectionViews
{
  return [_contentView.subviews sortedArrayUsingComparator:^NSComparisonResult(XYZFlowSectionView *bv1, XYZFlowSectionView *bv2) {
    if ( bv1.yIndex<bv2.yIndex ) {
      return NSOrderedAscending;
    }
    return NSOrderedDescending;
  }];
}

- (void)layoutSectionViews
{
  NSArray *sortedAry = [self sortedSectionViews];

  for ( NSUInteger i=0; i<[sortedAry count]; ++i ) {
    UIView *sectionView = [sortedAry objectAtIndex:i];
    [sectionView sendToBack];
  }

  [self setNeedsUpdateConstraints];
}


- (void)updateConstraints
{
  @weakify(self);

  [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.edges.equalTo(self);
    make.width.equalTo(self);
  }];


  NSArray *sortedAry = [self sortedSectionViews];

  CGFloat height = 0.0;

  UIView *prevView = nil;
  for ( NSUInteger i=0; i<[sortedAry count]; ++i ) {

    UIView *itemView = [sortedAry objectAtIndex:i];

    CGSize size = [itemView intrinsicContentSize];
    if ( size.height>0.0 ) {
      height += size.height;
    }

    [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.top.equalTo(prevView ? prevView.mas_bottom : self.contentView.mas_top);
      make.left.right.equalTo(self.contentView);
    }];
    prevView = itemView;
  }

  [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@(height)).priorityLow();
    if ( prevView ) {
      // 有内容才让视图能滑动
      make.height.greaterThanOrEqualTo(self.mas_height).offset(1.0);
    }
  }];

  [super updateConstraints];
}

@end



@implementation XYZFlowSectionView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self initialize];
  }
  return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
  return YES;
}



- (void)initialize
{
  self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (CGSize)intrinsicContentSize
{
  CGFloat height = 0.0;
  for ( UIView *lineView in _lineAry ) {
    CGSize size = [lineView intrinsicContentSize];
    if ( size.height>0.0 ) {
      height += size.height;
    }
  }
  return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

- (void)setLineAry:(NSMutableArray *)lineAry
{
  [_lineAry makeObjectsPerformSelector:@selector(removeFromSuperview)];
  _lineAry = nil;

  if ( TK_A_NONEMPTY(lineAry) ) {

    _lineAry = [[NSMutableArray alloc] init];

    for ( NSUInteger i=0; i<[lineAry count]; ++i ) {
      UIView *lineView = [lineAry objectAtIndex:i];
      [(NSMutableArray *)_lineAry addObject:lineView];
      [lineView removeFromSuperview];
      [self addSubview:lineView];
    }
  }
}

- (void)addLineView:(UIView *)lineView
{
  if ( lineView ) {

    if ( !_lineAry ) {
      _lineAry = [[NSMutableArray alloc] init];
    }

    [(NSMutableArray *)_lineAry addObject:lineView];
    [lineView removeFromSuperview];
    [self addSubview:lineView];
  }
}

- (void)updateConstraints
{
  @weakify(self);
  UIView *prevView = nil;
  for ( NSUInteger i=0; i<[_lineAry count]; ++i ) {

    UIView *lineView = [_lineAry objectAtIndex:i];

    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.top.equalTo(prevView ? prevView.mas_bottom : self.mas_top);
      make.left.right.equalTo(self);
    }];
    prevView = lineView;
  }

  [super updateConstraints];
}

@end
