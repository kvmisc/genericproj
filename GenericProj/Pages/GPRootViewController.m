//
//  GPRootViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 8/8/16.
//  Copyright © 2016 firefly.com. All rights reserved.
//

#import "GPRootViewController.h"

#import "GPTestViewController.h"

#import "GPRuntimeViewController.h"
#import "GPObjcViewController.h"
#import "GPRedrawViewController.h"
#import "GPHierarchyViewController.h"
#import "GPRestructureViewController.h"
#import "GPMessageViewController.h"
#import "GPHTTPViewController.h"
#import "GPDownloadViewController.h"
#import "GPAspectViewController.h"
#import "GPKVOViewController.h"
#import "GPDatabaseViewController.h"
#import "GPCoverViewController.h"
#import "GPImageViewController.h"
#import "GPTableViewController.h"
#import "GPCollectionViewController.h"
#import "GPNavigationTransitionViewController.h"


@implementation GPRootViewController {
  NSArray *_sampleAry;

  NSString *_defaultPage;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [UITableViewCell tk_registerInTableView:_tableView hasNib:NO];

  _sampleAry = [[NSMutableArray alloc] init];

  [self addTitle:@"Test" class:[GPTestViewController class]];
  [self addTitle:@"Runtime" class:[GPRuntimeViewController class]];
  [self addTitle:@"Objc" class:[GPObjcViewController class]];
  [self addTitle:@"Redraw" class:[GPRedrawViewController class]];
  [self addTitle:@"Hierarchy" class:[GPHierarchyViewController class]];
  [self addTitle:@"Restructure" class:[GPRestructureViewController class]];
  [self addTitle:@"Message" class:[GPMessageViewController class]];
  [self addTitle:@"HTTP" class:[GPHTTPViewController class]];
  [self addTitle:@"Download" class:[GPDownloadViewController class]];
  [self addTitle:@"Aspect" class:[GPAspectViewController class]];
  [self addTitle:@"KVO" class:[GPKVOViewController class]];
  [self addTitle:@"Database" class:[GPDatabaseViewController class]];
  [self addTitle:@"Cover" class:[GPCoverViewController class]];
  [self addTitle:@"Image" class:[GPImageViewController class]];
  [self addTitle:@"TableView" class:[GPTableViewController class]];
  [self addTitle:@"CollectionView" class:[GPCollectionViewController class]];
  [self addTitle:@"NavigationTransition" class:[GPNavigationTransitionViewController class]];

//  _defaultPage = @"Test";
}

- (void)addTitle:(NSString *)title class:(Class)cls
{
  [(NSMutableArray *)_sampleAry addObject:@{ @"title":title, @"class":NSStringFromClass(cls) }];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];

  if ( _defaultPage.length>0 ) {
    NSDictionary *map = [_sampleAry tk_objectForKeyPath:@"title" equalTo:_defaultPage];
    if ( map ) {
      Class cls = NSClassFromString(map[@"class"]);
      UIViewController *vc = [[cls alloc] init];
      [self.navigationController pushViewController:vc animated:YES];
    }
  }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_sampleAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];

  NSDictionary *map = [_sampleAry objectAtIndex:indexPath.row];

  cell.textLabel.text = map[@"title"];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSDictionary *map = [_sampleAry objectAtIndex:indexPath.row];
  Class cls = NSClassFromString(map[@"class"]);
  UIViewController *vc = [[cls alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
