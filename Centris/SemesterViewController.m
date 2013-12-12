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

@interface SemesterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *viewControllerScrollView;
@property (nonatomic, weak) IBOutlet UITableView *courseTableView;
@property (nonatomic, strong) IBOutlet PNChart *circleChartView;
@property (weak, nonatomic) IBOutlet UIProgressView *semesterProgressView;

@property (nonatomic, strong) NSArray *courseInstances;
@property (nonatomic, strong) Semester *semester;
// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *semesterGraphViewHeightConstraint;
@end

@implementation SemesterViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.navigationBar.translucent = NO;
    [self.courseTableView reloadData];
    NSInteger courseTableViewheight = self.courseTableView.contentSize.height;
    self.courseTableViewHeightConstraint.constant = courseTableViewheight;
    
    self.circleChartView.type = PNCircleType;
    self.circleChartView.total = @100;
    self.circleChartView.current = @60;
    self.circleChartView.strokeColor = [UIColor whiteColor];//[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0];
    [self.circleChartView strokeChart];
    self.circleChartView.circleChart.lineWidth = @4;
    self.circleChartView.circleChart.circleBG.strokeColor = [[UIColor colorWithRed:223/255.0 green:222/255.0 blue:222/255.0 alpha:0.6] CGColor];
    self.circleChartView.circleChart.circleBG.fillColor = nil;
    [self.circleChartView.circleChart strokeChart];
    
    [self.semesterProgressView setProgress:0.9 animated:YES];
    [UIProgressView setAnimationDuration:1.0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.courseTableView)
        return self.courseInstances.count;
    else
        return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseInstanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseTableViewCell"];
    CourseInstance *courseInstance = [self.courseInstances objectAtIndex:indexPath.row];
    cell.titleLabel.text = courseInstance.name;
    NSInteger totalPercentagesFromAssignments = [courseInstance totalPercentagesFromAssignments];
    cell.gradeLabel.text = totalPercentagesFromAssignments != 0 ? [NSString stringWithFormat:@"%.1f", [courseInstance averageGrade]] : @"";
    cell.gradeDetailLabel.text = [NSString stringWithFormat:@"Meðaleinkunn af %d%%", totalPercentagesFromAssignments];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"courseInstanceSegue"]) {
        CourseInstance *courseInstance = [self.courseInstances objectAtIndex:self.courseTableView.indexPathForSelectedRow.row];
        CourseInstanceViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.courseInstance = courseInstance;
    }
}

@end
