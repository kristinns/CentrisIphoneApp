//
//  AnnouncementDetailViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 14/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AnnouncementDetailViewController.h"
#import "NSDate+Helper.h"
#import "CourseInstance.h"

@interface AnnouncementDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeightConstraint;
@end

@implementation AnnouncementDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.announcement != nil) {
        self.titleLabel.text = self.announcement.title;
        self.dateLabel.text = [NSDate convertToString:self.announcement.dateInserted withFormat:@"d. MMMM YYYY"];
        self.courseLabel.text = ((CourseInstance *)self.announcement.isInCourseInstance).name;
        self.contentTextView.text = self.announcement.content;
        self.contentTextView.contentInset = UIEdgeInsetsMake(0,-5,0,0);
        // Fix iOS 7 bug, it's necessary to set the font and color after assigning the text
        self.contentTextView.font = [CentrisTheme headingMediumFont];
        self.contentTextView.textColor = [CentrisTheme grayLightTextColor];
        self.contentTextView.scrollEnabled = NO;
        CGSize newSize = [self.contentTextView sizeThatFits:CGSizeMake(self.contentTextView.frame.size.width, 2000)];
        self.contentTextViewHeightConstraint.constant = newSize.height;
    }
}

@end
