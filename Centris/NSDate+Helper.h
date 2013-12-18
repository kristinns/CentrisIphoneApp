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

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format; // tested
- (NSString *)stringFromDateWithFormat:(NSString *)format; // tested

- (NSDictionary *)dateRangeForTheWholeDay; // tested
- (NSDictionary *)dateRangeToMidnightFromDate; // tested
- (NSDictionary *)dateRangeToNextMorning; // tested
- (NSDateComponents *)dateComponentForDateWithCalendar:(NSCalendar *)calendar;
@end
