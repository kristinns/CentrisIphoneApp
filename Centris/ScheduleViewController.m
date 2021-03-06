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
#import "TestFlight.h"

#define ROW_HEIGHT 61.0
#define SEPERATOR_HEIGHT 26.0

@interface ScheduleViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *scheduleEvents;
@property (nonatomic, weak) IBOutlet DatePickerView *datePickerView;
@property (nonatomic, strong) NSDate *datePickerDate;
@property (nonatomic, strong) NSDate *datePickerSelectedDate;
@property (nonatomic, strong) NSDate *datePickerToday;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ScheduleViewController

#pragma mark - IBAction
- (IBAction)GoBackToToday:(id)sender {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:self.datePickerToday];
    NSInteger weekDay = [comps weekday]-1;
    
    self.datePickerSelectedDate = self.datePickerToday;
    self.datePickerDate = [[self.datePickerToday dateByAddingDays:-weekDay] dateByAddingWeeks:-1];
    [self updateDatePicker];
    [self fetchScheduleEventsFromCoreData];
}

#pragma mark - Properties
- (NSArray *)scheduleEvents
{
    if (!_scheduleEvents)
        _scheduleEvents = [[NSArray alloc] init];
    return _scheduleEvents;
}

-(UIRefreshControl *)refreshControl
{
//    if (!_refreshControl)
//        _refreshControl = [[UIRefreshControl alloc] init];
    return _refreshControl;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(userDidRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scheduleEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleEventCell"];
    ScheduleEventUnit *scheduleEventUnit = [self.scheduleEvents objectAtIndex:indexPath.row];
    cell.courseNameLabel.text = scheduleEventUnit.isAUnitOf.courseName;
    cell.locationLabel.text = scheduleEventUnit.isAUnitOf.roomName;
    cell.typeOfClassLabel.text = scheduleEventUnit.isAUnitOf.typeOfClass;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    cell.fromTimeLabel.text = [formatter stringFromDate:scheduleEventUnit.starts];
    cell.toTimeLabel.text = [formatter stringFromDate:scheduleEventUnit.ends];
    if ([scheduleEventUnit.ends timeIntervalSinceNow] < 0)
        cell.scheduleEventState = ScheduleEventHasFinished;
    else if ([scheduleEventUnit.starts timeIntervalSinceNow] < 0 && [scheduleEventUnit.ends timeIntervalSinceNow] > 0)
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
            if (minutes < 25)
                cell.seperatorBreakText = [NSString stringWithFormat:@"%d mín kaffihlé", minutes];
            if (minutes == 25)
                cell.seperatorBreakText = [NSString stringWithFormat:@"%d mín hádegishlé", minutes];
            else {
                cell.seperatorBreakText = [NSString stringWithFormat:@"%d mín hlé", minutes];
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
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

#pragma mark - Refresh Control
- (void )fetchScheduleEventsFromCoreData
{
    if ([self viewNeedsToBeUpdated]) {
        // update last updated
        [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:SCHEDULE_LAST_UPDATED];
        [self fetchScheduledEventsFromAPI];
    }
    
    self.scheduleEvents = [ScheduleEvent scheduleEventUnitsForDay:self.datePickerSelectedDate
                                           inManagedObjectContext:[AppFactory managedObjectContext]];
    [self.tableView reloadData];
    
}

// Function that calls the API and stores events in Core data
- (void)fetchScheduledEventsFromAPI
{
    [[AppFactory dataFetcher] getScheduleInSemester:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got %d scheduleEvents", [responseObject count]);
        [ScheduleEvent addScheduleEventsWithCentrisInfo:responseObject inManagedObjectContext:[AppFactory managedObjectContext]];
        [self fetchScheduleEventsFromCoreData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
        [self.refreshControl endRefreshing];
    }];
}

// Will compare current date to the saved date in NSUserDefaults. If that date is older than 2 hours it will return YES.
// If that date in NSUserDefaults does not exists, it will return YES. Otherwiese, NO.
- (BOOL)viewNeedsToBeUpdated
{
    NSDate *now = [NSDate date];
    NSDate *lastUpdated = [[AppFactory sharedDefaults] objectForKey:SCHEDULE_LAST_UPDATED];
    if (!lastUpdated) { // does not exists, so the view should better update.
        return YES;
    } else if ([now timeIntervalSinceDate:lastUpdated] >= (2.0f * 60 * 60)) { // if the time since is more than 2 hours
        return YES;
    } else {
        return NO;
    }
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

-(void)userDidRefresh
{
    [TestFlight passCheckpoint:@"User did refresh schedule view"];
    [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:SCHEDULE_LAST_UPDATED];
    [self fetchScheduledEventsFromAPI];
}

#pragma mark - DatePickerViewDelegateProtocol
- (void)datePickerDidScrollToRight:(BOOL)right
{
    [TestFlight passCheckpoint:@"Scrolled datepicker"];
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

#pragma mark - Custom datepicker methods
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
