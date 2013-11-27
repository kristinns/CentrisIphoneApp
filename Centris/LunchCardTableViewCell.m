//
//  LunchCardTableViewCell.m
//  Centris
//
//  Created by Kristinn Svansson on 26/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "LunchCardTableViewCell.h"

@interface LunchCardTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalBorderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalBorderWidthConstraint;
@end

@implementation LunchCardTableViewCell

- (void)layoutSubviews
{
    // Fix padding in textView
    self.textView.contentInset = UIEdgeInsetsMake(-5,-5,0,0);
    self.textView.font = [CentrisTheme headingSmallFont];
    self.textView.scrollEnabled = NO;
    
    self.horizontalBorderWidthConstraint.constant = 0.5;
    self.verticalBorderHeightConstraint.constant = 0.5;
    self.backgroundColor = [UIColor clearColor];
}

@end
