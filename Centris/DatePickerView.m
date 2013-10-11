//
//  DatePicker.m
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "DatePickerView.h"

#define DAYS_IN_WEEK 7
#define DATE_PICKER_WEEKS_TO_LOAD 3
#define INFORMATION_VIEW_HEIGHT 26.0
#define INFORMATION_VIEW_PADDING 15
#define DAY_VIEW_HEIGHT 50.0
#define BORDER_HEIGHT 1.0

@interface DatePickerView()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *dayViews;
@property (nonatomic, strong) NSMutableArray *dayViewsArray;
@end

@implementation DatePickerView

#pragma Initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.dayViewsArray = [[NSMutableArray alloc] init];
    
    // Setup scroll view
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, INFORMATION_VIEW_HEIGHT, self.bounds.size.width, DAY_VIEW_HEIGHT)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * DATE_PICKER_WEEKS_TO_LOAD, DAY_VIEW_HEIGHT);
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    [self addSubview:self.scrollView];
    // Setup dayViews view in scroll view
    self.dayViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * DATE_PICKER_WEEKS_TO_LOAD, self.bounds.size.height)];
    [self.scrollView addSubview:self.dayViews];
    
    // Add dayViews to self.dayViews
    CGFloat dayWidth = self.bounds.size.width / DAYS_IN_WEEK;
    for(int i = 0; i < DAYS_IN_WEEK * DATE_PICKER_WEEKS_TO_LOAD; i++) {
        DatePickerDayView *dayView = [[DatePickerDayView alloc] initWithFrame:CGRectMake(dayWidth*i, 0, dayWidth, DAY_VIEW_HEIGHT)];
        // Set this view as delegate for DatePickerDayView
        dayView.delegate = self;
        [self.dayViews addSubview:dayView];
        [self.dayViewsArray addObject:dayView];
        [dayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:dayView
                                                                              action:@selector(tap:)]];
    }
    
    // Setup information view
    self.informationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, INFORMATION_VIEW_HEIGHT)];
    self.informationView.backgroundColor = [CentrisTheme grayLightColor];
    [self addSubview:self.informationView];
    // Add week number label to information view
    self.weekNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFORMATION_VIEW_PADDING, 0, self.bounds.size.width-INFORMATION_VIEW_PADDING, INFORMATION_VIEW_HEIGHT)];
    self.weekNumberLabel.font = [CentrisTheme headingSmallFont];
    self.weekNumberLabel.textColor = [CentrisTheme grayLightTextColor];
    self.weekNumberLabel.text = [@"Vika 25" uppercaseString];
    // Add dateRange label to information view
    [self.informationView addSubview:self.weekNumberLabel];
    self.dateRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-INFORMATION_VIEW_PADDING, INFORMATION_VIEW_HEIGHT)];
    self.dateRangeLabel.font = [CentrisTheme headingSmallFont];
    self.dateRangeLabel.textColor = [CentrisTheme grayLightTextColor];
    self.dateRangeLabel.text = [@"30 September - 6 Október" uppercaseString];
    self.dateRangeLabel.textAlignment = NSTextAlignmentRight;
    [self.informationView addSubview:self.dateRangeLabel];
    // Add bottom border
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-BORDER_HEIGHT, self.bounds.size.width, BORDER_HEIGHT)];
    bottomBorder.backgroundColor = [CentrisTheme grayLightColor];
    [self addSubview:bottomBorder];
    
}

#pragma Get methods
- (NSArray *)dayViewsList
{   // Return copy of array to prevent others from resizing this array
    return [self.dayViewsArray copy];
}

#pragma Delegate methods
- (void)tappedOnDatePickerDayView:(DatePickerDayView *)datePickerDayView;
{
    NSInteger index = [self.dayViewsArray indexOfObject:datePickerDayView];
    [self.delegate datePickerDidSelectDayAtIndex:index];
    // Unselect every dayView except the dayView which wastapped on
    for (DatePickerDayView *dayView in self.dayViewsArray)
        dayView.selected = dayView == datePickerDayView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat contentOffset = self.scrollView.contentOffset.x;
    // If scroll view did not go to another page, then return
    if (contentOffset == self.bounds.size.width)
        return;
    // Else move contentOffset back to center
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    [self.delegate datePickerDidScrollToRight:(contentOffset > self.bounds.size.width)];
}

@end
