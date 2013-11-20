//
//  AssignmentDetailViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 14/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentDetailViewController.h"
#import "AssignmentDetailViewCell.h"
#import "AssignmentFileViewController.h"
#import "DataFetcher.h"
#import "AppFactory.h"
#import "Assignment+Centris.h"
#import "AssignmentFile+Centris.h"
#import "CourseInstance+Centris.h"

@interface AssignmentDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// Assignment description outlets
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *weightLabel;
@property (nonatomic, weak) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *descriptionFileView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionFileHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *descriptionFileTableView;
// Comments from teacher outlets
@property (weak, nonatomic) IBOutlet UIView *teacherView;
@property (weak, nonatomic) IBOutlet UILabel *teacherCommentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherCommentDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *teacherCommentTextView;
@property (weak, nonatomic) IBOutlet UIView *teacherCommentFileView;
@property (weak, nonatomic) IBOutlet UILabel *teacherCommentFileHeaderLabel;
@property (weak, nonatomic) IBOutlet UITableView *teacherCommentFileTableView;
// Handin outlets
@property (weak, nonatomic) IBOutlet UIView *handinView;
@property (weak, nonatomic) IBOutlet UILabel *handinTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *handinDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *handinTextView;
@property (weak, nonatomic) IBOutlet UIView *handinFileView;
@property (weak, nonatomic) IBOutlet UILabel *handinFileHeaderLabel;
@property (weak, nonatomic) IBOutlet UITableView *handinFileTableView;
// Other info
@property (weak, nonatomic) IBOutlet UILabel *otherInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *otherInfoTableView;

// Constraints
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *verticalBorderHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *horizontalBorderWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionFileTableViewHeightConstraint;

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
    // Fix width and height on borders, not possible in storyboard
    self.verticalBorderHeightConstraint.constant = 0.5;
    self.horizontalBorderWidthConstraint.constant = 0.5;
    
    // Set delegates and datasources
    self.descriptionFileTableView.dataSource = self;
    self.descriptionFileTableView.delegate = self;
    self.handinFileTableView.dataSource = self;
    self.handinFileTableView.delegate = self;
    self.teacherCommentFileTableView.dataSource = self;
    self.teacherCommentFileTableView.delegate = self;
    
    self.titleLabel.text = self.assignment.title;
    self.titleLabel.text = self.assignment.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateFormat = @"d. MMMM HH:mm";
    self.weightLabel.text = [NSString stringWithFormat:@"| %@%%", self.assignment.weight];
    self.gradeLabel.text = self.assignment.grade != nil ? [NSString stringWithFormat:@"%@", self.assignment.grade] : @"";
    self.descriptionTextView.text = @"";
    self.teacherCommentTextView.text = @"";
    self.handinDateLabel.text = @"";
    self.descriptionDateLabel.text = @"";
    self.teacherCommentDateLabel.text = @"";
    [self fetchAssignmentFromAPI];
}

- (void)updateOutlets
{
    // Debug
//    self.teacherCommentFileHeaderLabel.textColor = [UIColor redColor];
//    self.handinFileHeaderLabel.textColor = [UIColor yellowColor];
//    self.descriptionFileHeaderLabel.textColor = [UIColor greenColor];
    
    if (self.assignment.grade == nil)
        [self.teacherView removeFromSuperview];
    if (self.assignment.handInDate == nil)
        [self.handinView removeFromSuperview];
    if ([[self assignmentsWithType:@"DescriptionFile"] count] == 0)
        [self.descriptionFileView removeFromSuperview];
    if ([[self assignmentsWithType:@"SolutionFile"] count] == 0)
        [self.handinFileView removeFromSuperview];
    if ([[self assignmentsWithType:@"TeacherFile"] count] == 0)
        [self.teacherCommentFileView removeFromSuperview];
    
    [self.descriptionFileTableView reloadData];
    [self.handinFileTableView reloadData];
    [self.teacherCommentFileTableView reloadData];
    
    self.titleLabel.text = self.assignment.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateFormat = @"d. MMMM HH:mm";
    self.dateLabel.text = [formatter stringFromDate:self.assignment.dateClosed];
    self.weightLabel.text = [NSString stringWithFormat:@"| %@%%", self.assignment.weight];
    self.gradeLabel.text = self.assignment.grade != nil ? [NSString stringWithFormat:@"%@", self.assignment.grade] : @"";
    self.descriptionTextView.text = [self.assignment.assignmentDescription length] != 0 ? self.assignment.assignmentDescription : @"Engin lýsing..";
    self.teacherCommentTextView.text = [self.assignment.teacherMemo length] != 0 ? self.assignment.teacherMemo : @"Engin athugasemd..";
    self.handinTextView.text = [self.assignment.studentMemo length] != 0 ? self.assignment.studentMemo : @"Engin textaskil..";;
    // Fix iOS 7 bug, it's necessary to set the font and color after assigning the text
    self.descriptionTextView.font = [CentrisTheme headingSmallFont];
    self.descriptionTextView.textColor = [CentrisTheme grayLightTextColor];
    self.teacherCommentTextView.font = [CentrisTheme headingSmallFont];
    self.teacherCommentTextView.textColor = [CentrisTheme grayLightTextColor];
    self.handinTextView.font = [CentrisTheme headingSmallFont];
    self.handinTextView.textColor = [CentrisTheme grayLightTextColor];
    
    if ([self.assignment.assignmentDescription length] == 0) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.descriptionTextView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
        [self.descriptionTextView addConstraint:constraint];
    }
    
    if ([self.assignment.studentMemo length] == 0) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.handinTextView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
        [self.handinTextView addConstraint:constraint];
    }
    
    if ([self.assignment.teacherMemo length] == 0) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.teacherCommentTextView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
        [self.teacherCommentTextView addConstraint:constraint];
    }

    // Create list of all table views
    NSArray *tableViews = @[self.descriptionFileTableView, self.handinFileTableView, self.teacherCommentFileTableView];//, self.otherInfoTableView];
    // Fix height on table view list
    for (UITableView *tableView in tableViews) {
        [tableView removeConstraints:tableView.constraints];
        NSInteger height = tableView.contentSize.height;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
        [tableView addConstraint:constraint];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [self.view layoutIfNeeded];
}

- (void)fetchAssignmentFromAPI
{
    CourseInstance *courseInstance = self.assignment.isInCourseInstance;
    [[AppFactory fetcherFromConfiguration] getAssignmentById:[self.assignment.id integerValue] courseId:[courseInstance.id integerValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got assignment %@", [responseObject objectForKey:@"Title"]);
        // Add assignment to core data
        [Assignment updateAssignmentWithCentrisInfo:responseObject inManagedObjectContext:[AppFactory managedObjectContext]];      // Update our assignment
        self.assignment = [Assignment assignmentWithID:self.assignment.id inManagedObjectContext:[AppFactory managedObjectContext]];
        [self updateOutlets];
        [self.descriptionFileTableView reloadData];
        [self.handinFileTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting assignment %@/%@", self.assignment.isInCourseInstance.id, self.assignment.id);
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    // just add this line to the end of this method or create it if it does not exist
    //[self.descriptionFileTableView reloadData];
}

-(void)viewDidLayoutSubviews
{
    
}

#pragma UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *fileDescription;
    NSInteger count = 0;
    if (tableView == self.descriptionFileTableView)
        fileDescription = @"DescriptionFile";
    else if (tableView == self.handinFileTableView)
        fileDescription = @"SolutionFile";
    
    
    for (AssignmentFile *file in self.assignment.hasFiles) {
        if ([file.type isEqualToString:fileDescription])
            count++;
    }
    return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	AssignmentFileViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AssignmentFileView"];
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSArray *)assignmentsWithType:(NSString *)type
{
    CourseInstance *courseInstance = self.assignment.isInCourseInstance;
    if (courseInstance) {
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"fileName" ascending:YES];
        NSArray *sortedAssignmentFileList = [self.assignment.hasFiles sortedArrayUsingDescriptors:@[descriptor]];
        NSMutableArray *sortedAssignmentFileListWithRightType = [[NSMutableArray alloc] init];
        for (AssignmentFile *file in sortedAssignmentFileList) {
            if ([file.type isEqualToString:type])
                [sortedAssignmentFileListWithRightType addObject:file];
        }
        return sortedAssignmentFileListWithRightType;
    }
    // Else
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"fileCell";
    AssignmentDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AssignmentDetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0)
        [cell addTopBorder];
    
    if (tableView == self.descriptionFileTableView) {
        cell.textLabel.text = [[[self assignmentsWithType:@"DescriptionFile"] objectAtIndex:indexPath.row] fileName];
    } else if (tableView == self.handinFileTableView) {
        cell.textLabel.text = [[[self assignmentsWithType:@"SolutionFile"] objectAtIndex:indexPath.row] fileName];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
