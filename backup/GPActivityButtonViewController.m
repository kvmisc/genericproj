//
//  GPActivityButtonViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 1/12/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPActivityButtonViewController.h"

@interface GPActivityButtonViewController ()

@property (weak, nonatomic) IBOutlet XYZActivityButton *activityButton;

@property (nonatomic, copy) xyz_cancelable_block_t block;

@end



@implementation GPActivityButtonViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  _activityButton.saveAndClearStatus = ^(XYZActivityButton *button, NSMutableDictionary *statusMap) {
    if ( TK_S_NONEMPTY(button.normalTitle) ) {
      [statusMap setObject:button.normalTitle forKey:@"normalTitle"];
    }
    button.normalTitle = nil;
  };
  _activityButton.restoreStatus = ^(XYZActivityButton *button, NSMutableDictionary *statusMap) {
    button.normalTitle = [statusMap objectForKey:@"normalTitle"];
    [statusMap removeObjectForKey:@"normalTitle"];
  };

}


- (BOOL)shouldLoadContentView
{
  return NO;
}



- (IBAction)buttonClicked:(id)sender
{
  XYZActivityButton *button = sender;

  if ( !button.animating ) {
    button.animating = YES;
    [self doSomething];
  }
}

- (void)doSomething
{
  @weakify(self);
  self.block = xyz_dispatch_after_delay(5.0, ^{
    @strongify(self);
    XYZLogDebug(@"activity", @"should not execute if view controller been popped");
    self.activityButton.animating = NO;
  });
}



- (void)destroyActivities
{
  xyz_cancel_block(_block);
}



- (void)dealloc
{
  XYZLogDebug(@"activity", @"dealloc");
}

@end
