//
//  AssignmentsTableViewController.m
//  Centris
//

#import "AssignmentsTableViewController.h"
#import "CentrisDataFetcher.h"
#import "AssignmentDetailViewController.h"
#import "MFSideMenuContainerViewController.h"

@interface AssignmentsTableViewController ()
@property (nonatomic, strong) NSArray *assignments;
@property (nonatomic, strong) NSArray *assignmentCourses;
@end

@implementation AssignmentsTableViewController

@synthesize assignments = _assignments;

// Get menuContainer ( MFSlideMenuContainer )
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
// Action when clicked on menu button
- (IBAction)showMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Verkefni";
    // Get assignments and courses from CentrisDataFetcher
    self.assignments = [CentrisDataFetcher getAssignments];
    self.assignmentCourses = [CentrisDataFetcher getAssignmentCourses];
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
