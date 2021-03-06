//
//  NSDate+Helper.m
//  Centris
//
//  Created by Kristinn Svansson on 10/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

- (NSDate *)dateByAddingMintues:(NSInteger)minutesToAdd
{
    return [self dateByAddingTimeInterval:60*minutesToAdd];
}

- (NSDate *)dateByAddingHours:(NSInteger)hoursToAdd
{
    return [self dateByAddingTimeInterval:60*60*hoursToAdd];
}

- (NSDate *)dateByAddingDays:(NSInteger)daysToAdd
{
    return [self dateByAddingTimeInterval:60*60*24*daysToAdd];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeksToAdd
{
    return [self dateByAddingTimeInterval:60*60*24*7*weeksToAdd];
}

// Returns a date in a custom format
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format
{
    if (!format) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
        return [formatter dateFromString:dateString];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        return [formatter dateFromString:dateString];
    }
}

- (NSString *)stringFromDateWithFormat:(NSString *)format
{
    if (!format) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
        return [formatter stringFromDate:self];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        return [formatter stringFromDate:self];
    }
}

// Returns a dictionary with 'from' date that starts at 0:00 and 'to' date that ends at 23:59
- (NSDictionary *)dateRangeForTheWholeDay
{
    NSMutableDictionary *range = [[NSMutableDictionary alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [self dateComponentForDateWithCalendar:gregorian];
    [comps setSecond:0];
    [comps setMinute:0];
    [comps setHour:0];
    NSDate *fromDate = [gregorian dateFromComponents:comps];
    [comps setSecond:59];
    [comps setMinute:59];
    [comps setHour:23];
    NSDate *toDate = [gregorian dateFromComponents:comps];
    [range setObject:fromDate forKey:@"from"];
    [range setObject:toDate forKey:@"to"];
    return range;
}

- (NSDictionary *)dateRangeToMidnightFromDate;
{
    NSMutableDictionary *range = [[NSMutableDictionary alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [self dateComponentForDateWithCalendar:gregorian];
    [comps setSecond:[comps second]];
    [comps setMinute:[comps minute]];
    [comps setHour:[comps hour]];
    NSDate *fromDate = [gregorian dateFromComponents:comps];
    [comps setSecond:59];
    [comps setMinute:59];
    [comps setHour:23];
    NSDate *toDate = [gregorian dateFromComponents:comps];
    [range setObject:fromDate forKey:@"from"];
    [range setObject:toDate forKey:@"to"];
    return range;
}

- (NSDictionary *)dateRangeToNextMorning
{
    NSMutableDictionary *range = [[NSMutableDictionary alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [self dateComponentForDateWithCalendar:gregorian];
    [comps setSecond:0];
    [comps setMinute:0];
    [comps setHour:[comps hour]];
    NSDate *fromDate = [gregorian dateFromComponents:comps];
    [comps setSecond:00];
    [comps setMinute:05];
    [comps setHour:10];
    [comps setDay:([comps day]) +1];
    NSDate *toDate = [gregorian dateFromComponents:comps];
    [range setObject:fromDate forKey:@"from"];
    [range setObject:toDate forKey:@"to"];
    return range;
}

- (NSDateComponents *)dateComponentForDateWithCalendar:(NSCalendar *)calendar
{
    return [calendar components:NSYearCalendarUnit|
                                NSMonthCalendarUnit|
                                NSWeekCalendarUnit|
                                NSWeekdayCalendarUnit|
                                NSDayCalendarUnit|
                                NSHourCalendarUnit|
                                NSMinuteCalendarUnit|
                                NSSecondCalendarUnit fromDate:self];
}

@end














