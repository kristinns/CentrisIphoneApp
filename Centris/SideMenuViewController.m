//
//  SideMenuViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 8/4/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"

@interface SideMenuViewController ()

@property (nonatomic, strong) NSMutableArray *menuItems;

@end

@implementation SideMenuViewController

// This is for MFSideMenuContainerViewController
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.parentViewController;
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
    
    self.menuItems = [[NSMutableArray alloc] init];
    
    [self.menuItems addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Stundaskrá", @"title", @"ScheduleViewController", @"identifier", nil]];
    [self.menuItems addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Verkefni", @"title", @"AssignmentsTableViewController", @"identifier", nil]];
    [self.menuItems addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Próf", @"title", @"AssignmentsTableViewController", @"identifier", nil]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Menu item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.textLabel.text = [[self.menuItems objectAtIndex:indexPath.item] valueForKey:@"title"]; // Title
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [[self.menuItems objectAtIndex:indexPath.item] valueForKey:@"identifier"];
    UIViewController *frontViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:frontViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end