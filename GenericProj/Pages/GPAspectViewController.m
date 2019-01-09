//
//  GPAspectViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 9/12/17.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPAspectViewController.h"

@implementation GPAspectViewController

#ifdef DEBUG
- (void)dealloc
{
  XYZPrintMethod();
}
#endif

- (BOOL)shouldLoadContentView
{
  return NO;
}


- (void)viewDidLoad
{
  [super viewDidLoad];

  [self aspect_hookSelector:@selector(viewWillAppear:)
                withOptions:AspectPositionAfter | AspectOptionAutomaticRemoval
                 usingBlock:^{ NSLog(@"called view will appear, execute only once"); }
                      error:NULL];
}

- (IBAction)pushButtonClicked:(id)sender
{
  UIViewController *vc = [[UIViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
