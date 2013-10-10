//
//  DatePickerDayView.h
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerDayView;
@protocol DatePickerDayViewProtocol <NSObject>
- (void)tappedOnDatePickerDayView:(DatePickerDayView *)datePickerDayView;
@end

@interface DatePickerDayView : UIView
@property (nonatomic, strong) NSString *dayOfWeek;
@property (nonatomic) NSInteger dayOfMonth;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic, getter = isToday) BOOL today;
@property (nonatomic) id<DatePickerDayViewProtocol> delegate;
@end
