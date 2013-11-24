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

#pragma mark - Properties

@interface HomeFeedViewController ()
@property (nonatomic, weak) IBOutlet UILabel *dayOfWeekLabel;
@property (nonatomic, weak) IBOutlet UILabel *dayOfMonthLabel;
@property (nonatomic, weak) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation HomeFeedViewController

#pragma mark - Setup

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.navigationController.navigationBar.translucent = NO;
	
	[self setTimeLabels];
    [self getUserFromDatabase];
    [self setupHomeFeed];
    self.title = @"Veitan";
}

#pragma mark - Methods

- (void)setupHomeFeed
{
    NSManagedObjectContext *context = [AppFactory managedObjectContext];
    NSArray *nextEvents = [ScheduleEvent nextEventForCurrentDateInManagedObjectContext:context];
    NSArray *nextAssignments = [Assignment assignmentsForCurrentDateInManagedObjectContext:context];
    NSLog(@"%@", [self summaryTextForAssignments:nextAssignments]);
    NSLog(@"%@", [self summaryTextForScheduleEvents:nextEvents]);
}

- (NSString *)summaryTextForAssignments:(NSArray *)assignments
{
    NSInteger numberOfAssignments = [assignments count];
    NSString *assignmentsSummary = @"";
    if (numberOfAssignments) {
        if (numberOfAssignments > 1) {
            assignmentsSummary = [NSString stringWithFormat:@"Þú átt að skila %d verkefnum í dag í ", numberOfAssignments];
            NSMutableSet *setOfCourses = [[NSMutableSet alloc] init];
            for (Assignment *assignment in assignments) {
                [setOfCourses addObject:assignment.isInCourseInstance.name];
            }
            NSInteger index = 0;
            for (NSString *courseInstanceName in setOfCourses) {
                if (index == ([setOfCourses count] -2)) { // we're at the second last
                    assignmentsSummary = [assignmentsSummary stringByAppendingString:[NSString stringWithFormat:@"%@ og ", courseInstanceName]];
                } else if (index == [setOfCourses count] -1 ) { // we're at the last
                    assignmentsSummary = [assignmentsSummary stringByAppendingString:[NSString stringWithFormat:@"%@.", courseInstanceName]];
                } else { // we just keep adding commas
                    assignmentsSummary = [assignmentsSummary stringByAppendingString:[NSString stringWithFormat:@"%@, ", courseInstanceName]];
                }
                index++;
            }
        } else {
            assignmentsSummary = [NSString stringWithFormat:@"Þú átt að skila einu verkefni í dag í "];
            Assignment *assignment = (Assignment *)[assignments firstObject];
            assignmentsSummary = [assignmentsSummary stringByAppendingString:[NSString stringWithFormat:@"%@", assignment.isInCourseInstance.name]];
        }
    } else {
        NSDateComponents *comps = [NSDate dateComponentForDate:[NSDate date]];
        if ([comps weekday] == 5) { // FRIDAY
            assignmentsSummary = @"Jey! Engin verkefni sem þarf að skila í kvöld. Á kannski að skella sér í vísindaferð?";
        }
    }
    return assignmentsSummary;
}

- (NSString *)summaryTextForScheduleEvents:(NSArray *)scheduleEvents
{
    NSInteger numberOfEvents = [scheduleEvents count];
    NSString *scheduleEventSummary = @"";
    if (numberOfEvents) {
        ScheduleEvent *nextEvent = (ScheduleEvent *)[scheduleEvents lastObject];
        scheduleEventSummary = [scheduleEventSummary stringByAppendingString:[NSString stringWithFormat:@"Þú átt %d tíma eftir í dag. %@ er næsti tími hjá þér klukkan %@ í stofu %@.", numberOfEvents ,nextEvent.hasCourseInstance.name, [NSDate formateDateToHourAndMinutesStringForDate:nextEvent.starts], nextEvent.roomName]];
    } // else it is a weekend or the schoolday is over. Might be a good idea to find a witty text about this situation.
    return scheduleEventSummary;
}

- (void)getUserFromDatabase
{
	NSString *username = [[AppFactory keychainItemWrapper] objectForKey:(__bridge id)(kSecAttrAccount)];
	User *user = [User userWithUsername:username inManagedObjectContext:[AppFactory managedObjectContext]];
	if(user) {
		NSLog(@"User found, no need to fetch");
        self.greetingLabel.text = [user.name description];
	} else {
		// If there is no user available then something in
		// login controller went wrong. TODO: handle that error
		NSLog(@"Something went horribly wrong");
    }
}

// Gets the current date and sets it to the date labels
-(void)setTimeLabels
{
	// get the date of today
	NSDate *date = [NSDate date];
	
	//format for the name of the day
	NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEEE"
															 options:0
															  locale:[NSLocale currentLocale]];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatString];
	
	NSString *formattedDayOfWeekString = [dateFormatter stringFromDate:date];
	formattedDayOfWeekString = [formattedDayOfWeekString stringByReplacingCharactersInRange:NSMakeRange(0,1)
																				 withString:[[formattedDayOfWeekString substringToIndex:1]uppercaseString]];
	//set the label
	self.dayOfWeekLabel.text = [NSString stringWithFormat:@"%@,",formattedDayOfWeekString];
	
	//format for the day of the month
	formatString = [NSDateFormatter dateFormatFromTemplate:@"dMMMMYYYY" options:0 locale:[NSLocale currentLocale]];
	[dateFormatter setDateFormat:formatString];
	NSString *formattedDayOfNumberString = [dateFormatter stringFromDate:date];
	//set the label
	self.dayOfMonthLabel.text = formattedDayOfNumberString;
}

@end
