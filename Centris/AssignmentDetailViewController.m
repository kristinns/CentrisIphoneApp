//
//  AssignmentDetailViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 14/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentDetailViewController.h"
#import "AssignmentDetailViewFileCell.h"
#import "AssignmentFileViewController.h"
#import "DataFetcher.h"
#import "AppFactory.h"
#import "Assignment+Centris.h"
#import "AssignmentFile+Centris.h"
#import "CourseInstance+Centris.h"
#import <HTProgressHUD/HTProgressHUD.h>
#import "TestFlight.h"

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

@property (strong, nonatomic) HTProgressHUD *HUD;

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
    [TestFlight passCheckpoint:@"Assignment Detail View opened"];
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
    self.gradeLabel.text = self.assignment.grade != nil ? [NSString stringWithFormat:@"%.1f", [self.assignment.grade floatValue]] : @"";
    self.descriptionTextView.text = @"";
    self.teacherCommentTextView.text = @"";
    self.handinDateLabel.text = @"";
    self.descriptionDateLabel.text = @"";
    self.teacherCommentDateLabel.text = @"";
    self.HUD = [[HTProgressHUD alloc] init];
    self.HUD.text = @"Sæki verkefni..";
    [self.HUD showInView:self.view];
    [self fetchAssignmentFromAPI];
}

- (void)updateOutlets
{
    [self.HUD hide];
    // Reload table views to get newest data
    [self.descriptionFileTableView reloadData];
    [self.handinFileTableView reloadData];
    [self.teacherCommentFileTableView reloadData];
    
    self.titleLabel.text = self.assignment.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateFormat = @"d. MMMM HH:mm";
    self.dateLabel.text = [formatter stringFromDate:self.assignment.dateClosed];
    self.weightLabel.text = [NSString stringWithFormat:@"| %@%%", self.assignment.weight];
    self.gradeLabel.text = self.assignment.grade != nil ? [NSString stringWithFormat:@"%.1f", [self.assignment.grade floatValue]] : @"";
    self.descriptionTextView.text = [self.assignment.assignmentDescription length] != 0 ? self.assignment.assignmentDescription : @"Engin lýsing..";
    self.teacherCommentTextView.text = [self.assignment.teacherMemo length] != 0 ? self.assignment.teacherMemo : @"Engin athugasemd..";
    self.handinTextView.text = [self.assignment.studentMemo length] != 0 ? self.assignment.studentMemo : @"Engin textaskil..";;
    
    // Go through text views and calculate the content height and add constraint with that height
    NSArray *textViewArray = @[self.descriptionTextView, self.handinTextView, self.teacherCommentTextView];
    for (UITextView *textView in textViewArray) {
        if ([textView.text length] > 500) {
            NSRange range = [textView.text rangeOfComposedCharacterSequencesForRange:(NSRange){0, 500}];
            textView.text = [textView.text substringWithRange:range];
            textView.text = [textView.text stringByAppendingString:@"… meira"];
            NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:textView.text];
            [attributeText addAttribute: NSForegroundColorAttributeName value:[CentrisTheme redColor] range:(NSRange){0, [textView.text length]}];
            [attributeText addAttribute: NSForegroundColorAttributeName value:[CentrisTheme grayLightTextColor] range:(NSRange){0, [textView.text length]-6}];
            textView.attributedText = attributeText;
        } else {
            textView.textColor = [CentrisTheme grayLightTextColor];
        }
        // Fix iOS 7 bug, it's necessary to set the font and color after assigning the text
        textView.font = [CentrisTheme headingSmallFont];
        textView.scrollEnabled = NO;
        // Add gesture recognizer
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOnTextViewRecognized:)];
        singleTap.numberOfTapsRequired = 1;
        [textView addGestureRecognizer:singleTap];
        CGSize newSize = [textView sizeThatFits:CGSizeMake(290, 2000)];
        // Add height constraint
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:(newSize.height)+10]; // The calculation is not correct, trying to fix it
        [textView addConstraint:constraint];
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
    
    // Remove unneeded views
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
}

- (void)singleTapOnTextViewRecognized:(UIGestureRecognizer *)gestureRecognizer {
    UITextView *textView = (UITextView *)gestureRecognizer.view;
    id constraint = [textView.constraints lastObject];
    NSString *originalText;
    if (self.descriptionTextView == textView)
        originalText = self.assignment.assignmentDescription;
    else if (self.handinTextView == textView)
        originalText = self.assignment.studentMemo;
    if (self.teacherCommentTextView == textView)
        originalText = self.assignment.teacherMemo;
    if ([originalText length] != 0 && ![originalText isEqualToString:textView.text]) {
        textView.text = originalText;
        if ([constraint isKindOfClass:[NSLayoutConstraint class]]) {
            [UITextView animateWithDuration:1
                                 animations:^{
                                     NSLayoutConstraint *layoutConstraint = constraint;
                                     layoutConstraint.constant = [textView sizeThatFits:CGSizeMake(290, 2000)].height+10;
                                     [self.view layoutIfNeeded];
                                 }];
        }
        // Fix iOS 7 bug, it's necessary to set the font and color after assigning the text
        textView.font = [CentrisTheme headingSmallFont];
        textView.textColor = [CentrisTheme grayLightTextColor];
    }
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting assignment %@/%@", self.assignment.isInCourseInstance.id, self.assignment.id);
    }];
}

#pragma UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.descriptionFileTableView) {
        return [[self assignmentsWithType:@"DescriptionFile"] count];
    } else if (tableView == self.handinFileTableView) {
        return [[self assignmentsWithType:@"SolutionFile"] count];
    } else if (tableView == self.teacherCommentFileTableView) {
        return [[self assignmentsWithType:@"TeacherFile"] count];
    }
    // Else
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	AssignmentFileViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AssignmentFileView"];
    if (tableView == self.descriptionFileTableView) {
        AssignmentFile *file = [[self assignmentsWithType:@"DescriptionFile"] objectAtIndex:indexPath.row];
        controller.url = file.url;
    } else if (tableView == self.handinFileTableView) {
        AssignmentFile *file = [[self assignmentsWithType:@"SolutionFile"] objectAtIndex:indexPath.row];
        controller.url = file.url;
    } else if (tableView == self.teacherCommentFileTableView) {
        AssignmentFile *file = [[self assignmentsWithType:@"TeacherFile"] objectAtIndex:indexPath.row];
        controller.url = file.url;
    }
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
    AssignmentDetailViewFileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AssignmentDetailViewFileCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0)
        [cell addTopBorder];
    
    if (tableView == self.descriptionFileTableView) {
        cell.fileNameLabel.text = [[[self assignmentsWithType:@"DescriptionFile"] objectAtIndex:indexPath.row] fileName];
    } else if (tableView == self.handinFileTableView) {
        cell.fileNameLabel.text = [[[self assignmentsWithType:@"SolutionFile"] objectAtIndex:indexPath.row] fileName];
    } else if (tableView == self.teacherCommentFileTableView) {
        cell.fileNameLabel.text = [[[self assignmentsWithType:@"TeacherFile"] objectAtIndex:indexPath.row] fileName];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
