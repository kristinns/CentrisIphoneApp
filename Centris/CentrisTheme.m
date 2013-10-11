//
//  CentrisTheme.m
//  Centris
//
//	Handles all the theme styles for the app
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CentrisTheme.h"

@implementation CentrisTheme

+ (UIColor *)redColor {
	return [UIColor colorWithRed:208.0/255.0 green:23.0/255.0 blue:41.0/255.0 alpha:1.0]; // Centris red
}

+ (UIColor *)grayLightColor
{
    return [UIColor colorWithRed:244.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1.0];
}

+ (UIColor *)grayLightTextColor
{
    return [UIColor colorWithRed:153.0/255.0 green:154.0/255.0 blue:156.0/255.0 alpha:1.0];
}

+ (UIColor *)blackLightTextColor
{
    return [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:65.0/255.0 alpha:1];
}

+ (UIFont *)headingBigFont
{
    return [UIFont fontWithName:@"Helvetica Neue" size:20];
}

+ (UIFont *)headingMediumFont
{
    return [UIFont fontWithName:@"Helvetica Neue" size:17.5];
}

+ (UIFont *)headingSmallFont
{
    return [UIFont fontWithName:@"Helvetica Neue" size:14];
}

+ (UIFont *)datePickerDayOfMonthFont
{
    return [UIFont fontWithName:@"Helvetica Neue" size:16];
}

+ (UIFont *)datePickerDayOfWeekFont
{
    return [UIFont fontWithName:@"Helvetica Neue" size:9];
}

@end
