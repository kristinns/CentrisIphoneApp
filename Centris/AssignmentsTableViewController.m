//
//  AssignmentsTableViewController.m
//  Centris
//

#pragma mark - Imports

#import "AssignmentsTableViewController.h"
#import "Assignment+Centris.h"
#import "Semester+Centris.h"
#import "CourseInstance.h"
#import "AppFactory.h"
#import "DataFetcher.h"
#import "AssignmentDetailViewController.h"
#import "AssignmentTableViewCell.h"
#import "CourseInstance+Centris.h"
#import "AssignmentDetailViewController.h"
#import "TestFlight.h"

#define ROW_HEIGHT 61.0
#define SECTION_HEIGHT 26.0
#define PADDING_VERTICAL 15.0

#pragma mark - Interface
@interface AssignmentsTableViewController () <UITableViewDataSource>
@property (nonatomic, strong) NSArray *assignments;
@property (nonatomic, strong) NSArray *courses;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (nonatomic) BOOL allAssignments;
@end

@implementation AssignmentsTableViewController

- (IBAction)togglerWasPushed:(UISegmentedControl *)sender {
    self.allAssignments = sender.selectedSegmentIndex == 1; // True if All assignment is selected which has index 1
    [self fetchAssignmentsFromCoreData];
    [self.tableView reloadData];
}

#pragma mark - Properties
- (NSArray *)courses
{
    // Get data from CentrisDataFetcher
    if (!_courses) {
        // Get courses from last semester
        Semester *semester = [[Semester semestersInManagedObjectContext:[AppFactory managedObjectContext]] lastObject];
        _courses = [CourseInstance courseInstancesInSemester:semester inManagedObjectContext:[AppFactory managedObjectContext]];
    }
    return _courses;
}

- (NSArray *)assignments
{
    // Get data from CentrisDataFetcher
    if (!_assignments)
        _assignments = [[NSMutableArray alloc] init];
    return _assignments;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.refreshControl addTarget:self action:@selector(userDidRefresh) forControlEvents:UIControlEventValueChanged];
    // Change title for navigation controller
    self.title = @"Verkefni";
    self.allAssignments = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchAssignmentsFromCoreData];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"assignmentDetailViewSegue"]) {
        AssignmentDetailViewController *assignmentDetailViewController = [segue destinationViewController];
        Assignment *selectedAssignment;
        if (self.allAssignments) {
            CourseInstance *selectedCourseInstance = [self.courses objectAtIndex:self.tableView.indexPathForSelectedRow.section];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateClosed" ascending:YES];
            NSArray *sortedAssignmentList = [selectedCourseInstance.hasAssignments sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            selectedAssignment = [sortedAssignmentList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        } else {
            selectedAssignment = [self.assignments objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        }
        assignmentDetailViewController.assignment = selectedAssignment;
    }
}

#pragma mark - UITableViewDataSource
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.allAssignments == YES)
        return SECTION_HEIGHT;
    else
        return 0.5;
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

#pragma mark - Refresh Control
// Will do a fetch request to Core data and add the assignments
// (if any) to self.assignments
- (void )fetchAssignmentsFromCoreData
{
    if ([self viewNeedsToBeUpdated]) {
        // update last updated
        [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:ASSIGNMENT_LAST_UPDATED];
        [self fetchAssignmentsFromAPI];
    }
    if (self.allAssignments == YES) {
        self.assignments = [Assignment assignmentsInManagedObjectContext:[AppFactory managedObjectContext]];
    } else {
        NSDate *today = [NSDate date];
        self.assignments = [Assignment assignmentsWithDueDateThatExceeds:today
                                                  inManagedObjectContext:[AppFactory managedObjectContext]];
    }
    [self.tableView reloadData];
}

// Will do a fetch request to the API for assignments
// and add the assignments (if any) to self.assignments
- (void)fetchAssignmentsFromAPI
{
    [self.refreshControl beginRefreshing];
    [[AppFactory dataFetcher] getAssignmentsInSemester:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got %d assignments", [responseObject count]);
        [Assignment addAssignmentsWithCentrisInfo:responseObject inManagedObjectContext:[AppFactory managedObjectContext]];
        // call success block if any
        [self fetchAssignmentsFromCoreData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting assignments");
        [self.refreshControl endRefreshing];
    }];
}

// Will compare current date to the saved date in NSUserDefaults. If that date is older than 2 hours it will return YES.
// If that date in NSUserDefaults does not exists, it will return YES. Otherwiese, NO.
- (BOOL)viewNeedsToBeUpdated
{
    NSDate *now = [NSDate date];
    NSDate *lastUpdated = [[AppFactory sharedDefaults] objectForKey:ASSIGNMENT_LAST_UPDATED];
    if (!lastUpdated) { // does not exists, so the view should better update.
        return YES;
    } else if ([now timeIntervalSinceDate:lastUpdated] >= [[[AppFactory configuration] objectForKey:@"defaultUpdateTimeIntervalSeconds"] integerValue]) { // if the time since is more than 2 hours
        return YES;
    } else {
        return NO;
    }
}

-(void)userDidRefresh
{
    [TestFlight passCheckpoint:@"User did refresh Assignment list"];
    [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:ASSIGNMENT_LAST_UPDATED];
    [self fetchAssignmentsFromAPI];
}

@end
