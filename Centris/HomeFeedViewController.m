//
//  HomeFeedViewController.m
//  Centris
//
//  Created by Bjarki Sörens on 8/26/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//


#pragma mark - Imports

#import "HomeFeedViewController.h"
#import "CentrisDataFetcher.h"
#import "NSDate+Helper.h"
#import "User+Centris.h"
#import "ScheduleEvent+Centris.h"
#import "Assignment+Centris.h"
#import "CourseInstance+Centris.h"
#import "AppFactory.h"
#import "Assignment.h"
#import "Menu+Centris.h"
#import "ScheduleEvent.h"
#import "ScheduleCardTableViewCell.h"
#import "AssignmentCardTableViewCell.h"
#import "LunchCardTableViewCell.h"
#import "EventCardTableViewCell.h"
#import "DataFetcher.h"

#define TEXTVIEW_MAX_HEIGHT 300

#pragma mark - Properties

@interface HomeFeedViewController () <UITableViewDataSource, UITableViewDelegate>
// Outlets
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBorderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBorderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (nonatomic, strong) id nextUp;
@property (nonatomic, strong) NSMutableArray *taskListForToday;

@end

@implementation HomeFeedViewController

#pragma mark - Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Get Menu
    [[AppFactory fetcherFromConfiguration] getMenuWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got %d Lunch", [responseObject count]);
        [Menu addMenuWithCentrisInfo:responseObject inManagedObjectContext:[AppFactory managedObjectContext]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting Lunch");
    }];

    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupHomeFeed];
    [self updateConstraints];
}

- (void)setup
{
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Fix padding in textView
    self.textView.contentInset = UIEdgeInsetsMake(0,-5,0,0);
    self.textView.font = [CentrisTheme headingSmallFont];
    self.textView.textColor = [CentrisTheme grayLightTextColor];
    
    // Fix height constraint on borders
    self.topBorderHeightConstraint.constant = 0.5;
    self.bottomBorderHeightConstraint.constant = 0.5;
}

- (void)updateConstraints
{
    // Calculate textView content height, auto layout won't resize height to match content height
    CGSize newSizeOfTextView = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, TEXTVIEW_MAX_HEIGHT)];
    // Fix height constraint on textView
    self.textViewHeightConstraint.constant = newSizeOfTextView.height;
    
    NSInteger newHeightOfTableView = self.tableView.contentSize.height;
    // Fix height constraint on textView
    self.tableViewHeightConstraint.constant = newHeightOfTableView;
    
    [self.view layoutIfNeeded];
}

#pragma mark - Methods

- (void)setupHomeFeed
{
    NSManagedObjectContext *context = [AppFactory managedObjectContext];
    NSMutableArray *nextEvents = [[ScheduleEvent nextEventForDate:[NSDate date] InManagedObjectContext:context] mutableCopy];
    NSMutableArray *nextFinalExams = [[ScheduleEvent finalExamsExceedingDate:[NSDate date] InManagedObjectContext:context] mutableCopy];
    NSMutableArray *nextAssignments = [[Assignment assignmentsNotHandedInForCurrentDateInManagedObjectContext:context] mutableCopy];
    NSString *assignmentSummaryText = [self summaryTextForAssignments:nextAssignments];
    NSString *scheduleEventSummaryText = [self summaryTextForScheduleEvents:nextEvents];
    NSString *finalExamSummaryText = [self summaryTextForFinalExams:nextFinalExams];
    
    // If the clock is between 11:00 and 13:00, then add Lunch card
    Menu *menu;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    if ([[NSDate dateComponentForDate:[NSDate date] withCalendar:gregorian] hour] >= 11 &&
        [[NSDate dateComponentForDate:[NSDate date] withCalendar:gregorian] hour] <= 13) {
        menu = [Menu getMenuForDay:[NSDate date] inManagedObjectContext:[AppFactory managedObjectContext]];
    }
    self.textView.text = [[assignmentSummaryText stringByAppendingString:scheduleEventSummaryText] stringByAppendingString:finalExamSummaryText];
    // Fix iOS 7 bug
    self.textView.font = [CentrisTheme headingSmallFont];
    self.textView.textColor = [CentrisTheme blackLightTextColor];
    
    self.taskListForToday = [[NSMutableArray alloc] init];
    if (menu != nil)
        [self.taskListForToday addObject:menu];
    if ([nextEvents count] != 0)
        [self.taskListForToday addObject:nextEvents[0]];
    if ([nextAssignments count] != 0)
        [self.taskListForToday addObjectsFromArray:nextAssignments];
    if ([nextFinalExams count] != 0) {
        [self.taskListForToday addObject:nextFinalExams[0]];
        if ([self.taskListForToday count] == 1 && nextFinalExams != nil)
            [self.taskListForToday addObject:nextFinalExams[1]];
    }
    
    [self.tableView reloadData];
}

- (NSString *)summaryTextForFinalExams:(NSArray *)finalExams
{
    NSString *finalExamSummary = @"";
    if ([finalExams count] != 0) {
        ScheduleEvent *firstFinalExam = finalExams[0];
        NSInteger secondsToTime = [firstFinalExam.starts timeIntervalSinceDate:[NSDate date]];
        NSInteger daysToTime = secondsToTime/60/60/24;
        finalExamSummary = [NSString stringWithFormat:@"%d dagar í næsta lokapróf í %@", daysToTime, firstFinalExam.hasCourseInstance.name];
    }
    return finalExamSummary;
}

- (NSString *)summaryTextForAssignments:(NSArray *)assignments
{
    NSInteger numberOfAssignments = [assignments count];
    NSString *assignmentsSummary = @"";
    if (numberOfAssignments) {
        if (numberOfAssignments > 1) {
            assignmentsSummary = [NSString stringWithFormat:@"Þú átt eftir að skila %d verkefnum í dag í ", numberOfAssignments];
            NSMutableSet *setOfCourses = [[NSMutableSet alloc] init];
            for (Assignment *assignment in assignments) {
                [setOfCourses addObject:assignment.isInCourseInstance.name];
            }
            NSInteger index = 0;
            for (NSString *courseInstanceName in setOfCourses) {
                if (index == ([setOfCourses count] -2)) { // we're at the second last
                    assignmentsSummary = [assignmentsSummary stringByAppendingString:[NSString stringWithFormat:@"%@ og ", courseInstanceName]];
                } else if (index == [setOfCourses count] -1 ) { // we're at the last
                    assignmentsSummary = [assignmentsSummary stringByAppendingString:[NSString stringWithFormat:@"%@. ", courseInstanceName]];
                } else { // we just keep adding commas
                    assignmentsSummary = [assignmentsSummary stringByAppendingString:[NSString stringWithFormat:@"%@, ", courseInstanceName]];
                }
                index++;
            }
        } else {
            assignmentsSummary = [NSString stringWithFormat:@"Þú átt eftir að skila einu verkefni í dag í "];
            Assignment *assignment = (Assignment *)[assignments firstObject];
            assignmentsSummary = [assignmentsSummary stringByAppendingString:[NSString stringWithFormat:@"%@. ", assignment.isInCourseInstance.name]];
        }
    } else {
//        NSDateComponents *comps = [NSDate dateComponentForDate:[NSDate date] withCalendar:gregorian];
//        if ([comps weekday] == 6) { // FRIDAY
//            assignmentsSummary = @"Jey! Engin verkefni sem þarf að skila í kvöld. Á kannski að skella sér í vísindaferð? ";
//        }
    }
    return assignmentsSummary;
}

- (NSString *)summaryTextForScheduleEvents:(NSArray *)scheduleEvents
{
    NSInteger numberOfEvents = [scheduleEvents count];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsNow = [NSDate dateComponentForDate:[NSDate date] withCalendar:gregorian];
    NSString *scheduleEventSummary = @"";
    if (numberOfEvents) {
        ScheduleEvent *nextEvent = (ScheduleEvent *)[scheduleEvents lastObject];
        NSDateComponents *eventComps = [NSDate dateComponentForDate:nextEvent.starts withCalendar:gregorian];
        // check if it's in the morning
        if ([eventComps day] != [compsNow day]) {
            scheduleEventSummary = [scheduleEventSummary stringByAppendingString:[NSString stringWithFormat:@"%@ er næsti tími hjá þér í fyrramálið klukkan %@ í stofu %@. ", nextEvent.hasCourseInstance.name, [NSDate convertToString:nextEvent.starts withFormat:@"HH':'mm]"], nextEvent.roomName]];
        } else {
            scheduleEventSummary = [scheduleEventSummary stringByAppendingString:[NSString stringWithFormat:@"%@ er næsti tími hjá þér klukkan %@ í stofu %@. ", nextEvent.hasCourseInstance.name, [NSDate convertToString:nextEvent.starts withFormat:@"HH':'mm"], nextEvent.roomName]];
        }
    } // else it is a weekend or the schoolday is over. Might be a good idea to find a witty text about this situation.
    return scheduleEventSummary;
}


#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.nextUp != nil && [self.taskListForToday count] != 0)
        return 2;
    else if (self.nextUp != nil || [self.taskListForToday count] != 0)
        return 1;
    else
        return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.nextUp != nil && section == 0)
        return 1;
    
    return [self.taskListForToday count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.taskListForToday objectAtIndex:indexPath.row] isKindOfClass:[Menu class]])
        return 140;
    
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *sectionHeader = [[UILabel alloc] init];
    sectionHeader.textColor = [CentrisTheme blackLightTextColor];
    sectionHeader.font = [CentrisTheme headingSmallFont];
    if (section == 0)
        sectionHeader.text = @"     NÆST";
    else
        sectionHeader.text = @"     Í DAG";
    return sectionHeader;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    EventCardTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"EventCardTableViewCell"];
    
    // First get item
    id rowItem;
    if (self.nextUp != nil && indexPath.section == 0)
        rowItem = self.nextUp;
    else
        rowItem = [self.taskListForToday objectAtIndex:indexPath.row];
    // Then find out what kind of item this is and return the right card for it
    if ([rowItem isKindOfClass:[Assignment class]]) {
        AssignmentCardTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AssignmentCardTableViewCell"];
        Assignment *assignment = rowItem;
        tableViewCell.courseLabel.text = assignment.isInCourseInstance.name;
        tableViewCell.titleLabel.text = assignment.title;
        tableViewCell.weightLabel.text = [NSString stringWithFormat:@"%@%%", assignment.weight];
        NSInteger secondsToClose = [assignment.dateClosed timeIntervalSinceDate:[NSDate date]];
        NSInteger hoursToClose = secondsToClose/60/60;
        NSInteger minutesToClose = secondsToClose/60-hoursToClose*60;
        tableViewCell.timeUntilClosedLabel.text = [NSString stringWithFormat:@"%02d:%02d", hoursToClose, minutesToClose];
        return tableViewCell;
    } else if ([rowItem isKindOfClass:[ScheduleEvent class]]) {
        ScheduleCardTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCardTableViewCell"];
        ScheduleEvent *scheduleEvent = rowItem;
        tableViewCell.courseNameLabel.text = scheduleEvent.hasCourseInstance.name;
//        NSDictionary *shortcutForTypeOfClass = @{@"Lokapróf"
        tableViewCell.locationLabel.text = [NSString stringWithFormat:@"%@ í %@", scheduleEvent.typeOfClass, scheduleEvent.roomName];
        
        tableViewCell.fromTimeLabel.text = [NSDate convertToString:scheduleEvent.starts withFormat:@"HH:mm"];
        tableViewCell.toTimeLabel.text = [NSDate convertToString:scheduleEvent.ends withFormat:@"HH:mm"];
        NSInteger secondsToTime = [scheduleEvent.starts timeIntervalSinceDate:[NSDate date]];
        NSInteger daysToTime = secondsToTime/60/60/24;
        NSInteger hoursToTime = secondsToTime/60/60;
        NSInteger minutesToTime = secondsToTime/60;
        if (daysToTime != 0) {
            hoursToTime = hoursToTime + (int)round(hoursToTime-minutesToTime/60);
            tableViewCell.timeUntilLabel.text = [NSString stringWithFormat:@"Eftir %d daga", daysToTime];
        } else if (hoursToTime != 0) {
            // Round hours
            hoursToTime = hoursToTime + (int)round(hoursToTime-minutesToTime/60);
            tableViewCell.timeUntilLabel.text = [NSString stringWithFormat:@"Eftir %d tíma", hoursToTime];
        } else {
            tableViewCell.timeUntilLabel.text = [NSString stringWithFormat:@"Eftir %d mín", minutesToTime-hoursToTime*60];
        }
        return tableViewCell;
    } else if ([rowItem isKindOfClass:[Menu class]]) {
        LunchCardTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"LunchCardTableViewCell"];
        Menu *menu = rowItem;
        tableViewCell.textView.text = menu.menu;
        return tableViewCell;
    } else {
        return nil;
    }
}

@end
