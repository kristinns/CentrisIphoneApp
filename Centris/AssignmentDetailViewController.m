//
//  AssignmentDetailViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 14/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentDetailViewController.h"

@interface AssignmentDetailViewController () <UITableViewDataSource>
// Assignment description outlets
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *weightLabel;
@property (nonatomic, weak) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionFileHeaderLabel;
@property (weak, nonatomic) IBOutlet UITableView *descriptionFileTableView;
// Comments from teacher outlets
@property (weak, nonatomic) IBOutlet UIView *teacherView;
@property (weak, nonatomic) IBOutlet UILabel *teacherCommentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherCommentDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *teacherCommentTextView;
@property (weak, nonatomic) IBOutlet UILabel *teacherCommentFileHeaderLabel;
@property (weak, nonatomic) IBOutlet UITableView *teacherCommentFileTableView;
// Handin outlets
@property (weak, nonatomic) IBOutlet UIView *handinView;
@property (weak, nonatomic) IBOutlet UILabel *handinTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *handinDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *handinTextView;
@property (weak, nonatomic) IBOutlet UILabel *handinFileHeaderLabel;
@property (weak, nonatomic) IBOutlet UITableView *handinFileTableView;
// Other info
@property (weak, nonatomic) IBOutlet UILabel *otherInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *otherInfoTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handinTopSpaceConstraint;


// Constraints
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *verticalBorderHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *horizontalBorderWidthConstraint;

@end

@implementation AssignmentDetailViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.verticalBorderHeightConstraint.constant = 0.5;
    self.horizontalBorderWidthConstraint.constant = 0.5;
    
    self.titleLabel.text = self.assignment.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateFormat = @"d. MMMM HH:mm";
    self.dateLabel.text = [formatter stringFromDate:self.assignment.dateClosed];
    self.weightLabel.text = [NSString stringWithFormat:@"| %@%%", self.assignment.weight];
    self.gradeLabel.text = self.assignment.grade != nil ? [NSString stringWithFormat:@"%@", self.assignment.grade] : @"";
    // Add tableView for files
    //self.descriptionFileTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 581, 89) style:UITableViewStylePlain];
    //[self.view addSubview:self.descriptionFileTable];
//    [self hideView:self.teacherView];
//    [self hideView:self.handinView];
}

- (void)hideView:(UIView *)view
{
    [view removeConstraints:view.constraints];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [view addConstraint:constraint];
}

- (void)hideHandinSection
{
    [self hideView:self.handinDateLabel];
    [self hideView:self.handinFileHeaderLabel];
    [self hideView:self.handinFileTableView];
    [self hideView:self.handinTextView];
    [self hideView:self.handinTitleLabel];
}

- (void)hideTeacherCommentSection
{
    [self hideView:self.teacherCommentTitleLabel];
    [self hideView:self.teacherCommentDateLabel];
    [self hideView:self.teacherCommentFileHeaderLabel];
    [self hideView:self.teacherCommentFileTableView];
    [self hideView:self.teacherCommentTextView];
    [self.handinTitleLabel removeConstraint:self.handinTopSpaceConstraint];
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.teacherCommentTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.descriptionFileTableView attribute:NSLayoutAttributeBottom multiplier:1 constant:17];
//    [self.handinTitleLabel addConstraint:constraint];
}

#pragma UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.descriptionFileTableView) {
        return 1;
    }
    else return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.descriptionFileTableView) {
        static NSString *CellIdentifier = @"fileCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"Lýsing.pdf";
        return cell;
    }
    // Else
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
