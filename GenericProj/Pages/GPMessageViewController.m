//
//  GPMessageViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 3/13/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPMessageViewController.h"

#import "GPMessageContentViewController.h"

@implementation GPMessageViewController {
  UIView *_inView;
}

- (BOOL)shouldLoadContentView
{
  return NO;
}

- (IBAction)messageBC:(id)sender
{
  [[self.view tk_findFirstResponder] resignFirstResponder];
}

- (IBAction)sendBC:(id)sender
{
//  NSLog(@"windows: %@", [[UIApplication sharedApplication] windows]);
//  NSLog(@"keyboard: %@", [XYZMessageCenter keyboardWindowOrView:nil]);
//
//  UIView *boxView = [XYZMessageCenter keyboardWindowOrView:nil];
//
//  UIView *blackView = [[UIView alloc] init];
//  blackView.backgroundColor = [UIColor redColor];
//  [boxView addSubview:blackView];
//  blackView.frame = CGRectMake(100, 400, 100, 100);
}

- (IBAction)contentBC:(id)sender
{
  GPMessageContentViewController *vc = [[GPMessageContentViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)ABC:(id)sender
{
//  _inView = [XYZGlobal visibleTopmostWindow];
//  _inView = (_inView?:self.view);

  [XYZMC ATV:_inView viewport:self.pinkView complete:^{ NSLog(@"do_complete"); }];
//  coverView.contentView.marginX = 5.0;
//  coverView.contentView.marginY = -5.0;
}
- (IBAction)BBC:(id)sender
{
//  _inView = [XYZGlobal visibleTopmostWindow];
//  _inView = (_inView?:self.view);

  [XYZMC TXT:_inView text:@"Loading..." viewport:self.pinkView complete:^{ NSLog(@"do_complete"); }];
}
- (IBAction)CBC:(id)sender
{
//  _inView = [XYZGlobal visibleTopmostWindow];
//  _inView = (_inView?:self.view);

  [XYZMC CCL:_inView text:@"Loading..." cancel:^{ NSLog(@"do_cancel"); } viewport:self.pinkView complete:^{ NSLog(@"do_complete"); }];
}
- (IBAction)DBC:(id)sender
{
//  _inView = [XYZGlobal visibleTopmostWindow];
//  _inView = (_inView?:self.view);

  [XYZMC INF:_inView info:@"Your news feed helps you keep up with recent activity on repositories you watch and people you follow." viewport:self.pinkView complete:^{ NSLog(@"do_complete"); }];
}
- (IBAction)hideBC:(id)sender
{
//  _inView = [XYZGlobal visibleTopmostWindow];
//  _inView = (_inView?:self.view);
  
  [XYZMC hideHUD:_inView];
}

@end
