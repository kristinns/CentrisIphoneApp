//
//  DatePickerDayView.m
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "DatePickerDayView.h"

@interface DatePickerDayView()
@property (nonatomic, strong) UILabel *dayOfWeekLabel;
@property (nonatomic, strong) UILabel *dayOfMonthLabel;
@property (nonatomic, strong) UIView *selectedCircleView;
@end

@implementation DatePickerDayView

- (void)setDayOfMonth:(NSInteger)dayOfMonth
{
    _dayOfMonth = dayOfMonth;
    self.dayOfMonthLabel.text = [NSString stringWithFormat:@"%d", dayOfMonth];
}
- (void)setDayOfWeek:(NSString *)dayOfWeek
{
    _dayOfWeek = dayOfWeek;
    self.dayOfWeekLabel.text = _dayOfWeek;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Setup circle for selected view
        self.selectedCircleView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width-26)/2, 17, 26.0, 26.0)];
        self.selectedCircleView.layer.cornerRadius = self.selectedCircleView.bounds.size.width/2;
        self.selectedCircleView.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:23.0/255.0 blue:41.0/255.0 alpha:1.0];
        [self addSubview:self.selectedCircleView];
        // Setup labels
        [self setupDayOfWeekLabel];
        [self setupDayOfMonthLabel];
        self.selected = NO;
    }
    return self;
}

- (void)setToday:(BOOL)today
{
    if (today)
        self.selectedCircleView.hidden = YES;
    else
        self.selectedCircleView.hidden = NO;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1];
        self.dayOfMonthLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.dayOfMonthLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:65.0/255.0 alpha:1];
    }
}

- (void)setupDayOfWeekLabel
{
    CGRect frame = CGRectMake(0, 4, self.bounds.size.width, 10);
    self.dayOfWeekLabel = [[UILabel alloc] initWithFrame:frame];
    self.dayOfWeekLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:100.0/255.0 blue:102.0/255.0 alpha:1];
    self.dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
    self.dayOfWeekLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:9];
    [self addSubview:self.dayOfWeekLabel];
}

- (void)setupDayOfMonthLabel
{
    CGRect frame = CGRectMake(0, 19, self.bounds.size.width, 20);
    self.dayOfMonthLabel = [[UILabel alloc] initWithFrame:frame];
    self.dayOfMonthLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:65.0/255.0 alpha:1];
    self.dayOfMonthLabel.textAlignment = NSTextAlignmentCenter;
    self.dayOfMonthLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    [self addSubview:self.dayOfMonthLabel];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    [self setSelected:YES];
    [self.delegate tappedOnDatePickerDayView:self];
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
