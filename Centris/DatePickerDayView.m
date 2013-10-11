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
#define DAY_OF_MONTH_LABEL_Y_POSITION 19
#define DAY_OF_MONTH_LABEL_HEIGHT 20
#define DAY_OF_WEEK_LABEL_Y_POSITION 4
#define DAY_OF_WEEK_LABEL_HEIGHT 10

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
        self.selectedCircleView.backgroundColor = [CentrisTheme redColor];
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
    // If selected, select grayLightColor, else whiteColor
    self.backgroundColor = selected ? [CentrisTheme grayLightColor] : [UIColor whiteColor];
}

- (void)setupDayOfWeekLabel
{
    CGRect frame = CGRectMake(0, DAY_OF_WEEK_LABEL_Y_POSITION, self.bounds.size.width, DAY_OF_WEEK_LABEL_HEIGHT);
    self.dayOfWeekLabel = [[UILabel alloc] initWithFrame:frame];
    self.dayOfWeekLabel.textColor = [CentrisTheme grayLightTextColor];
    self.dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
    self.dayOfWeekLabel.font = [CentrisTheme datePickerDayOfWeekFont];
    [self addSubview:self.dayOfWeekLabel];
}

- (void)setupDayOfMonthLabel
{
    CGRect frame = CGRectMake(0, DAY_OF_MONTH_LABEL_Y_POSITION, self.bounds.size.width, DAY_OF_MONTH_LABEL_HEIGHT);
    self.dayOfMonthLabel = [[UILabel alloc] initWithFrame:frame];
    self.dayOfMonthLabel.textColor = [CentrisTheme blackLightTextColor];
    self.dayOfMonthLabel.textAlignment = NSTextAlignmentCenter;
    self.dayOfMonthLabel.font = [CentrisTheme datePickerDayOfMonthFont];
    [self addSubview:self.dayOfMonthLabel];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    [self setSelected:YES];
    [self.delegate tappedOnDatePickerDayView:self];
}

@end
