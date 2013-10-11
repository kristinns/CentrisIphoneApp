//
//  CentrisTheme.h
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CentrisTheme : NSObject
+ (UIColor *)sideMenuBackgroundColor;
+ (UIColor *)sideMenuSelectedRowColor;
+ (UIColor *)navigationBarColor;
+ (UIColor *)grayLightColor;
+ (UIColor *)blackLightTextColor;
+ (UIColor *)grayLightTextColor;

+ (UIFont *)headingBigFont;
+ (UIFont *)headingMediumFont;
+ (UIFont *)headingSmallFont;
@end
