//
//  ScheduleTableViewController.m
//  Centris
//
//  Created by Bjarki Sörens on 8/26/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#pragma mark - Imports

#import "ScheduleTableViewController.h"
#import "ScheduleTableViewCell.h"
#import "ScheduleEvent+Centris.h"
#import "User+Centris.h"
#import "DataFetcher.h"
#import "AppFactory.h"

#pragma mark - Interface
@interface ScheduleTableViewController ()
@property (nonatomic, strong) NSMutableArray *timeTableEvents;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation ScheduleTableViewController

#pragma mark - Getters
- (id<DataFetcher>)dataFetcher
{
	if (!_dataFetcher) {
		_dataFetcher = [AppFactory getFetcherFromConfiguration];
	}
	return _dataFetcher;
}

- (NSMutableArray *)timeTableEvents
{
	if (!_timeTableEvents) _timeTableEvents = [[NSMutableArray alloc] init];
	return _timeTableEvents;
}

- (NSManagedObjectContext *)managedObjectContext
{
	if (!_managedObjectContext) _managedObjectContext = [[CentrisManagedObjectContext sharedInstance] managedObjectContext];
	return _managedObjectContext;
}

#pragma mark - Setup
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self refresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.refreshControl addTarget:self
                            action:@selector(refresh)
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
    
}

#pragma mark - Other methods

// Fetches scheduled events and stores them in Core Data
-(IBAction)refresh
{
	User *user = [User userWith:@"0805903269" inManagedObjectContext:self.managedObjectContext]; // This is a temporary solution
	
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
            NSArray * schedule = [self.dataFetcher getSchedule:user.ssn from: from to: to];
            [self.managedObjectContext performBlock:^{
				for (NSDictionary *event in schedule) {
					// Add it to core data and add it to self.timetableevents
					[self.timeTableEvents addObject:[ScheduleEvent addScheduleEventWithCentrisInfo:event inManagedObjectContext:self.managedObjectContext]];
				}
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.refreshControl endRefreshing];
				});
            }];
        });
	}
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns timeTable property length
    return [self.timeTableEvents count];
}
// Configure each cell, this function is called for each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get cell from storyboard by identifier
    static NSString *CellIdentifier = @"Schedule item";
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.fromTime.text = [[self.timeTableEvents objectAtIndex:indexPath.item] valueForKey:@"StartTime"];
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
    return (CGFloat)[[[self.timeTableEvents objectAtIndex:indexPath.item] valueForKey:@"duration"] intValue];
}

@end
