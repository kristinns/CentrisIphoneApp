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
#define SEPERATOR_HEIGHT 26.0

@interface ScheduleViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@property (nonatomic, strong) NSArray *scheduleEvents;
@property (nonatomic, weak) IBOutlet DatePickerView *datePickerView;
@property (nonatomic, strong) NSDate *datePickerDate;
@property (nonatomic, strong) NSDate *datePickerSelectedDate;
@property (nonatomic, strong) NSDate *datePickerToday;
@property (nonatomic) BOOL updated;
@end

@implementation ScheduleViewController

- (IBAction)GoBackToToday:(id)sender {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:self.datePickerToday];
    NSInteger weekDay = [comps weekday]-1;
    
    self.datePickerSelectedDate = self.datePickerToday;
    self.datePickerDate = [[self.datePickerToday dateByAddingDays:-weekDay] dateByAddingWeeks:-1];

    [self updateDatePicker];
}


#pragma mark - Getters
- (NSArray *)scheduleEvents
{
    if (!_scheduleEvents)
        _scheduleEvents = [[NSArray alloc] init];
    return _scheduleEvents;
}

- (id<DataFetcher>)dataFetcher
{
    if(!_dataFetcher)
        _dataFetcher = [AppFactory fetcherFromConfiguration];
    return _dataFetcher;
}

#pragma mark - Methods
- (void )fetchScheduleEventsFromCoreData
{
    if (!self.updated) {
        [self fetchScheduledEventsFromAPI];
        self.updated = YES;
    } else {
        self.scheduleEvents = [ScheduleEvent scheduleEventsFromDay:self.datePickerSelectedDate inManagedObjectContext:[AppFactory managedObjectContext]];
        [self.tableView reloadData];
    }
}

// Function that calls the API and stores events in Core data
- (void)fetchScheduledEventsFromAPI
{
    NSString *userEmail = [[AppFactory keychainItemWrapper] objectForKey:(__bridge id)(kSecAttrAccount)];
    User *user = [User userWithEmail:userEmail inManagedObjectContext:[AppFactory managedObjectContext]];
    if (user) {
        [self.dataFetcher getScheduleInSemester:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Got %d scheduleEvents", [responseObject count]);
            for (NSDictionary *event in responseObject) {
				[ScheduleEvent addScheduleEventWithCentrisInfo:event inManagedObjectContext:[AppFactory managedObjectContext]];
			}
             [self fetchScheduleEventsFromCoreData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error");
        }];
        
        
    }
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scheduleEvents count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.scheduleEvents count]-1) {
        NSInteger minutes = [self breakMinutesForRowAtIndexPath:indexPath];
        if (minutes != 0) {
            return ROW_HEIGHT + SEPERATOR_HEIGHT;
        }
    }
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleEventCell"];
    ScheduleEvent *scheduleEvent = [self.scheduleEvents objectAtIndex:indexPath.row];
    cell.courseNameLabel.text = scheduleEvent.courseName;
    cell.locationLabel.text = scheduleEvent.roomName;
    cell.typeOfClassLabel.text = scheduleEvent.typeOfClass;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    cell.fromTimeLabel.text = [formatter stringFromDate:scheduleEvent.starts];
    cell.toTimeLabel.text = [formatter stringFromDate:scheduleEvent.ends];
    if ([scheduleEvent.ends timeIntervalSinceNow] < 0)
        cell.scheduleEventState = ScheduleEventHasFinished;
    else if ([scheduleEvent.starts timeIntervalSinceNow] < 0 && [scheduleEvent.ends timeIntervalSinceNow] > 0)
        cell.scheduleEventState = ScheduleEventHasBegan;
    else
        cell.scheduleEventState = ScheduleEventHasNotBegan;
    // Hide row at top
    if (indexPath.row == 0)
        cell.topBorderIsHidden = YES;
    if (indexPath.row != [self.scheduleEvents count]-1) {
        NSInteger minutes = [self breakMinutesForRowAtIndexPath:indexPath];
        if (minutes != 0) {
            cell.bounds = CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, cell.bounds.size.width, ROW_HEIGHT+SEPERATOR_HEIGHT);
            cell.seperatorBreakText = [NSString stringWithFormat:@"%d mín hlé", minutes];
        }
    }
    
    return cell;
}

- (NSInteger)breakMinutesForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleEvent *scheduleEvent = [self.scheduleEvents objectAtIndex:indexPath.row];
    ScheduleEvent *nextScheduleEvent = [self.scheduleEvents objectAtIndex:indexPath.row+1];
    NSInteger breakTime = [nextScheduleEvent.starts timeIntervalSinceDate:scheduleEvent.ends];
    NSInteger minutes = breakTime/60;
    if (minutes <= 5)
        return 0;
    else
    return minutes;
}

#pragma mark - Setup
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.updated = NO;
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
    
    [self fetchScheduleEventsFromCoreData];
    [self updateDatePicker];
}

#pragma DatePicker delegate methods
- (void)datePickerDidScrollToRight:(BOOL)right
{
    // If right, add 1 week, if left, subtract 1 week
    NSInteger addWeeks = right ? 1 : -1;
    self.datePickerDate = [self.datePickerDate dateByAddingWeeks:addWeeks];
    self.datePickerSelectedDate = [self.datePickerSelectedDate dateByAddingWeeks:addWeeks];
    [self updateDatePicker];
    [self fetchScheduleEventsFromCoreData];
}

- (void)datePickerDidSelectDayAtIndex:(NSInteger)dayIndex
{
    self.datePickerSelectedDate = [self.datePickerDate dateByAddingDays:dayIndex];
    [self fetchScheduleEventsFromCoreData];
	
}

- (NSString *)weekDayFromInteger:(NSInteger)weekdayInteger
{
    NSArray *weekDays = @[@"S", @"M", @"Þ", @"M", @"F", @"F", @"L"];
    return [weekDays objectAtIndex:weekdayInteger-1];
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
