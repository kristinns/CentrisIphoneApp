//
//  AssignmentsTableViewController.m
//  Centris
//

#pragma mark - Imports

#import "AssignmentsTableViewController.h"
#import "Assignment+Centris.h"
#import "CourseInstance.h"
#import "AppFactory.h"
#import "DataFetcher.h"
#import "AssignmentDetailViewController.h"
#import "AssignmentTableViewCell.h"
#import "CourseInstance+Centris.h"

#define ROW_HEIGHT 61.0
#define SECTION_HEIGHT 26.0
#define PADDING_VERTICAL 15.0

#pragma mark - Interface

@interface AssignmentsTableViewController () <UITableViewDataSource>
@property (nonatomic, strong) NSArray *assignments;
@property (nonatomic, strong) NSArray *courses;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (nonatomic) BOOL allAssignments;
@end

@implementation AssignmentsTableViewController

- (IBAction)togglerWasPushed:(UISegmentedControl *)sender {
    self.allAssignments = sender.selectedSegmentIndex == 1; // True if All assignment is selected which has index 1
    [self fetchAssignmentsFromCoreData];
    [self.tableView reloadData];
}

#pragma mark - Getters
// Getter for assignmentCourses, uses lazy instantiation
- (NSArray *)courses
{
    // Get data from CentrisDataFetcher
    if (!_courses)
        _courses = [CourseInstance courseInstancesInManagedObjectContext:[AppFactory managedObjectContext]];
    return _courses;
}

// Getter for assignments, uses lazy instantiation
- (NSArray *)assignments
{
    // Get data from CentrisDataFetcher
    if (!_assignments)
        _assignments = [[NSMutableArray alloc] init];
    return _assignments;
}

- (id<DataFetcher>)dataFetcher
{
	if (!_dataFetcher)
		_dataFetcher = [AppFactory fetcherFromConfiguration];
	return _dataFetcher;
}

#pragma mark - Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(userDidRefresh) forControlEvents:UIControlEventValueChanged];
    // Change title for navigation controller
    self.title = @"Verkefni";
    self.allAssignments = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setupAssignments];
}

#pragma mark - Methods

// Function that gets called when there is nothing in the database or
// when the user decides to update the information by manually refreshing.
-(void)reloadData
{
    // TODO
    return;
}

- (void)setupAssignments
{
    [self fetchAssignmentsFromCoreData];
    if ([self.assignments count] == 0) { // means there is nothing in core data
        // DO API CALL
        [self fetchAssignmentsFromAPI];
    }
}

// Will do a fetch request to Core data and add the assignments
// (if any) to self.assignments
- (void )fetchAssignmentsFromCoreData
{
    // TODO, check toggler
    if (self.allAssignments == YES) {
        self.assignments = [Assignment assignmentsInManagedObjectContext:[AppFactory managedObjectContext]];
    } else {
        NSDate *today = [NSDate date];
        self.assignments = [Assignment assignmentsWithDueDateThatExceeds:today
                                                  inManagedObjectContext:[AppFactory managedObjectContext]];
    }
}

// Will do a fetch request to the API for assignments
// and add the assignments (if any) to self.assignments
-(void)fetchAssignmentsFromAPI
{
    [self.dataFetcher getAssignmentsInSemester:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got %d assignments", [responseObject count]);
        for (NSDictionary *assignment in responseObject) {
            [Assignment addAssignmentWithCentrisInfo:assignment withCourseInstanceID:[assignment[@"CourseInstanceID"] integerValue] inManagedObjectContext:[AppFactory managedObjectContext]];
        }
        
        [self fetchAssignmentsFromCoreData];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting assignments");
    }];
}

#pragma mark - Table delegate methods

-(void)userDidRefresh
{
    
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.allAssignments == NO)
        return [self.assignments count];
    else {
        CourseInstance *courseInstance = [self.courses objectAtIndex:section];
        return [courseInstance.hasAssignments count];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.allAssignments == YES)
        return [self.courses count];
    else // If showing next assignments there is only one section
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AssignmentCell";
    AssignmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Assignment *assignment;
    if (self.allAssignments == NO)
    {
        assignment = [self.assignments objectAtIndex:indexPath.row];
        cell.detailUpperLabel.text = assignment.isInCourseInstance.courseID;
    } else {
        CourseInstance *courseInstance = [self.courses objectAtIndex:indexPath.section];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateClosed" ascending:YES];
        NSArray *sortedAssignmentList = [courseInstance.hasAssignments sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
        assignment = [sortedAssignmentList objectAtIndex:indexPath.row];
        if (assignment.grade != nil)
            cell.detailUpperLabel.text = [NSString stringWithFormat:@"%.1f", [assignment.grade floatValue]];
        else
            cell.detailUpperLabel.text = @"";
    }
    
    cell.titleLabel.text = assignment.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateFormat = @"d. MMMM HH:mm";
    cell.dateLabel.text = [formatter stringFromDate:assignment.dateClosed];
    cell.detailLowerLabel.text = [NSString stringWithFormat:@"%@%%", assignment.weight];
    cell.displayGrade = self.allAssignments;
    if (assignment.handInDate != nil)
        cell.assignmentEventState = AssignmentWasHandedIn;
    else
        cell.assignmentEventState = AssignmentWasNotHandedIn;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.allAssignments == YES)
        return SECTION_HEIGHT;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.allAssignments == YES) {
        CGRect frame = CGRectMake(PADDING_VERTICAL, 0, tableView.bounds.size.width-PADDING_VERTICAL, SECTION_HEIGHT);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [CentrisTheme grayLightColor];
        UILabel *sectionHeader = [[UILabel alloc] initWithFrame:frame];
        sectionHeader.textColor = [CentrisTheme grayLightTextColor];
        sectionHeader.font = [CentrisTheme headingSmallFont];
        sectionHeader.text = [[[self.courses objectAtIndex:section] name] uppercaseString];
        [view addSubview:sectionHeader];
        return view;
    }
    else
        return nil;
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
