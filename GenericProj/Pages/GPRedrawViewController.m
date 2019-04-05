//
//  GPRedrawViewController.m
//  GenericProj
//
//  Created by Haiping Wu on 2019/4/5.
//  Copyright © 2019 firefly.com. All rights reserved.
//

#import "GPRedrawViewController.h"
#import "GPRedrawAAAView.h"
#import "GPRedrawBBBView.h"
#import "GPRedrawCCCView.h"

@implementation GPRedrawViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (IBAction)buttonAction:(id)sender
{
//  UIView *v = [self.view tk_descendantOrSelfWithClass:[GPRedrawAAAView class]];
//  [v setNeedsDisplay];
//  [v setNeedsLayout];

  UIView *v = [self.view tk_descendantOrSelfWithClass:[GPRedrawBBBView class]];
//  [v setNeedsDisplay];
  [v setNeedsLayout];

//  UIView *v = [self.view tk_descendantOrSelfWithClass:[GPRedrawCCCView class]];
//  [v setNeedsDisplayInRect:CGRectMake(10, 10, 20, 20)];
}

@end
