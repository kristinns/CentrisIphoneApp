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

#define COURSEINSTANCES_LAST_UPDATED @"AnnouncementTVCLastUpdate"

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
@end

@implementation CourseInstanceViewController

#pragma Getters
- (NSArray *)materialTable
{
    if (_materialTable == nil)
        _materialTable = @[
                           @{ @"title" : @"Kennsluáætlun", @"content" : @"..." },
                           @{ @"title" : @"Lýsing", @"content" : @"..." },
                           @{ @"title" : @"Námsmat", @"content" : @"..." },
                           @{ @"title" : @"Hæfniviðmið", @"content" : @"..." }
                           ];
    return _materialTable;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataFetcher = [AppFactory dataFetcher];
	[self setup];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self viewNeedsToBeUpdated])
        [self userDidRefresh];
}

- (void)setup
{
    // Set tableView delegate and datasource
    self.materialTableView.delegate = self;
    self.materialTableView.dataSource = self;
    // Set title
    self.title = self.courseInstance.name;
    
    float totalPercentagesFromAssignments = [self.courseInstance totalPercentagesFromAssignments];
    float acquiredGrade = [self.courseInstance aquiredGrade];
    // If acquiredGrade is zero and courseInstance has result, then just print, then there is no need to display zero
    self.acquiredGradeLabel.text = ((int)acquiredGrade) == 0 && [self.courseInstance hasResults] ? @"..." : [NSString stringWithFormat:@"%.1f", acquiredGrade];
    float averageGrade = [self.courseInstance averageGrade];
    // If averageGrade is zero and courseInstance has result, then there is no need to display zero
    self.averageGradeLabel.text = ((int)averageGrade) == 0 && [self.courseInstance hasResults] ? @"..." : [NSString stringWithFormat:@"%.1f", averageGrade];
    self.averageGradeFromOtherLabel.text = @"...";
    self.standardDeviationLabel.text = @"...";
    
    [self setupCircleChart];
    if ([self.courseInstance hasResults]) {
        if ([self.courseInstance isPassed]) {
            // Then percentage of course is 100%
            self.circleChartView.current = @100;
            if (self.courseInstance.finalGrade != nil) {
                self.averageWeightedCourseGradeLabel.text = [NSString stringWithFormat:@"%.1f", self.courseInstance.finalGrade.floatValue];
                self.averageWeightedCourseGradeDescriptionLabel.text = @"LOKAEINKUNN";
            } else {
                self.averageWeightedCourseGradeLabel.text = @"S";
                self.averageWeightedCourseGradeDescriptionLabel.text = @"STAÐIÐ";
            }
            
            
        } else {
            if ([self.courseInstance isFailed])
                self.averageWeightedCourseGradeLabel.text = @"F";
            else // Display nothing
                self.averageWeightedCourseGradeLabel.text = @"";
            // Display status of course
            self.averageWeightedCourseGradeDescriptionLabel.text = [self.courseInstance.status uppercaseString];
        }
        self.averageWeightedCourseGradePercentageLabel.text = @"";
        
    } else {
        self.averageWeightedCourseGradeLabel.text = [NSString stringWithFormat:@"%.1f", [self.courseInstance weightedAverageGrade]];
        self.averageWeightedCourseGradePercentageLabel.text = [NSString stringWithFormat:@"AF %.1f%%", totalPercentagesFromAssignments];
        // Configure CircleChart
        self.circleChartView.current = [NSNumber numberWithFloat:totalPercentagesFromAssignments];
    }
    // Stroke chart
    [self.circleChartView strokeChart];

    
    NSArray *gradedAssignments = [self.courseInstance gradedAssignments];
    if ([gradedAssignments count] != 0) {
        NSMutableArray *yValues = [[NSMutableArray alloc] init];
        NSMutableArray *yLineValues = [[NSMutableArray alloc] init];
        NSMutableArray *xValues = [[NSMutableArray alloc] init];
        float averageGrade = 0;
        float percentageSum = 0;
        int i = 0;
        for (Assignment *assignment in gradedAssignments) {
            i++;
            // If grade is bigger than 10, then display 10
            [yValues addObject:assignment.grade.integerValue < 10 ? assignment.grade : @10];
            if (totalPercentagesFromAssignments != 0)
                averageGrade += assignment.grade.floatValue * assignment.weight.floatValue/100.0;
            else
                averageGrade += assignment.grade.floatValue;
            percentageSum += assignment.weight.floatValue/100.0;
            NSNumber *currentAverageGrade;
            if (totalPercentagesFromAssignments != 0)
            currentAverageGrade = [NSNumber numberWithFloat:averageGrade / percentageSum];
            else
                currentAverageGrade = [NSNumber numberWithFloat:averageGrade / i];
            [yLineValues addObject:currentAverageGrade.floatValue < 10 ? currentAverageGrade : @10];
            // xValues is not used, it's just needs to be set for PNChart
            [xValues addObject:@""];
        }
        // BarChart
        self.barChart = [[PNChart alloc] initWithFrame:self.chartContainerView.frame];
        self.barChart.type = PNBarType;
        self.barChart.backgroundColor = [UIColor clearColor];
        [self.barChart setStrokeColor:[UIColor colorWithWhite:1 alpha:0.6]];
        [self.chartContainerView addSubview:self.barChart];
        [self.barChart setXLabels:xValues];
        [self.barChart setYValues:yValues];
        [self.barChart strokeChart];
        
        if ([gradedAssignments count] > 1) {
            // LineChart
            [self.lineChart removeFromSuperview];
            self.lineChart = nil;
            self.lineChart = [[PNChart alloc] initWithFrame:self.chartContainerView.frame];
            self.lineChart.type = PNLineType;
            self.lineChart.backgroundColor = [UIColor clearColor];
            [self.lineChart setStrokeColor:[UIColor whiteColor]];
            [self.lineChart setXLabels:xValues];
            [self.lineChart setYValues:yLineValues];
            [self.lineChart strokeChart];
            [self.chartContainerView addSubview:self.lineChart];

        }
    } else if ([self.courseInstance hasResults] == NO)
        self.noGradeInfoView.alpha = 1.0;
    
    [self.materialTableView reloadData];
    self.materialTableViewHeightConstraint.constant = self.materialTableView.contentSize.height;
    self.isRefreshing = NO;
}

- (void)setupCircleChart
{
    self.circleChartView.type = PNCircleType;
    self.circleChartView.total = @100;
    self.circleChartView.strokeColor = [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0];
    [self.circleChartView strokeChart];
    self.circleChartView.circleChart.lineWidth = @2;
    self.circleChartView.circleChart.circleBG.strokeColor = [[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] CGColor];
    self.circleChartView.circleChart.circleBG.fillColor = [[UIColor whiteColor] CGColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -60)
        [self userDidRefresh];
}

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
                [self setup];
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
    if (!lastUpdated) { // does not exists, so the view should better update.
        return YES;
    } else if ([now timeIntervalSinceDate:lastUpdated] >= (2.0f * 60 * 60)) { // if the time since is more than 2 hours
        return YES;
    } else {
        return NO;
    }
}

#pragma TableView delegate methods
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

#pragma Segue methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"materialSegue"]) {
        UIViewController *destinationController = [segue destinationViewController];
        destinationController.title = [[self.materialTable objectAtIndex:self.materialTableView.indexPathForSelectedRow.row] objectForKey:@"title"];
    }
}

@end
