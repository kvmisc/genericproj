//
//  GPFlowViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 1/11/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPFlowViewController.h"

#import "GPFlowHeadView.h"
#import "GPFlowLineView.h"

@implementation GPFlowViewController

- (void)viewDidLoad
{
  [super viewDidLoad];


  XYZFlowView *flowView = (XYZFlowView *)[self contentView];


  {
    // section body
    XYZFlowSectionView *sectionView = [flowView addSectionView];
    sectionView.yIndex = 9;

    {
      GPFlowLineView *lineView = [GPFlowLineView loadFromNib];
      lineView.colorView.backgroundColor = [UIColor redColor];
      lineView.colorView.tag = 901;
      [sectionView addLineView:lineView];
    }
    {
      GPFlowLineView *lineView = [GPFlowLineView loadFromNib];
      lineView.colorView.backgroundColor = [UIColor greenColor];
      lineView.colorView.tag = 902;
      [sectionView addLineView:lineView];
    }
    {
      GPFlowLineView *lineView = [GPFlowLineView loadFromNib];
      lineView.colorView.backgroundColor = [UIColor blueColor];
      lineView.colorView.tag = 903;
      [sectionView addLineView:lineView];
    }
  }
  {
    // section head
    XYZFlowSectionView *sectionView = [flowView addSectionView];
    sectionView.yIndex = 8;

    GPFlowHeadView *headView = [GPFlowHeadView loadFromNib];
    headView.titleLabel.text = @"8.原来是这";
    [sectionView addLineView:headView];
  }
  {
    // section head
    XYZFlowSectionView *sectionView = [flowView addSectionView];
    sectionView.yIndex = 1;

    GPFlowHeadView *headView = [GPFlowHeadView loadFromNib];
    headView.titleLabel.text = @"1.不可能哟";
    [sectionView addLineView:headView];
  }
  {
    // section body
    XYZFlowSectionView *sectionView = [flowView addSectionView];
    sectionView.yIndex = 2;

    {
      GPFlowLineView *lineView = [GPFlowLineView loadFromNib];
      lineView.colorView.backgroundColor = [UIColor yellowColor];
      lineView.colorView.tag = 201;
      [sectionView addLineView:lineView];
    }
    {
      GPFlowLineView *lineView = [GPFlowLineView loadFromNib];
      lineView.colorView.backgroundColor = [UIColor brownColor];
      lineView.colorView.tag = 202;
      [sectionView addLineView:lineView];
    }
  }

  [flowView layoutSectionViews];
}


- (IBAction)buttonClicked:(id)sender
{
  XYZFlowView *flowView = (XYZFlowView *)[self contentView];

  [flowView removeSectionViewAtIndex:1];

  [flowView layoutSectionViews];
  
}

@end
