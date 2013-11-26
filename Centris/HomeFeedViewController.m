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
#import "ScheduleCardTableViewCell.h"
#import "AssignmentCardTableViewCell.h"

#pragma mark - Properties

@interface HomeFeedViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBorderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBorderHeightConstraint;

@end

@implementation HomeFeedViewController

#pragma mark - Setup

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    // Fix height constraint on borders
    self.topBorderHeightConstraint.constant = 0.5;
    self.bottomBorderHeightConstraint.constant = 0.5;
    
    // Fix padding in textView
    self.textView.contentInset = UIEdgeInsetsMake(0,-5,0,0);
    self.textView.font = [CentrisTheme headingSmallFont];
    self.textView.textColor = [CentrisTheme grayLightTextColor];
}

- (void)updateConstraints
{
    [self.textView removeConstraints:self.textView.constraints];
    [self.tableView reloadData];
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, 300)];
    // Add height constraint
    NSLayoutConstraint *textViewConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:(newSize.height)]; // The calculation is not correct, trying to fix it
    [self.textView addConstraint:textViewConstraint];
    
    [self.tableView removeConstraints:self.tableView.constraints];
    // Fix tableView height
    NSInteger height = self.tableView.contentSize.height;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    [self.tableView addConstraint:constraint];
    [self.view layoutIfNeeded];

}

#pragma mark - Methods

- (void)setupHomeFeed
{
    NSManagedObjectContext *context = [AppFactory managedObjectContext];
    NSArray *nextEvents = [ScheduleEvent nextEventForCurrentDateInManagedObjectContext:context];
    NSArray *nextAssignments = [Assignment assignmentsNotHandedInForCurrentDateInManagedObjectContext:context];
    NSString *assignmentSummaryText = [self summaryTextForAssignments:nextAssignments];
    NSString *scheduleEventSummaryText = [self summaryTextForScheduleEvents:nextEvents];
    self.textView.text = [assignmentSummaryText stringByAppendingString:scheduleEventSummaryText];
    // Fix iOS 7 bug
    self.textView.font = [CentrisTheme headingSmallFont];
    self.textView.textColor = [CentrisTheme blackLightTextColor];
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *sectionHeader = [[UILabel alloc] init];// initWithFrame:CGRectMake(0, self.tableView.frame.origin.y, self.tableView.frame.size.width-20, 14)];
    sectionHeader.textColor = [CentrisTheme blackLightTextColor];
    sectionHeader.font = [CentrisTheme headingSmallFont];
    sectionHeader.text = @"     Í DAG";
    return sectionHeader;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        ScheduleCardTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCardTableViewCell"];
        return tableViewCell;
    } else {
        AssignmentCardTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AssignmentCardTableViewCell"];
        return tableViewCell;
    }
}

@end
