//
//  DatePickerDayView.m
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "DatePickerDayView.h"

#define TODAY_CIRCLE_DIAMETER 26.0
#define TODAY_CIRCLE_POSITION 17.0

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
        self.selectedCircleView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width-TODAY_CIRCLE_DIAMETER)/2, TODAY_CIRCLE_POSITION, TODAY_CIRCLE_DIAMETER, TODAY_CIRCLE_DIAMETER)];
        self.selectedCircleView.layer.cornerRadius = self.selectedCircleView.bounds.size.width/2;
        self.selectedCircleView.backgroundColor = [CentrisTheme navigationBarColor];
        [self addSubview:self.selectedCircleView];
        // Setup labels
        [self setupDayOfWeekLabel];
        [self setupDayOfMonthLabel];
        // Set defaults
        self.selected = NO;
        self.selectedCircleView.hidden = YES;
    }
    return self;
}

- (void)setToday:(BOOL)today
{
    if (today) {
        self.selectedCircleView.hidden = NO;
        self.dayOfMonthLabel.textColor = [UIColor whiteColor];
    } else {
        self.selectedCircleView.hidden = YES;
        self.dayOfMonthLabel.textColor = [CentrisTheme blackLightTextColor];
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        self.backgroundColor = [CentrisTheme grayLightColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setupDayOfWeekLabel
{
    CGRect frame = CGRectMake(0, 4, self.bounds.size.width, 10);
    self.dayOfWeekLabel = [[UILabel alloc] initWithFrame:frame];
    self.dayOfWeekLabel.textColor = [CentrisTheme grayLightTextColor];
    self.dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
    self.dayOfWeekLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:9];
    [self addSubview:self.dayOfWeekLabel];
}

- (void)setupDayOfMonthLabel
{
    CGRect frame = CGRectMake(0, 19, self.bounds.size.width, 20);
    self.dayOfMonthLabel = [[UILabel alloc] initWithFrame:frame];
    self.dayOfMonthLabel.textColor = [CentrisTheme blackLightTextColor];
    self.dayOfMonthLabel.textAlignment = NSTextAlignmentCenter;
    self.dayOfMonthLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    [self addSubview:self.dayOfMonthLabel];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    [self setSelected:YES];
    [self.delegate tappedOnDatePickerDayView:self];
}

@end
