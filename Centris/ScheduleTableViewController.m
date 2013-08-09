//
//  ScheduleViewController.m
//  Centris
//

#import "ScheduleTableViewController.h"
#import "ScheduleTableViewCell.h"
#import "MFSideMenuContainerViewController.h"

@interface ScheduleTableViewController ()
@property NSMutableArray *timeTable;
@end

@implementation ScheduleTableViewController

@synthesize timeTable;

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
    
    // Remove border from table cells
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Top margin, move table 20 px down
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    // Title
    self.title = @"Stundaskrá";
	
    // Timetablefrom MySchool
    self.timeTable = [[NSMutableArray alloc] init];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@" 8:30", @"fromTime", @" 9:15", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"5", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@" 9:20", @"fromTime", @"10:05", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"15", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"10:20", @"fromTime", @"11:05", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"5", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"11:10", @"fromTime", @"11:55", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"12:00", @"fromTime", @"", @"toTime", @"25", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"12:20", @"fromTime", @"13:05", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"5", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"13:10", @"fromTime", @"13:55", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"5", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"14:00", @"fromTime", @"14:45", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"10", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"14:55", @"fromTime", @"15:40", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"5", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"15:45", @"fromTime", @"16:30", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"5", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"16:35", @"fromTime", @"17:20", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"5", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"17:25", @"fromTime", @"18:10", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"5", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"18:15", @"fromTime", @"19:00", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"5", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"19:05", @"fromTime", @"", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"19:50", @"fromTime", @"20:35", @"toTime", @"45", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"", @"fromTime", @"", @"toTime", @"5", @"duration", nil]];
    [self.timeTable addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"20:40", @"fromTime", @"21:45", @"toTime", @"45", @"duration", nil]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns timeTable property length
    return [self.timeTable count];
}
// Configure each cell, this function is called for each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get cell from storyboard by identifier
    static NSString *CellIdentifier = @"Schedule item";
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.fromTime.text = [[self.timeTable objectAtIndex:indexPath.item] valueForKey:@"fromTime"];
    cell.toTime.text = @"";//[[self.timeTable objectAtIndex:indexPath.item] valueForKey:@"toTime"];
    // Configure toTime position, first get the bounds
    CGRect bounds = [cell.toTime bounds];
    // Then resize the height
    bounds.origin.y = cell.bounds.size.height-37; // Not sure why 37 works here
    // Assign the new bounds with the new height
    cell.toTime.bounds = bounds;
    //NSLog(@"%f, %f", cell.frame.size.height, cell.toTime.bounds.origin.y);
    
    // These are just for demo
    if (indexPath.row == 0 || indexPath.row == 2) {
        cell.booking.hidden = NO;
        cell.bookingTitle.text = @"Markaðsfræði";
    }
    
    if (indexPath.row == 4 || indexPath.row == 6) {
        cell.booking.hidden = NO;
        cell.bookingTitle.text = @"Hagfræði";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Must be a better way to do this
    return (CGFloat)[[[self.timeTable objectAtIndex:indexPath.item] valueForKey:@"duration"] intValue];
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
