//
//  ScheduleViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleViewController.h"
#import "User+Centris.h"
#import "DataFetcher.h"
#import "AppFactory.h"
#import "ScheduleEvent+Centris.h"
#import "DatePickerView.h"

@interface ScheduleViewController ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet DatePickerView *datePickerView;
@property (strong, nonatomic) id<DataFetcher> dataFetcher;
@property (nonatomic, strong) NSMutableArray *scheduleEvents;

@end

@implementation ScheduleViewController

#pragma mark - Getters
- (NSManagedObjectContext *)managedObjectContext
{
    if(!_managedObjectContext)
        _managedObjectContext = [[CentrisManagedObjectContext sharedInstance] managedObjectContext];
    
    return _managedObjectContext;
}

- (id<DataFetcher>)dataFetcher
{
    if(!_dataFetcher)
        _dataFetcher = [AppFactory getFetcherFromConfiguration];
    return _dataFetcher;
}

#pragma mark - Methods
- (void)getScheduledEvents
{
	User *user = [User userWith:@"0805903269" inManagedObjectContext:self.managedObjectContext];
	if (user) {
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
            NSArray *schedule = [self.dataFetcher getSchedule:user.ssn from: from to: to];
            [self.managedObjectContext performBlock:^{
				for (NSDictionary *event in schedule) {
					[self.scheduleEvents addObject:[ScheduleEvent addScheduleEventWithCentrisInfo:event inManagedObjectContext:self.managedObjectContext]];
				}
                [self.tableView reloadData];
            }];
        });

	}
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scheduleEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleEventCell"];
    ScheduleEvent *scheduleEvent = [self.scheduleEvents objectAtIndex:indexPath.row];
    cell.textLabel.text = scheduleEvent.courseName;
	cell.detailTextLabel.text = scheduleEvent.roomName;
    
    return cell;
}

#pragma mark - Setup
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scheduleEvents = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Stundaskrá";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self getScheduledEvents];
}


@end
