//
//  CDFServiceStub.m
//  Centris
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CDFServiceStub.h"

@implementation CDFServiceStub

+ (NSArray *)getAssignments
{
    NSMutableArray *assignments = [[NSMutableArray alloc] init];
    for(NSInteger i=1; i<= 10; i++) {
        NSString *title = [@"Verkefni " stringByAppendingString:[NSString stringWithFormat: @"%d", i]];
        NSString *finished = i == 1 || i == 3 ? @"yes" : @"no";
        NSDictionary *assignment;
        if (i == 1 || i == 3)
            assignment = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", @"Skilað 23. mars 22:32", @"date", finished, @"finished", nil];
        else
            assignment = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", @"Skilafrestur: 24. mars 23:59", @"date", finished, @"finished", nil];
        [assignments addObject:assignment];
    }
	
    return assignments;
}

+ (NSArray *) getAssignmentCourses
{
    NSMutableArray *courses = [[NSMutableArray alloc] init];
    
    [courses addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Markaðsfræði", @"title", @"3", @"count", nil]];
    [courses addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Hagfræði", @"title", @"2", @"count", nil]];
    [courses addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Þjóðhagfræði", @"title", @"2", @"count", nil]];
    [courses addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Reikningshald", @"title", @"3", @"count", nil]];
    
    return courses;
}

+ (NSDictionary *)getUser:(NSString *)bySSN
{
	NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
	
	[user setObject:[NSArray arrayWithObjects:@"Ljósheimum 2", nil] forKey:@"Address"];
	[user setObject:[NSArray arrayWithObjects:@"bjarkim11@ru.is", nil] forKey:@"Email"];
	[user setObject:[NSArray arrayWithObjects:@"18703", nil] forKey:@"ID"];
	[user setObject:[NSArray arrayWithObjects:@"8698649", nil] forKey:@"MobilePhone"];
	[user setObject:[NSArray arrayWithObjects:@"Bjarki Sörens Madsen", nil] forKey:@"Name"];
	[user setObject:[NSArray arrayWithObjects:@"104", nil] forKey:@"Postal"];
	[user setObject:[NSArray arrayWithObjects:@"0805903269", nil] forKey:@"SSN"];
	
	return user;
}

+ (NSArray *)getSchedule:(NSString *)bySSN from:(NSDate *)fromDate to:(NSDate *)toDate
{
	NSMutableArray *schedule = [[NSMutableArray alloc] init];
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"1", @"ID",
						 @"24484", @"CourseID",
						 @"Vefforritun II", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-02-13T08:30:00", @"StartTime",
						 @"2013-02-13T10:05:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"2", @"ID",
						 @"24419", @"CourseID",
						 @"Forritunarmál", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-02-13T13:10:00", @"StartTime",
						 @"2013-02-13T14:45:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
	
	return schedule;
}



@end
