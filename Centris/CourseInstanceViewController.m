//
//  CourseInstanceViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 11/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstanceViewController.h"
#import "PNChart.h"
#import "CourseInstance+Centris.h"
#import "CourseInstance+Centris.h"
#import "AppFactory.h"
#import "Assignment+Centris.h"
#import "WebViewController.h"

#define COURSEINSTANCES_LAST_UPDATED @"SemesterVCLastUpdate"

@interface CourseInstanceViewController () <UITableViewDataSource, UITableViewDelegate>
// Outlets
@property (weak, nonatomic) IBOutlet UIView *noGradeInfoView;
@property (nonatomic, weak) IBOutlet UITableView *materialTableView;
@property (nonatomic, weak) IBOutlet PNChart *circleChartView;
@property (nonatomic, weak) IBOutlet UIView *chartContainerView;
@property (weak, nonatomic) IBOutlet UILabel *averageWeightedCourseGradeDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *averageWeightedCourseGradeLabel;
@property (nonatomic, weak) IBOutlet UILabel *averageWeightedCourseGradePercentageLabel;
@property (nonatomic, weak) IBOutlet UILabel *acquiredGradeLabel;
@property (nonatomic, weak) IBOutlet UILabel *averageGradeLabel;
@property (nonatomic, weak) IBOutlet UILabel *averageGradeFromOtherLabel;
@property (nonatomic, weak) IBOutlet UILabel *standardDeviationLabel;
// Constraints
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *materialTableViewHeightConstraint;
// Other properties
@property (nonatomic, strong) NSArray *materialTable;
@property (nonatomic, strong) PNChart *barChart;
@property (nonatomic, strong) PNChart *lineChart;
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@property (nonatomic, strong) NSArray *gradedAssignments;
@property (nonatomic) BOOL drawBarChart;
@end

@implementation CourseInstanceViewController

#pragma - Properties
- (PNChart *)lineChart
{
    if (_lineChart == nil) {
        _lineChart = [[PNChart alloc] initWithFrame:self.chartContainerView.frame];
        _lineChart.type = PNLineType;
        _lineChart.backgroundColor = [UIColor clearColor];
        [_lineChart setStrokeColor:[UIColor whiteColor]];
        [_chartContainerView addSubview:self.lineChart];
    }
    return _lineChart;
}

- (PNChart *)barChart
{
    if (_barChart == nil) {
        _barChart = [[PNChart alloc] initWithFrame:self.chartContainerView.frame];
        _barChart.type = PNBarType;
        _barChart.backgroundColor = [UIColor clearColor];
        [_barChart setStrokeColor:[UIColor colorWithWhite:1 alpha:0.6]];
        [self.chartContainerView addSubview:_barChart];
    }
    return _barChart;
}

- (void)setCircleChartView:(PNChart *)circleChartView
{
    _circleChartView = circleChartView;
    _circleChartView.type = PNCircleType;
    _circleChartView.total = @100;
    _circleChartView.strokeColor = [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0];
    [_circleChartView strokeChart];
    _circleChartView.circleChart.lineWidth = @2;
    _circleChartView.circleChart.circleBG.strokeColor = [[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] CGColor];
    _circleChartView.circleChart.circleBG.fillColor = [[UIColor whiteColor] CGColor];
}

- (NSArray *)materialTable
{
    if (_materialTable == nil)
        _materialTable = @[
                           @{ @"title" : @"Kennsluáætlun", @"content" : self.courseInstance.syllabus ? self.courseInstance.syllabus : @"" },
                           @{ @"title" : @"Lýsing", @"content" : self.courseInstance.content ? self.courseInstance.content : @"" },
                           @{ @"title" : @"Námsmat", @"content" : self.courseInstance.assessmentMethods ? self.courseInstance.assessmentMethods : @"" },
                           @{ @"title" : @"Hæfniviðmið", @"content" : self.courseInstance.learningOutcome ? self.courseInstance.learningOutcome : @"" }
                           ];
    return _materialTable;
}

- (NSArray *)gradedAssignments
{
    if (_gradedAssignments == nil) {
        _gradedAssignments = [self.courseInstance gradedAssignmentsWithNonZeroWeight];
    }
    return _gradedAssignments;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataFetcher = [AppFactory dataFetcher];
    self.drawBarChart = YES;
	[self setupOutlets];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self viewNeedsToBeUpdated])
        [self userDidRefresh];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"materialSegue"]) {
        WebViewController *destinationController = [segue destinationViewController];
        NSDictionary *material = [self.materialTable objectAtIndex:self.materialTableView.indexPathForSelectedRow.row];
        destinationController.title = [material objectForKey:@"title"];
        destinationController.htmlContent = [material objectForKey:@"content"];
    }
}

#pragma mark - Setup
- (void)setupOutlets
{
    // Set tableView delegate and datasource
    self.materialTableView.delegate = self;
    self.materialTableView.dataSource = self;
    // Set title
    self.title = self.courseInstance.name;
    // Values for bar chart and line chart
    NSMutableArray *yValues = [[NSMutableArray alloc] init];
    NSMutableArray *xValues = [[NSMutableArray alloc] init];
    // Check if grades have changed, if they have changed, then redraw barChart
    NSArray *temporaryGradedAssignments = [self.courseInstance gradedAssignmentsWithNonZeroWeight];
    // First check if the count is the same
    if ([temporaryGradedAssignments count] != [self.gradedAssignments count]) {
        self.drawBarChart = YES;
    } else {
        // Also check if the grades are the same
        for (int i=0; i < [temporaryGradedAssignments count]; i++) {
            if ([((Assignment *)self.gradedAssignments[i]).grade integerValue] != [((Assignment *)temporaryGradedAssignments[i]).grade integerValue]) {
                self.drawBarChart = YES;
                break;
            }
        }
    }
    // Setup averageWeightedCourseGrade
    if ([self.courseInstance hasFinalResults]) {
        // If courseInstance has final results and final grade
        if (self.courseInstance.finalGrade != nil) {
            self.averageWeightedCourseGradeLabel.text = [NSString stringWithFormat:@"%.1f", [self.courseInstance.finalGrade floatValue]];
            self.averageWeightedCourseGradeDescriptionLabel.text = @"LOKAEINKUNN";
            self.averageWeightedCourseGradePercentageLabel.text = @"";
        } else { // If courseInstance has final results but not final grade
            self.averageWeightedCourseGradeLabel.text = self.courseInstance.status;
            self.averageWeightedCourseGradePercentageLabel.text = @"";
            self.averageWeightedCourseGradeDescriptionLabel.text = @"";
        }
    } else {
        if ([self.gradedAssignments count] == 0) {
            self.noGradeInfoView.alpha = 1.0;
            self.averageWeightedCourseGradeLabel.text = @"...";
            self.averageWeightedCourseGradeDescriptionLabel.text = @"MEÐALTAL";
            self.averageWeightedCourseGradePercentageLabel.text = @"AF 0%";
        } else { // Else if we have graded assignments
            self.averageWeightedCourseGradeLabel.text = [NSString stringWithFormat:@"%.1f", [self.courseInstance weightedAverageGrade]];
            self.averageWeightedCourseGradeDescriptionLabel.text = @"MEÐALTAL";
            self.averageWeightedCourseGradePercentageLabel.text = [NSString stringWithFormat:@"AF %.1f%%", [self.courseInstance totalPercentagesFromAssignments]];
        }
    }
    self.acquiredGradeLabel.text = [NSString stringWithFormat:@"%.1f", [self.courseInstance acquiredGrade]];
    self.averageGradeLabel.text = [NSString stringWithFormat:@"%.1f", [self.courseInstance averageGrade]];
    self.averageGradeFromOtherLabel.text = @"...";
    self.standardDeviationLabel.text = @"...";
    
    float totalPercentagesFromAssignment = [self.courseInstance totalPercentagesFromAssignments];
    // Redraw if percentage has changed
    if (self.circleChartView.current == nil || [self.circleChartView.current integerValue] != [[NSNumber numberWithFloat:[self.courseInstance totalPercentagesFromAssignments]] integerValue]) {
        self.circleChartView.current = [NSNumber numberWithFloat:totalPercentagesFromAssignment];
        [self.circleChartView strokeChart];
    }
    // Only draw barChart if there are any grades
    if (([self.gradedAssignments count] != 0) && self.drawBarChart == YES) {
        for (Assignment *assignment in self.gradedAssignments) {
            [yValues addObject:[NSNumber numberWithFloat:[assignment.grade floatValue]]];
            [xValues addObject:@""];
        }
        // BarChart
        [self.barChart setXLabels:xValues];
        [self.barChart setYValues:yValues];
        [self.barChart strokeChart];
        
        if ([self.gradedAssignments count] > 1) {
            // LineChart
            [self.lineChart setXLabels:xValues];
            NSArray *yLineValues = [self.courseInstance averageGradeDevelopment];
            [self.lineChart setYValues:yLineValues];
            [self.lineChart strokeChart];
        }
        self.drawBarChart = NO;
    }
    
    [self.materialTableView reloadData];
    self.materialTableViewHeightConstraint.constant = self.materialTableView.contentSize.height;
    self.isRefreshing = NO;
}

#pragma mark - Refresh Control
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
                // Refresh courseInstance
                self.courseInstance = [CourseInstance courseInstanceWithID:self.courseInstance.id.integerValue inManagedObjectContext:[AppFactory managedObjectContext]];
                [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:COURSEINSTANCES_LAST_UPDATED];
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
    NSDate *lastUpdated = [[AppFactory sharedDefaults] objectForKey:COURSEINSTANCES_LAST_UPDATED];
    if (!lastUpdated) { // Does not exists, so the view should better update.
        return YES;
    } else if ([now timeIntervalSinceDate:lastUpdated] >= [[[AppFactory configuration] objectForKey:@"defaultUpdateTimeIntervalSeconds"] integerValue]) { // Check if it's time to update
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.materialTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"materialTableViewCell"];
    cell.textLabel.text = [[self.materialTable objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}

@end
