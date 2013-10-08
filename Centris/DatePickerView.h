//
//  DatePicker.h
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerDayView.h"

@interface DatePickerView : UIScrollView<DatePickerDayViewProtocol>
@property (nonatomic, strong) UIView *view;
- (void)tappedOnDatePickerDayView:(DatePickerDayView *)datePickerDayView;
@end
