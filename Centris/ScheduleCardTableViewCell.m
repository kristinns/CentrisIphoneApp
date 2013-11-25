//
//  ScheduleCardTableViewCell.m
//  Centris
//
//  Created by Kristinn Svansson on 24/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleCardTableViewCell.h"

@interface ScheduleCardTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalBorderWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalBorderHeightConstraint;
@end

@implementation ScheduleCardTableViewCell

- (void)layoutSubviews
{
    self.horizontalBorderWidthConstraint.constant = 0.5;
    self.verticalBorderHeightConstraint.constant = 0.5;
    self.backgroundColor = [UIColor clearColor];
}

@end
