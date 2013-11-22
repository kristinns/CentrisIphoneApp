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
+ (NSDate *)formatDateString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
	return [formatter dateFromString:dateString];
}

// Returns a dictionary with 'from' date that starts at 0:00 and 'to' date that ends at 23:59
+ (NSDictionary *)allDaydateRangeForDay:(NSDate *)day
{
    NSMutableDictionary *range = [[NSMutableDictionary alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:day];
    [comps setMinute:0];
    [comps setHour:0];
    [comps setSecond:0];
    NSDate *fromDate = [gregorian dateFromComponents:comps];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    NSDate *toDate = [gregorian dateFromComponents:comps];
    [range setObject:fromDate forKey:@"from"];
    [range setObject:toDate forKey:@"to"];
    return range;
}

+ (NSDictionary *)dateRangeToMidnightFromDate:(NSDate *)date;
{
    NSMutableDictionary *range = [[NSMutableDictionary alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate:date];
    [comps setMinute:0];
    [comps setHour:[comps hour]];
    [comps setSecond:0];
    NSDate *fromDate = [gregorian dateFromComponents:comps];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    NSDate *toDate = [gregorian dateFromComponents:comps];
    [range setObject:fromDate forKey:@"from"];
    [range setObject:toDate forKey:@"to"];
    return range;
}

@end














