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
#import "Assignment.h"
#import <EventKit/EventKit.h>

@interface CourseInstanceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *materialTableView;
@property (weak, nonatomic) IBOutlet PNChart *circleChartView;
@property (weak, nonatomic) IBOutlet UIView *chartContainerView;
@property (weak, nonatomic) IBOutlet UILabel *averageWeightedCourseGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageWeightedCourseGradePercentageLabel;

@property (strong, nonatomic) NSArray *materialTable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialTableViewHeightConstraint;

@end

@implementation CourseInstanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setup];
}

- (void)setup
{
    self.materialTableView.delegate = self;
    self.materialTableView.dataSource = self;
    
    float totalPercentagesFromAssignments = [self.courseInstance totalPercentagesFromAssignments];
    
    self.circleChartView.type = PNCircleType;
    self.circleChartView.total = @100;
    self.circleChartView.current = [NSNumber numberWithFloat:totalPercentagesFromAssignments];
    self.circleChartView.strokeColor = [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0];
    [self.circleChartView strokeChart];
    self.circleChartView.circleChart.lineWidth = @5;
    self.circleChartView.circleChart.circleBG.strokeColor = [[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] CGColor];
    self.circleChartView.circleChart.circleBG.fillColor = [[UIColor whiteColor] CGColor];
    [self.circleChartView.circleChart strokeChart];
    
    NSArray *gradedAssignments = [self.courseInstance gradedAssignments];
    self.averageWeightedCourseGradeLabel.text = [NSString stringWithFormat:@"%.1f", [self.courseInstance weightedAverageGrade]];
    self.averageWeightedCourseGradePercentageLabel.text = [NSString stringWithFormat:@"AF %.1f%%", totalPercentagesFromAssignments];
    
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
        PNChart *barChart = [[PNChart alloc] initWithFrame:self.chartContainerView.frame];
        barChart.type = PNBarType;
        barChart.backgroundColor = [UIColor clearColor];
        [barChart setStrokeColor:[UIColor colorWithWhite:1 alpha:0.6]];
        [barChart setXLabels:xValues];
        [barChart setYValues:yValues];
        [barChart strokeChart];
        [self.chartContainerView addSubview:barChart];
        
        [EKAlarm alarmWithRelativeOffset:5];
        
        // LineChart
        PNChart *lineChart = [[PNChart alloc] initWithFrame:self.chartContainerView.frame];
        lineChart.type = PNLineType;
        lineChart.backgroundColor = [UIColor clearColor];
        [lineChart setStrokeColor:[UIColor whiteColor]];
        [lineChart setXLabels:xValues];
        [lineChart setYValues:yLineValues];
        [lineChart strokeChart];
        [self.chartContainerView addSubview:lineChart];
    }
    
    self.title = self.courseInstance.name;
    
    [self.materialTableView reloadData];
    self.materialTableViewHeightConstraint.constant = self.materialTableView.contentSize.height;
}

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
