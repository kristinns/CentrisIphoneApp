//
//  ScheduleViewController.m
//  Centris
//

#import "ScheduleTableViewController.h"
#import "ScheduleTableViewCell.h"
#import "ScheduleEvent+Centris.h"
#import "CentrisDataFetcher.h"
#import "User+Centris.h"

@interface ScheduleTableViewController ()
@property NSMutableArray *timeTable;
@end

@implementation ScheduleTableViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self getScheduledEvents];
}

-(void)getScheduledEvents
{
	User *user = [User userWith:@"0805903269" inManagedObjectContext:self.managedObjectContext];
	if (user) {
		[self.refreshControl beginRefreshing];
		dispatch_queue_t fetchQ = dispatch_queue_create("Centris Fetch", NULL);
		dispatch_async(fetchQ, ^{
			NSDateComponents *comps = [[NSDateComponents alloc] init];
			[comps setYear:2012];
			[comps setDay:15];
			[comps setMonth:2];
			[comps setHour:8];
			NSDate *from = [[NSCalendar currentCalendar] dateFromComponents:comps];
			[comps setHour:18];
			NSDate *to = [[NSCalendar currentCalendar] dateFromComponents:comps];
            NSDictionary * schedule = [CentrisDataFetcher getSchedule:user.ssn from: from to: to];
            [self.managedObjectContext performBlock:^{
				for (NSDictionary *event in schedule) {
					[ScheduleEvent addScheduleEventWithCentrisInfo:event inManagedObjectContext:self.managedObjectContext];
				}
				[self.refreshControl endRefreshing];
            }];
        });
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.refreshControl addTarget:self
                            action:@selector(getScheduledEvents)
                  forControlEvents:UIControlEventValueChanged];
	
	// set the header color
	self.navigationController.navigationBar.barTintColor = [CentrisTheme navigationBarColor];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.translucent = NO;
    
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

@end
