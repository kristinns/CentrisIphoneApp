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
#import "ScheduleTableViewCell.h"
#import "NSDate+Helper.h"

#define ROW_HEIGHT 61.0

@interface ScheduleViewController ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@property (nonatomic, strong) NSMutableArray *scheduleEvents;
@property (nonatomic, weak) IBOutlet DatePickerView *datePickerView;
@property (nonatomic, strong) NSDate *datePickerDate;
@property (nonatomic, strong) NSDate *datePickerSelectedDate;
@property (nonatomic, strong) NSDate *datePickerToday;
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
        _dataFetcher = [AppFactory fetcherFromConfiguration];
    return _dataFetcher;
}

#pragma mark - Methods
- (void)getScheduledEvents
{
	//User *user = [User userWith:@"0805903269" inManagedObjectContext:self.managedObjectContext];
	//if (user) {
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
            NSArray *schedule = [self.dataFetcher getSchedule:@"0805903269" from: from to: to];
            [self.managedObjectContext performBlock:^{
				for (NSDictionary *event in schedule) {
					[self.scheduleEvents addObject:[ScheduleEvent addScheduleEventWithCentrisInfo:event inManagedObjectContext:self.managedObjectContext]];
				}
                [self.tableView reloadData];
            }];
        });

	//}
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scheduleEvents count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleEventCell"];
    ScheduleEvent *scheduleEvent = [self.scheduleEvents objectAtIndex:indexPath.row];
    cell.courseNameLabel.text = scheduleEvent.courseName;
    cell.locationLabel.text = scheduleEvent.roomName;
    cell.typeOfClassLabel.text = scheduleEvent.typeOfClass;
    // Hide row at top
    if (indexPath.row == 0)
        cell.topBorderIsHidden = YES;
    
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
    self.datePickerView.delegate = self;
    // Set start date to Sunday this week
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:[NSDate date]];
    [comps setMinute:0];
    [comps setHour:0];
    [comps setSecond:0];
    NSInteger weekday = [comps weekday]-1;
    self.datePickerToday = [gregorian dateFromComponents:comps];
    self.datePickerSelectedDate = self.datePickerToday;
    self.datePickerDate = [[self.datePickerSelectedDate dateByAddingDays:-weekday] dateByAddingWeeks:-1];
    
    [self getScheduledEvents];
    [self updateDatePicker];
}

#pragma DatePicker methods
- (void)datePickerDidScrollToRight:(BOOL)right
{
    // If right, add 1 week, if left, subtract 1 week
    NSInteger addWeeks = right ? 1 : -1;
    self.datePickerDate = [self.datePickerDate dateByAddingWeeks:addWeeks];
    self.datePickerSelectedDate = [self.datePickerSelectedDate dateByAddingWeeks:addWeeks];
    
    [self updateDatePicker];
}

- (void)datePickerDidSelectDayAtIndex:(NSInteger)dayIndex
{
    self.datePickerSelectedDate = [self.datePickerDate dateByAddingDays:dayIndex];
}

- (NSString *)weekDayFromInteger:(NSInteger)weekdayInteger
{
    if (weekdayInteger == 1)
        return @"S";
    else if (weekdayInteger == 2)
        return @"M";
    else if (weekdayInteger == 3)
        return @"Þ";
    else if (weekdayInteger == 4)
        return @"M";
    else if (weekdayInteger == 5)
        return @"F";
    else if (weekdayInteger == 6)
        return @"F";
    else if (weekdayInteger == 7)
        return @"L";
    else
        return @"";
}

- (void)updateDatePicker
{
    // Update week label
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekCalendarUnit fromDate:self.datePickerSelectedDate];
    self.datePickerView.weekNumberLabel.text = [NSString stringWithFormat:@"Vika %d", [comps week]];
    // Update dateRange label
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM"];
    self.datePickerView.dateRangeLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                               [dateFormatter stringFromDate:[self.datePickerDate dateByAddingWeeks:1]],
                                               [dateFormatter stringFromDate:[self.datePickerDate dateByAddingDays:13]]];
    
    for (int i=0; i < [self.datePickerView.dayViewsList count]; i++) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *dateForDayView = [self.datePickerDate dateByAddingDays:i];
        NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:dateForDayView];
        // Update dayView
        DatePickerDayView *dayView = [self.datePickerView.dayViewsList objectAtIndex:i];
        dayView.dayOfMonth = [comps day];
        dayView.dayOfWeek = [self weekDayFromInteger:[comps weekday]];
        dayView.selected = NO;
        dayView.today = NO;
        if ([dateForDayView compare:self.datePickerToday] == NSOrderedSame)
            dayView.today = YES;
        if ([dateForDayView compare:self.datePickerSelectedDate] == NSOrderedSame)
            dayView.selected = YES;
    }
}


@end
