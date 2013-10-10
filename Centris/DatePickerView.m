//
//  DatePicker.m
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "DatePickerView.h"

#define daysInView 7
#define datePickerWeeks 3

@interface DatePickerView()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *dayViews;
@property (nonatomic, strong) NSMutableArray *dayViewsArray;
@property (nonatomic) NSInteger date;
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

- (void)awakeFromNib
{
    [self setup];
}

- (NSArray *)dayViewsList
{
    return [self.dayViewsArray copy];
}

- (void)tappedOnDatePickerDayView:(DatePickerDayView *)datePickerDayView;
{
    for (DatePickerDayView *dayView in self.dayViewsArray) {
        if(dayView != datePickerDayView)
            dayView.selected = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat page = self.scrollView.contentOffset.x;
    if (page < self.bounds.size.width) {
        // Go left
        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        [self.delegate datePickerDidScrollToRight:NO];
    } else if (page > self.bounds.size.width) {
        // Go right
        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        [self.delegate datePickerDidScrollToRight:YES];
    } else {
        // User did not switch page
        return;
    }
    
}

- (void)setup
{
    self.dayViewsArray = [[NSMutableArray alloc] init];
    self.date = 1;
    
    // Setup scroll view
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 26, self.bounds.size.width, 50)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * datePickerWeeks, 50);
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    [self addSubview:self.scrollView];
    // Setup dayViews view in scroll view
    self.dayViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * datePickerWeeks, self.bounds.size.height)];
    [self.scrollView addSubview:self.dayViews];
    
    // Add dayViews to self.dayViews
    CGFloat dayWidth = self.bounds.size.width / daysInView;
    for(int i = 0; i < daysInView * datePickerWeeks; i++) {
        DatePickerDayView *dayView = [[DatePickerDayView alloc] initWithFrame:CGRectMake(dayWidth*i, 0, dayWidth, 50)];
//        dayView.dayOfWeek = @"F";
//        dayView.dayOfMonth = i+1;
        dayView.delegate = self;
        [self.dayViews addSubview:dayView];
        [self.dayViewsArray addObject:dayView];
        [dayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:dayView
                                                                              action:@selector(tap:)]];
    }
    
    // Setup information view
    self.informationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 26)];
    self.informationView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1.0];
    [self addSubview:self.informationView];
    // Add week number label to information view
    self.weekNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 64, 26)];
    self.weekNumberLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.weekNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:154.0/255.0 blue:156.0/255.0 alpha:1.0];
    self.weekNumberLabel.text = [@"Vika 25" uppercaseString];
    // Add dateRange label to information view
    [self.informationView addSubview:self.weekNumberLabel];
    self.dateRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 240, 26)];
    self.dateRangeLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.dateRangeLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:154.0/255.0 blue:156.0/255.0 alpha:1.0];
    self.dateRangeLabel.text = [@"30 September - 6 Október" uppercaseString];
    self.dateRangeLabel.textAlignment = NSTextAlignmentRight;
    [self.informationView addSubview:self.dateRangeLabel];
    // Add bottom border
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1.0];
    [self addSubview:bottomBorder];
    
}

@end
