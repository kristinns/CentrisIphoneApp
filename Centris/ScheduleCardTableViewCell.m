//
//  ScheduleCardTableViewCell.m
//  Centris
//
//  Created by Kristinn Svansson on 24/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleCardTableViewCell.h"

@interface ScheduleCardTableViewCell()
@property (nonatomic, strong) UIView *view;
@end

@implementation ScheduleCardTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 17, frame.size.width, frame.size.height-17)];
        self.view.backgroundColor = [UIColor colorWithRed:239.0 green:241.0 blue:248.0 alpha:0.4];
        [self addSubview:self.view];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
