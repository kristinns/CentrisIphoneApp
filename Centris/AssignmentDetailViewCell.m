//
//  AssignmentDetailViewCell.m
//  Centris
//
//  Created by Kristinn Svansson on 18/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentDetailViewCell.h"

@implementation AssignmentDetailViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [CentrisTheme grayLightTextColor];
        self.textLabel.font = [CentrisTheme headingSmallFont];
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
        borderView.backgroundColor = [CentrisTheme grayLightColor];
        [self addSubview:borderView];
    }
    return self;
}
- (void)addTopBorder
{
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    borderView.backgroundColor = [CentrisTheme grayLightColor];
    [self addSubview:borderView];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:NO];
}

@end
