//
//  EventCardTableViewCell.m
//  Centris
//
//  Created by Kristinn Svansson on 27/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "EventCardTableViewCell.h"

@interface EventCardTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalBorderWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalBorderHeightConstraint;
@end

@implementation EventCardTableViewCell

- (void)layoutSubviews
{
    self.horizontalBorderWidthConstraint.constant = 0.5;
    self.verticalBorderHeightConstraint.constant = 0.5;
    self.backgroundColor = [UIColor clearColor];
}

@end
