//
//  AssignmentsTableViewController.m
//  Centris
//

#import "AssignmentsTableViewController.h"
#import "CentrisDataFetcher.h"
#import "AssignmentDetailViewController.h"

@interface AssignmentsTableViewController () <UITableViewDataSource>
@property (nonatomic, strong) NSArray *assignments;
@property (nonatomic, strong) NSArray *assignmentCourses;
@end

@implementation AssignmentsTableViewController

// Getter for assignmentCourses, uses lazy instantiation
- (NSArray *)assignmentCourses
{
    // Get data from CentrisDataFetcher
    if (!_assignmentCourses) _assignmentCourses = [CentrisDataFetcher getAssignmentCourses];
    
    return _assignmentCourses;
}
// Getter for assignments, uses lazy instantiation
- (NSArray *)assignments
{
    // Get data from CentrisDataFetcher
    if (!_assignments) _assignments = [CentrisDataFetcher getAssignments];
    
    return _assignments;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Change title for navigation controller
    self.title = @"Verkefni";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.assignmentCourses objectAtIndex:section] valueForKey:@"count"] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.assignmentCourses count];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.assignmentCourses objectAtIndex:section] valueForKey:@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Assignment description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.textLabel.text = [[self.assignments objectAtIndex:indexPath.item] valueForKey:@"title"]; // Title
    cell.detailTextLabel.text = [[self.assignments objectAtIndex:indexPath.item] valueForKey:@"date"]; // Date
    // Mark as checked if assignment is finished
    if ([[[self.assignments objectAtIndex:indexPath.item] valueForKey:@"finished"] isEqualToString:@"yes"])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"assignmentDetailSegue"]) {
        //NSString *title = [[self.assignments objectAtIndex:self.tableView.indexPathForSelectedRow.row] valueForKey:@"title"];
        //[segue.destinationViewController setAssignmentTitle:title];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
