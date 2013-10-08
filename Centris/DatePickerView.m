//
//  DatePicker.m
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "DatePickerView.h"
#import "DatePickerDayView.h"

#define daysInView 7

@interface DatePickerView()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UIView *dayViews;
@property (nonatomic, strong) UILabel *weekNumberLabel;
@property (nonatomic, strong) UILabel *dateRangeLabel;
@end

@implementation DatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    // Setup information view
    self.informationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 21)];
    self.informationView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1.0];
    [self addSubview:self.informationView];
    // Add week number label to information view
    self.weekNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 64, 21)];
    self.weekNumberLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.weekNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:154.0/255.0 blue:156.0/255.0 alpha:1.0];
    self.weekNumberLabel.text = @"Vika 25";
    // Add dateRange label to information view
    [self.informationView addSubview:self.weekNumberLabel];
    self.dateRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 240, 21)];
    self.dateRangeLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.dateRangeLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:154.0/255.0 blue:156.0/255.0 alpha:1.0];
    self.dateRangeLabel.text = @"30 September - 6 Október";
    self.dateRangeLabel.textAlignment = NSTextAlignmentRight;
    [self.informationView addSubview:self.dateRangeLabel];
    
    self.dayViews = [[UIView alloc] initWithFrame:CGRectMake(0, 21, self.frame.size.width, 50)];
    [self addSubview:self.dayViews];
    
    CGFloat dayWidth = self.frame.size.width / daysInView;
    for(int i = 0; i < daysInView; i++) {
        CGRect dayViewFrame = CGRectMake(dayWidth*i, 0, dayWidth, 50);
        DatePickerDayView *dayView = [[DatePickerDayView alloc] initWithFrame:dayViewFrame];
        dayView.dayOfWeek = @"F";
        dayView.dayOfMonth = i+10;
        if (i == 3)
            dayView.selected = YES;
        [self.dayViews addSubview:dayView];
        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
