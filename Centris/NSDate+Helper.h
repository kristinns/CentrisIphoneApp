//
//  NSDate+Helper.h
//  Centris
//
//  Created by Kristinn Svansson on 10/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)
- (NSDate *)dateByAddingMintues:(NSInteger)minutesToAdd; // tested
- (NSDate *)dateByAddingHours:(NSInteger)hoursToAdd; // tested
- (NSDate *)dateByAddingDays:(NSInteger)daysToAdd; // tested
- (NSDate *)dateByAddingWeeks:(NSInteger)weeksToAdd; // tested

+ (NSDate *)convertToDate:(NSString *)dateString withFormat:(NSString *)format; // tested
+ (NSString *)convertToString:(NSDate *)date withFormat:(NSString *)format; // tested

+ (NSDictionary *)dateRangeForTheWholeDay:(NSDate *)date; // tested
+ (NSDictionary *)dateRangeToMidnightFromDate:(NSDate *)date; // tested
+ (NSDictionary *)dateRangeToNextMorning:(NSDate *)date; // tested
+ (NSDateComponents *)dateComponentForDate:(NSDate *)date withCalendar:(NSCalendar *)calendar;
@end
