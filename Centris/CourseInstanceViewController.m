//
//  CourseInstanceViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 11/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstanceViewController.h"
#import "PNChart.h"

@interface CourseInstanceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *materialTableView;
@property (weak, nonatomic) IBOutlet PNChart *circleChartView;
@property (weak, nonatomic) IBOutlet UIView *chartContainerView;
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
    
    self.circleChartView.type = PNCircleType;
    self.circleChartView.total = @100;
    self.circleChartView.current = @60;
    self.circleChartView.strokeColor = [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0];
    [self.circleChartView strokeChart];
    self.circleChartView.circleChart.lineWidth = @5;
    self.circleChartView.circleChart.circleBG.strokeColor = [[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] CGColor];
    self.circleChartView.circleChart.circleBG.fillColor = [[UIColor whiteColor] CGColor];
    [self.circleChartView.circleChart strokeChart];
    
    //For BarChart
    PNChart *barChart = [[PNChart alloc] initWithFrame:self.chartContainerView.frame];
    barChart.type = PNBarType;
    barChart.backgroundColor = [UIColor clearColor];
    barChart.type = PNBarType;
    [barChart setStrokeColor:[UIColor whiteColor]];
    [barChart setXLabels:@[@"",@""]];//,@"",@"",@"",@"",@"",@"",@"",@""]];
    [barChart setYValues:@[@1, @10]];//, @2, @6, @3,@1,  @10, @2, @6, @3]];
    [barChart strokeChart];
    
    [self.chartContainerView addSubview:barChart];
    
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
