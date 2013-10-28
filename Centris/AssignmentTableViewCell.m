//
//  AssignmentTableViewCell.m
//  Centris
//
//  Created by Kristinn Svansson on 10/22/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentTableViewCell.h"

#define CIRCLE_POSITION_X 15
#define CIRCLE_POSITION_Y 19
#define TOP_BORDER_HEIGHT 1

@interface AssignmentTableViewCell()
@property (nonatomic, strong) UIView *topBorder;
@property (nonatomic, strong) UIImageView *circleImageView;
@end

@implementation AssignmentTableViewCell

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // Add border
    self.topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, TOP_BORDER_HEIGHT)];
    self.topBorder.backgroundColor = [CentrisTheme grayLightColor];
    [self addSubview:self.topBorder];
    // Add default image view
    self.circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected-circle-empty.png"]];
    self.circleImageView.frame = CGRectMake(CIRCLE_POSITION_X, CIRCLE_POSITION_Y, self.circleImageView.bounds.size.width, self.circleImageView.bounds.size.height);
    [self addSubview:self.circleImageView];
}

- (void)setAssignmentEventState:(AssignmentEventState)assignmentEventState
{
    [self.circleImageView removeFromSuperview];
    NSString *assignmentCircleFileToUse = assignmentEventState == AssignmentIsFinished ? @"selected-circle-full-red.png" : @"selected-circle-empty.png";
    self.circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:assignmentCircleFileToUse]];
    self.circleImageView.frame = CGRectMake(CIRCLE_POSITION_X, CIRCLE_POSITION_Y, self.circleImageView.bounds.size.width, self.circleImageView.bounds.size.height);
    [self addSubview:self.circleImageView];
}

- (void)setDisplayGrade:(BOOL)displayGrade
{
    if (displayGrade) {
        self.detailUpperLabel.textColor = [CentrisTheme redColor];
        self.detailUpperLabel.font = [CentrisTheme headingMediumFont];
    } else {
        self.detailUpperLabel.textColor = [CentrisTheme blackLightTextColor];
        self.detailUpperLabel.font = [CentrisTheme headingSmallFont];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
