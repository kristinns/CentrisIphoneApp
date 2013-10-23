//
//  AssignmentsTableViewController.m
//  Centris
//

#pragma mark - Imports

#import "AssignmentsTableViewController.h"
#import "AppFactory.h"
#import "DataFetcher.h"
#import "AssignmentDetailViewController.h"
#import "AssignmentTableViewCell.h"

#define ROW_HEIGHT 61.0
#define SECTION_HEIGHT 26.0

#pragma mark - Interface

@interface AssignmentsTableViewController () <UITableViewDataSource>
@property (nonatomic, strong) NSArray *assignments;
@property (nonatomic, strong) NSArray *courses;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@end

@implementation AssignmentsTableViewController

#pragma mark - Getters
// Getter for assignmentCourses, uses lazy instantiation
- (NSArray *)courses
{
    // Get data from CentrisDataFetcher
    if (!_courses) _courses = [self.dataFetcher getAssignmentCourses];
    
    return _courses;
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
		_dataFetcher = [AppFactory fetcherFromConfiguration];
	}
	return _dataFetcher;
}

#pragma mark - Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Change title for navigation controller
    self.title = @"Verkefni";
    self.tableView.backgroundColor = [UIColor whiteColor];
	self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.courses objectAtIndex:section] valueForKey:@"count"] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AssignmentCell";
    AssignmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 1)
        cell.assignmentEventState = AssignmentIsFinished;
    // Configure the cell
    //cell.textLabel.text = [[self.assignments objectAtIndex:indexPath.item] valueForKey:@"title"]; // Title
    //cell.detailTextLabel.text = [[self.assignments objectAtIndex:indexPath.item] valueForKey:@"date"]; // Date
    // Mark as checked if assignment is finished
    //if ([[[self.assignments objectAtIndex:indexPath.item] valueForKey:@"finished"] isEqualToString:@"yes"])
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(15, 0, tableView.bounds.size.width-15, 26);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [CentrisTheme grayLightColor];
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:frame];
    sectionHeader.textColor = [CentrisTheme grayLightTextColor];
    sectionHeader.font = [CentrisTheme headingSmallFont];
    sectionHeader.text = [[[self.courses objectAtIndex:section] valueForKey:@"title"] uppercaseString];
    [view addSubview:sectionHeader];
    return view;
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
