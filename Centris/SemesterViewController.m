//
//  SemesterViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 10/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "SemesterViewController.h"
#import "AppFactory.h"
#import "CourseInstance+Centris.h"
#import "CourseInstanceTableViewCell.h"
#import "CourseInstanceViewController.h"
#import "PNChart.h"
#import "Semester+Centris.h"
#import "NSDate+Helper.h"
#import "DataFetcher.h"
#import "Assignment+Centris.h"

#define COURSE_INSTANCE_ROW_HEIGT 64.0

@interface SemesterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *viewControllerScrollView;
@property (nonatomic, weak) IBOutlet UITableView *courseTableView;
@property (nonatomic, strong) IBOutlet PNChart *circleChartView;
@property (weak, nonatomic) IBOutlet UIProgressView *semesterProgressView;
@property (weak, nonatomic) IBOutlet UILabel *weeksLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishedECTSLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalECTSLabel;
@property (weak, nonatomic) IBOutlet UILabel *semesterProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *semesterStartDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *semesterEndDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageGradePercentageLabel;

@property (nonatomic, strong) NSArray *courseInstances;
@property (nonatomic, strong) Semester *semester;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@property (nonatomic) BOOL isRefreshing;
// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *semesterGraphViewHeightConstraint;
@end

@implementation SemesterViewController

#pragma mark -  Properties
- (NSArray *)courseInstances
{
    if (_courseInstances == nil)
        _courseInstances = [CourseInstance courseInstancesInManagedObjectContext:[AppFactory managedObjectContext]];
    return _courseInstances;
}

- (Semester *)semester
{
    if (_semester == nil)
        _semester = [[Semester semestersInManagedObjectContext:[AppFactory managedObjectContext]] lastObject];
    return _semester;
}

- (void)setCircleChartView:(PNChart *)circleChartView
{
    _circleChartView = circleChartView;
    _circleChartView.type = PNCircleType;
    _circleChartView.total = @100;
    _circleChartView.strokeColor = [UIColor whiteColor];
    [_circleChartView strokeChart];
    _circleChartView.circleChart.lineWidth = @4;
    _circleChartView.circleChart.circleBG.strokeColor = [UIColor colorWithRed:217/255.0 green:140/255.0 blue:147/255.0 alpha:1.0].CGColor;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataFetcher = [AppFactory dataFetcher];
	self.navigationController.navigationBar.translucent = NO;
    self.courseTableView.scrollEnabled = YES;
    [self setupOutlets];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self viewNeedsToBeUpdated])
        [self userDidRefresh];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"courseInstanceSegue"]) {
        CourseInstance *courseInstance = [self.courseInstances objectAtIndex:self.courseTableView.indexPathForSelectedRow.row];
        CourseInstanceViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.courseInstance = courseInstance;
    }
}

#pragma mark - Setup

- (void)setupOutlets
{
    self.isRefreshing = NO;
    
    // Force reloading in tableView to get correct contentSize
    [self.courseTableView reloadData];
    NSInteger courseTableViewheight = self.courseTableView.contentSize.height;
    // To prevent cutting of tableView
    self.courseTableViewHeightConstraint.constant = courseTableViewheight;
    
    // Setup outlets
    self.averageGradeLabel.text = [NSString stringWithFormat:@"%.1f", [self.semester averageGrade]];
    float semesterProgress = [self.semester progressForDate:[NSDate date]] * 100;
    float totalPercentagesFromGradesInSemester = [self.semester totalPercentagesFromGradesInSemester] * 100;
    self.averageGradePercentageLabel.text = [NSString stringWithFormat:@"AF %.0f%%", totalPercentagesFromGradesInSemester];
    self.semesterProgressLabel.text = semesterProgress < 100 ? [NSString stringWithFormat:@"%.0f%%", semesterProgress] : @"Lokið";
    // Progress view with max 100
    [self.semesterProgressView setProgress:(semesterProgress < 1 ? semesterProgress/100 : 1)];
    self.weeksLeftLabel.text = [NSString stringWithFormat:@"%d", [self.semester weeksLeft:[NSDate date]]];
    self.totalECTSLabel.text = [NSString stringWithFormat:@"%d",[self.semester totalEcts]];
    self.finishedECTSLabel.text = [NSString stringWithFormat:@"%d", [self.semester finishedEcts]];
    NSDictionary *semesterDateRange = [self.semester semesterRange];
    self.semesterStartDateLabel.text = [[[semesterDateRange objectForKey:@"starts"] stringFromDateWithFormat:@"dd. MMMM"] uppercaseString];
    self.semesterEndDateLabel.text = [[[semesterDateRange objectForKey:@"ends"] stringFromDateWithFormat:@"dd. MMMM"] uppercaseString];
    
    // CircleChart
    if ([self.circleChartView.circleChart.current integerValue] != [[NSNumber numberWithFloat:totalPercentagesFromGradesInSemester] integerValue]) {
        self.circleChartView.circleChart.current = [NSNumber numberWithFloat:totalPercentagesFromGradesInSemester];
        [self.circleChartView.circleChart strokeChart];
    }
}

#pragma mark - Refresh control
/* TODO: This should happen in the models */
- (void)userDidRefresh
{
    if (!self.isRefreshing) {
        self.isRefreshing = YES;
        [self.dataFetcher getCoursesInSemester:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Got %d courses", [responseObject count]);
            for (NSDictionary *courseInst in responseObject) {
                [CourseInstance addCourseInstanceWithCentrisInfo:courseInst inManagedObjectContext:[AppFactory managedObjectContext]];
            }
            // Fetch assignments
            [self.dataFetcher getAssignmentsInSemester:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Got %d assignments", [responseObject count]);
                [Assignment addAssignmentsWithCentrisInfo:responseObject inManagedObjectContext:[AppFactory managedObjectContext]];
                // Set courseInstances and semester to nil to force update
                self.courseInstances = nil;
                self.semester = nil;
                [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:COURSE_INSTANCE_LAST_UPDATE];
                [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:ASSIGNMENT_LAST_UPDATED];
                [self setupOutlets];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error getting assignments");
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error getting courses in SemesterView");
        }];
        
    }
}

- (BOOL)viewNeedsToBeUpdated
{
    NSDate *now = [NSDate date];
    NSDate *lastUpdated = [[AppFactory sharedDefaults] objectForKey:COURSE_INSTANCE_LAST_UPDATE];
    if (!lastUpdated) { // Does not exists, so the view should better update.
        return YES;
    } else if ([now timeIntervalSinceDate:lastUpdated] >= [[[AppFactory configuration] objectForKey:@"defaultUpdateTimeIntervalSeconds"] integerValue]) { // Check if it is time to update
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.courseTableView)
        return self.courseInstances.count;
    else
        return 0;
}

/* TODO: Refactor this method */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseInstance *courseInstance = [self.courseInstances objectAtIndex:indexPath.row];
    CourseInstanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseTableViewCell"];
    cell.titleLabel.text = courseInstance.name;
    cell.detailLabel.text = courseInstance.status;
    if ([courseInstance isPassed]) {
        if (courseInstance.finalGrade != nil) {
            cell.gradeLabel.text = [NSString stringWithFormat:@"%.1f", courseInstance.finalGrade.floatValue];
            cell.gradeDetailLabel.text = @"Lokaeinkunn";
        } else {
            cell.gradeLabel.text = @"Staðið";
            cell.gradeDetailLabel.text = @"";
        }
        
    } else {
        NSInteger totalPercentagesFromAssignments = [courseInstance totalPercentagesFromAssignments];
        if (totalPercentagesFromAssignments != 0) {
            cell.gradeLabel.text = [NSString stringWithFormat:@"%.1f", [courseInstance weightedAverageGrade]];
            cell.gradeDetailLabel.text = [NSString stringWithFormat:@"Meðaleinkunn af %d%%", totalPercentagesFromAssignments];
        } else {
            cell.gradeLabel.text = @"";
            cell.gradeDetailLabel.text = @"";
        }
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return COURSE_INSTANCE_ROW_HEIGT;
}

@end
