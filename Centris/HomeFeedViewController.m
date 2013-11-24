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
#import "User+Centris.h"
#import "AppFactory.h"
#import "ScheduleCardTableViewCell.h"

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
    
    [self.tableView reloadData];
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, 300)];
    // Add height constraint
    NSLayoutConstraint *textViewConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:(newSize.height)+10]; // The calculation is not correct, trying to fix it
    [self.textView addConstraint:textViewConstraint];
    
    // Fix tableView height
    NSInteger height = self.tableView.contentSize.height;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    [self.tableView addConstraint:constraint];
    [self.view layoutIfNeeded];
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
    return 90;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, self.tableView.frame.origin.y, self.tableView.frame.size.width-20, 14)];
    sectionHeader.textColor = [CentrisTheme blackLightTextColor];
    sectionHeader.font = [CentrisTheme headingSmallFont];
    sectionHeader.text = @"     Í DAG";
    return sectionHeader;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCardTableViewCell *tableViewCell = [[ScheduleCardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 81)];
    return tableViewCell;
}

@end
