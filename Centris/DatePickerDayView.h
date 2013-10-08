//
//  DatePickerDayView.h
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerDayView : UIView
@property (nonatomic, strong) NSString *dayOfWeek;
@property (nonatomic) NSInteger dayOfMonth;
@property (nonatomic) BOOL selected;
@end
