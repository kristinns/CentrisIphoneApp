//
//  AssignmentDetailViewCell.m
//  Centris
//
//  Created by Kristinn Svansson on 18/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentDetailViewFileCell.h"

@implementation AssignmentDetailViewFileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *fileIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"document-icon.png"]];
        fileIcon.frame = CGRectMake(13, (self.frame.size.height-16)/2, 12, 16);
        [self addSubview:fileIcon];
        self.fileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.frame.size.width-44, self.frame.size.height)];
        self.fileNameLabel.textColor = [CentrisTheme grayLightTextColor];
        self.fileNameLabel.font = [CentrisTheme headingSmallFont];
        [self addSubview:self.fileNameLabel];
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
