//
//  DatePicker.m
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "DatePickerView.h"

#define daysInView 7

@interface DatePickerView()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *dayViews;
@property (nonatomic, strong) UILabel *weekNumberLabel;
@property (nonatomic, strong) UILabel *dateRangeLabel;
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

- (void)tappedOnDatePickerDayView:(DatePickerDayView *)datePickerDayView;
{
    for (DatePickerDayView *dayView in self.dayViewsArray) {
        if(dayView != datePickerDayView)
            dayView.selected = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f", self.scrollView.contentOffset.x);
    CGFloat page = self.scrollView.contentOffset.x;
    if (page < self.bounds.size.width) {
        // Go left
        self.date -= 7;
        [self changeDates];
        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    } else if (page > self.bounds.size.width) {
        // Go right
        self.date += 7;
        [self changeDates];
        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    } else {
        // User did not switch page
        return;
    }
    NSLog(@"%d",self.date);
}

- (void)changeDates
{
    for (int i=0; i < [self.dayViewsArray count]; i++) {
        DatePickerDayView *dayView = [self.dayViewsArray objectAtIndex:i];
        dayView.dayOfMonth = self.date+i;
        [dayView setNeedsDisplay];
    }
}

- (void)setup
{
    self.date = 1;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 26, self.bounds.size.width, 50)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.dayViewsArray = [[NSMutableArray alloc] init];
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width*3, 50);
    [self addSubview:self.scrollView];
    
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    
    self.dayViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width*3, self.bounds.size.height)];
    [self.scrollView addSubview:self.dayViews];
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
    
    //self.dayViews = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 21, self.bounds.size.width, 50)];
    //[self.view addSubview:self.dayViews];
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1.0];
    [self addSubview:bottomBorder];
    
    CGFloat dayWidth = self.bounds.size.width / daysInView;
    for(int i = 0; i < daysInView*5; i++) {
        CGRect dayViewFrame = CGRectMake(dayWidth*i, 0, dayWidth, 50);
        DatePickerDayView *dayView = [[DatePickerDayView alloc] initWithFrame:dayViewFrame];
        dayView.dayOfWeek = @"F";
        dayView.dayOfMonth = i+1;
        dayView.delegate = self;
        if (i == 3)
            dayView.selected = YES;
        [self.dayViews addSubview:dayView];
        [self.dayViewsArray addObject:dayView];
        [dayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:dayView
                                                                                          action:@selector(tap:)]];
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
