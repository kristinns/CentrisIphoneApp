//
//  AssignmentsTableViewController.m
//  Centris
//

#pragma mark - Imports

#import "AssignmentsTableViewController.h"
#import "Assignment+Centris.h"
#import "CentrisManagedObjectContext.h"
#import "AppFactory.h"
#import "DataFetcher.h"
#import "AssignmentDetailViewController.h"
#import "AssignmentTableViewCell.h"

#define ROW_HEIGHT 61.0
#define SECTION_HEIGHT 26.0

#pragma mark - Interface

@interface AssignmentsTableViewController () <UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *assignments;
@property (nonatomic, strong) NSArray *courses;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@property (nonatomic, strong) NSDate *lastUpdated;
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
- (NSMutableArray *)assignments
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
    NSArray *coreDataAssignments = [self fetchAssignmentsFromCoreData];
    if ([coreDataAssignments count] == 0) { // means there is nothing in core data
        // DO API CALL
        [self fetchAssignmentsFromAPI];
    } else {
        for (Assignment *assignment in coreDataAssignments) {
            [self.assignments addObject:assignment];
        }
    }
}

// Will do a fetch request to Core data and add the assignments
// (if any) to self.assignments
- (NSArray *)fetchAssignmentsFromCoreData
{
    NSDate *today = [NSDate date];
    return [Assignment assignmentsWithDueDateThatExceeds:today
                                   inManagedObjectContext:[[CentrisManagedObjectContext sharedInstance] managedObjectContext]];
}

// Will do a fetch request to the API for assignments
// and add the assignments (if any) to self.assignments
-(void)fetchAssignmentsFromAPI
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Centris Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *apiAssignments = [self.dataFetcher getAssignments];
        [[[CentrisManagedObjectContext sharedInstance] managedObjectContext] performBlock:^{
            for (NSDictionary *assignment in apiAssignments) {
                [self.assignments addObject:[Assignment addAssignmentWithCentrisInfo:assignment
                                                              inManagedObjectContext:[[CentrisManagedObjectContext sharedInstance] managedObjectContext]]];
            }
            [self.tableView reloadData];
        }];
    });
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assignments count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.courses count];
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
    cell.detailUpperLabel.text = @"9.0";
    cell.detailLowerLabel.text = [NSString stringWithFormat:@"%@%%", assignment.weight];
    
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
