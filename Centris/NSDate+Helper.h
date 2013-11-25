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

+ (NSDate *)convertToDate:(NSString *)dateString withFormat:(NSString *)format;
+ (NSString *)convertToString:(NSDate *)date withFormat:(NSString *)format;

+ (NSDictionary *)dateRangeForTheWholeDay:(NSDate *)date;
+ (NSDictionary *)dateRangeToMidnightFromDate:(NSDate *)date;
+ (NSDictionary *)dateRangeToNextMorning:(NSDate *)date;
+ (NSDateComponents *)dateComponentForDate:(NSDate *)date withCalendar:(NSCalendar *)calendar;
@end
