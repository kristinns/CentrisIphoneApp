//
//  NSDate+Helper.h
//  Centris
//
//  Created by Kristinn Svansson on 10/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)
- (NSDate *)dateByAddingMintues:(NSInteger)minutesToAdd;
- (NSDate *)dateByAddingHours:(NSInteger)hoursToAdd;
- (NSDate *)dateByAddingDays:(NSInteger)daysToAdd;
- (NSDate *)dateByAddingWeeks:(NSInteger)weeksToAdd;
+ (NSDate *)formatDateString:(NSString *)dateString;
+ (NSString *)formateDateToHourAndMinutesStringForDate:(NSDate *)date;
+ (NSDictionary *)dateRangeForTheWholeDay:(NSDate *)date;
+ (NSDictionary *)dateRangeToMidnightFromDate:(NSDate *)date;
+ (NSDictionary *)dateRangeToNextMorning:(NSDate *)date;
+ (NSDateComponents *)dateComponentForDate:(NSDate *)date;
@end
