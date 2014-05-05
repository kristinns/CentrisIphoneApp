//
//  CentrisTheme.h
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CentrisTheme : NSObject
+ (UIColor *)redColor;
+ (UIColor *)grayLightColor;
+ (UIColor *)blackLightTextColor;
+ (UIColor *)grayLightTextColor;
+ (UIColor *)blackColor;

+ (UIFont *)headingBigFont;
+ (UIFont *)headingMediumFont;
+ (UIFont *)headingSmallFont;

+ (UIFont *)datePickerDayOfMonthFont;
+ (UIFont *)datePickerDayOfWeekFont;
@end
