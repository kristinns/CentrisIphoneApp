//
//  AssignmentsTableViewController.m
//  Centris
//

#pragma mark - Imports

#import "AssignmentsTableViewController.h"
#import "DataFetcher.h"
#import "AppFactory.h"
#import "AssignmentDetailViewController.h"

#pragma mark - Interface

@interface AssignmentsTableViewController () <UITableViewDataSource>
@property (nonatomic, strong) NSArray *assignments;
@property (nonatomic, strong) NSArray *assignmentCourses;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@end

@implementation AssignmentsTableViewController

#pragma mark - Getters
// Getter for assignmentCourses, uses lazy instantiation
- (NSArray *)assignmentCourses
{
    // Get data from CentrisDataFetcher
    if (!_assignmentCourses) _assignmentCourses = [self.dataFetcher getAssignmentCourses];
    
    return _assignmentCourses;
}
// Getter for assignments, uses lazy instantiation
- (NSArray *)assignments
{
    // Get data from CentrisDataFetcher
    if (!_assignments) _assignments = [self.dataFetcher getAssignments];
    
    return _assignments;
}

- (id<DataFetcher>)dataFetcher
{
	if (!_dataFetcher) {
		_dataFetcher = [AppFactory getFetcherFromConfiguration];
	}
	return _dataFetcher;
}

#pragma mark - Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Change title for navigation controller
    self.title = @"Verkefni";
	// set the header color
	self.navigationController.navigationBar.barTintColor = [CentrisTheme navigationBarColor];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Table methods

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

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"assignmentDetailSegue"]) {
        //NSString *title = [[self.assignments objectAtIndex:self.tableView.indexPathForSelectedRow.row] valueForKey:@"title"];
        //[segue.destinationViewController setAssignmentTitle:title];
    }
}

@end
