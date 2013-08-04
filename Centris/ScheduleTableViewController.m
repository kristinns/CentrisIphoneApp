//
//  ScheduleViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 8/4/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "ScheduleTableViewCell.h"
#import "MFSideMenuContainerViewController.h"

@interface ScheduleTableViewController ()

@end

@implementation ScheduleTableViewController

// This is for MFSideMenuContainerViewController
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}

- (IBAction)showMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Schedule item";
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.fromTime.text = @"9:30";
    cell.toTime.text = @"10:05";
    CGRect bounds = [cell.toTime bounds];
    bounds.origin.y = cell.bounds.size.height-45;
    cell.toTime.bounds = bounds;
    
    NSLog(@"%f, %f", cell.frame.size.height, cell.toTime.bounds.origin.y);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGFloat)(indexPath.row+2) * 20;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
