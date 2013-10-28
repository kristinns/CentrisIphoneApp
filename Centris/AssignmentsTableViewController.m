//
//  AssignmentsTableViewController.m
//  Centris
//

#pragma mark - Imports

#import "AssignmentsTableViewController.h"
#import "Assignment+Centris.h"
#import "CentrisManagedObjectContext.h"
#import "CourseInstance.h"
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
@property (nonatomic, strong) NSDate *lastUpdated;
@property (nonatomic) BOOL allAssignments;
@end

@implementation AssignmentsTableViewController

- (IBAction)togglerWasPushed:(UISegmentedControl *)sender {
    self.allAssignments = sender.selectedSegmentIndex == 1;
    [self fetchAssignmentsFromCoreData];
    [self.tableView reloadData];
}

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
    if (!_assignments) _assignments = [[NSMutableArray alloc] init];
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
    self.allAssignments = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
	self.navigationController.navigationBar.translucent = NO;
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
        [self fetchAssignmentsFromAPIForUserWithSSN:nil];
    }
}

// Will do a fetch request to Core data and add the assignments
// (if any) to self.assignments
- (void )fetchAssignmentsFromCoreData
{
    // TODO, check toggler
    if (self.allAssignments == YES) {
        self.assignments = [Assignment assignmentsInManagedObjectContext:[[CentrisManagedObjectContext sharedInstance] managedObjectContext]];
    } else {
        NSDate *today = [NSDate date];
        self.assignments = [Assignment assignmentsWithDueDateThatExceeds:today
                                                  inManagedObjectContext:[[CentrisManagedObjectContext sharedInstance] managedObjectContext]];

    }
}

// Will do a fetch request to the API for assignments
// and add the assignments (if any) to self.assignments
-(void)fetchAssignmentsFromAPIForUserWithSSN:(NSString *)SSN
{
//    dispatch_queue_t fetchQ = dispatch_queue_create("Centris Fetch", NULL);
//    dispatch_async(fetchQ, ^{
//        NSArray *apiAssignments = [self.dataFetcher getAssignmentsForUserWithSSN:SSN];
//        [[[CentrisManagedObjectContext sharedInstance] managedObjectContext] performBlock:^{
//            for (NSDictionary *assignment in apiAssignments) {
//                [Assignment addAssignmentWithCentrisInfo:assignment
//                                  inManagedObjectContext:[[CentrisManagedObjectContext sharedInstance] managedObjectContext]];
//            }
//            [self fetchAssignmentsFromCoreData];
//            [self.tableView reloadData];
//        }];
//    });
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assignments count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.allAssignments == YES)
        return [self.courses count];
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AssignmentCell";
    AssignmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Assignment *assignment = [self.assignments objectAtIndex:indexPath.row];
    cell.titleLabel.text = assignment.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateFormat = @"d. MMMM HH:mm";
    cell.dateLabel.text = [formatter stringFromDate:assignment.dateClosed];
    CourseInstance *courseInst = assignment.isInCourseInstance;
    if (self.allAssignments)
        cell.detailUpperLabel.text = @"7.5";
    else
        cell.detailUpperLabel.text = courseInst.courseID;
    cell.detailLowerLabel.text = [NSString stringWithFormat:@"%@%%", assignment.weight];
    cell.displayGrade = self.allAssignments;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.allAssignments == YES)
        return SECTION_HEIGHT;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.allAssignments == YES) {
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
