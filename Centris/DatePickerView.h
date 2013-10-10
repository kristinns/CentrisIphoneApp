//
//  DatePicker.h
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerDayView.h"

@protocol DatePickerViewDelegateProtocol <NSObject>
- (void)datePickerDidScrollToRight:(BOOL)right;
- (void)datePickerDidSelectDayAtIndex:(NSInteger)dayIndex;
@end

@interface DatePickerView : UIView<DatePickerDayViewProtocol, UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *weekNumberLabel;
@property (nonatomic, strong) UILabel *dateRangeLabel;
@property (nonatomic, strong) id<DatePickerViewDelegateProtocol> delegate;
- (NSArray *)dayViewsList;
@end
