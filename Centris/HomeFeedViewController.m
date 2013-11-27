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
#import "ScheduleEvent.h"
#import "ScheduleCardTableViewCell.h"
#import "AssignmentCardTableViewCell.h"
#import "LunchCardTableViewCell.h"
#import "EventCardTableViewCell.h"

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
@property (nonatomic, strong) NSArray *taskListForToday;

@end

@implementation HomeFeedViewController

#pragma mark - Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self setupHomeFeed];
    [self updateConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupHomeFeed];
    [self updateConstraints];
}

- (void)viewDidLayoutSubviews
{
    // Fix height constraint on borders
    self.topBorderHeightConstraint.constant = 0.5;
    self.bottomBorderHeightConstraint.constant = 0.5;
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
    NSMutableArray *nextEvents = [[ScheduleEvent nextEventForCurrentDateInManagedObjectContext:context] mutableCopy];
    NSMutableArray *nextAssignments = [[Assignment assignmentsNotHandedInForCurrentDateInManagedObjectContext:context] mutableCopy];
    NSString *assignmentSummaryText = [self summaryTextForAssignments:nextAssignments];
    NSString *scheduleEventSummaryText = [self summaryTextForScheduleEvents:nextEvents];
    self.textView.text = [assignmentSummaryText stringByAppendingString:scheduleEventSummaryText];
    // Fix iOS 7 bug
    self.textView.font = [CentrisTheme headingSmallFont];
    self.textView.textColor = [CentrisTheme blackLightTextColor];
    
    // Add to card list
    // First check if there are any scheduleEvents left for today
    if ([nextEvents count] != 0) {
        self.nextUp = nextEvents[0];
        [nextEvents removeObjectAtIndex:0];
    } else if ([nextAssignments count] != 0) {
        self.nextUp = nextAssignments[0];
        [nextAssignments removeObjectAtIndex:0];
    }
    
    [nextEvents addObjectsFromArray:nextAssignments];
    self.taskListForToday = nextEvents;
}

- (NSString *)summaryTextForAssignments:(NSArray *)assignments
{
    NSInteger numberOfAssignments = [assignments count];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
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
        NSDateComponents *comps = [NSDate dateComponentForDate:[NSDate date] withCalendar:gregorian];
        if ([comps weekday] == 5) { // FRIDAY
            assignmentsSummary = @"Jey! Engin verkefni sem þarf að skila í kvöld. Á kannski að skella sér í vísindaferð? ";
        }
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
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.nextUp != nil && indexPath.section == 0)
        return 1;
    
    return [self.taskListForToday count];
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
    sectionHeader.text = @"     Í DAG";
    return sectionHeader;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LunchCardTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"LunchCardTableViewCell"];
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
        return tableViewCell;
    } else if ([rowItem isKindOfClass:[ScheduleEvent class]]) {
        ScheduleCardTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCardTableViewCell"];
        return tableViewCell;
    } else {
        return nil;
    }
}

@end
