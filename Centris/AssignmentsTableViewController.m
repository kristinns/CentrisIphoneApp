//
//  AssignmentsTableViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 8/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentsTableViewController.h"

@interface AssignmentsTableViewController ()
@property (nonatomic, strong) NSArray *assignments;
@end

@implementation AssignmentsTableViewController

@synthesize assignments = _assignments;

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
    self.title = @"Assignments";
    NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    for(int i=0; i< 10; i++){
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Assignment ", @"title", @"24/3/2012", @"date", nil];
        [stringArray addObject:dict];
    }
    self.assignments = stringArray;
	// Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assignments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Assignment description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.textLabel.text = [[self.assignments objectAtIndex:indexPath.item] valueForKey:@"title"]; //Title
    cell.detailTextLabel.text = [[self.assignments objectAtIndex:indexPath.item] valueForKey:@"date"]; //Date
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
