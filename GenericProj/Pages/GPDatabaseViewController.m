//
//  GPDatabaseViewController.m
//  GenericProj
//
//  Created by Kevin Wu on 24/11/2017.
//  Copyright © 2017 firefly.com. All rights reserved.
//

#import "GPDatabaseViewController.h"

@implementation GPDatabaseViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  NSString *path = TKPathForDocumentResource(@"lemon.db");
  //TKDeleteFileOrDirectory(path);

  FMDatabaseQueue *queue = [[FMDatabaseQueue alloc] initWithPath:path];

  if ( [XYZGlobal migrateDatabase:queue prefix:@"sql_main"] ) {
    NSLog(@"migrate YES");
  } else {
    NSLog(@"migrate NO");
  }

}

@end
