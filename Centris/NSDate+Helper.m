//
//  NSDate+Helper.m
//  Centris
//
//  Created by Kristinn Svansson on 10/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

- (NSDate *)dateByAddingDays:(NSInteger)daysToAdd
{
    return [self dateByAddingTimeInterval:60*60*24*daysToAdd];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeksToAdd
{
    return [self dateByAddingTimeInterval:60*60*24*7*weeksToAdd];
}

@end
