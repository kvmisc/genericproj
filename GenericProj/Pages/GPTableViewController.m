//
//  GPTableViewController.m
//  GenericProj
//
//  Created by Haiping Wu on 2018/4/13.
//  Copyright © 2018 firefly.com. All rights reserved.
//

#import "GPTableViewController.h"
#import "GPTableViewCell.h"

@interface GPTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GPTableViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [GPTableViewCell tk_registerInTableView:_tableView hasNib:YES];

  _tableView.rowHeight = UITableViewAutomaticDimension;
  _tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  GPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GPTableViewCell" forIndexPath:indexPath];
  if ( indexPath.row==0 ) {
    cell.infoLabel.text = @"In your UITableViewCell subclass";
  } else if ( indexPath.row==1 ) {
    cell.infoLabel.text = @"add constraints so that the subviews of the cell have their edges pinned to the edges of the cell's contentView (most importantly to the top AND bottom edges). NOTE: don't pin subviews to the cell itself;";
  } else if ( indexPath.row==2 ) {
    cell.infoLabel.text = @"Remember, the idea is to have the cell's subviews connected vertically to the cell's content view so that they can \"exert pressure\" and make the content view expand to fit them. Using an example cell with a few subviews, here is a visual illustration of what some (not all!) of your constraints would need to look like";
  } else if ( indexPath.row==3 ) {
    cell.infoLabel.text = @"If you're adding constraints in code";
  } else if ( indexPath.row==4 ) {
    cell.infoLabel.text = @"For every unique set of constraints in the cell, use a unique cell reuse identifier.";
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
