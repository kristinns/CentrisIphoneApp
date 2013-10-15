//
//  CDFServiceStub.m
//  Centris
//
//	This is a service stub API that provides fake data to immitate the actual API.
//	To be used only for developing
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

// This function is immitating the post request. Given an email (and password when ready), the fetcher
// should try to login the user and get user details back.
+ (NSDictionary *)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password;
{
	NSMutableDictionary *info = nil;
	
	if ([@"kristinns11@ru.is" isEqualToString:email]) {
		info = [[NSMutableDictionary alloc] init];
		NSMutableDictionary * person = [[NSMutableDictionary alloc] init];
		[person setObject:@"Tröllhólum 12" forKey:@"Address"];
		[person setObject:@"kristinns11@ru.is" forKey:@"Email"];
		[person setObject:@"18748" forKey:@"ID"];
		[person setObject:@"8657231" forKey:@"MobilePhone"];
		[person setObject:@"Kristinn Svansson" forKey:@"Name"];
		[person setObject:@"800" forKey:@"Postal"];
		[person setObject:@"2402912319" forKey:@"SSN"];
		[info setObject:person forKey:@"Person"];
		
		NSMutableDictionary *registration = [[NSMutableDictionary  alloc] init];
		NSMutableDictionary *studentRegistration = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *major = [[NSMutableDictionary alloc] init];
		
		[registration setObject:@"Tölvunarfræðideild" forKey:@"DepartmentName"];
		[registration setObject:@"Staðarnám" forKey:@"StudentTypeName"];
		
		[studentRegistration setObject:[NSNumber numberWithInteger:18] forKey:@"ECTSActive"];
		[studentRegistration setObject:[NSNumber numberWithInteger:72] forKey:@"ECTSFinished"];
		[studentRegistration setObject:[NSNumber numberWithDouble:9] forKey:@"AverageGrade"];
		[registration setObject:studentRegistration forKey:@"StudentRegistration"];
		
		[major setObject:@"BSc í tölvunarfræði" forKey:@"Name"];
		[major setObject:@"BSc in Computer Science" forKey:@"NameEnglish"];
		[major setObject:[NSNumber numberWithInteger:180] forKey:@"Credits"];
		[registration setObject:major forKey:@"Major"];
		
		[info setObject:registration forKey:@"Registration"];
		

	} else if ([@"bjarkim11@ru.is" isEqualToString:email]) {
		info = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *person = [[NSMutableDictionary alloc] init];
		[person setObject:@"Ljósheimum 2" forKey:@"Address"];
		[person setObject:@"bjarkim11@ru.is" forKey:@"Email"];
		[person setObject:@"18703" forKey:@"ID"];
		[person setObject:@"8698649" forKey:@"MobilePhone"];
		[person setObject:@"Bjarki Sörens Madsen" forKey:@"Name"];
		[person setObject:@"104" forKey:@"Postal"];
		[person setObject:@"0805903269" forKey:@"SSN"];
		[info setObject:person forKey:@"Person"];
		
		NSMutableDictionary *registration = [[NSMutableDictionary  alloc] init];
		NSMutableDictionary *studentRegistration = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *major = [[NSMutableDictionary alloc] init];
		
		[registration setObject:@"Tölvunarfræðideild" forKey:@"DepartmentName"];
		[registration setObject:@"Staðarnám" forKey:@"StudentTypeName"];
		
		[studentRegistration setObject:[NSNumber numberWithInteger:24] forKey:@"ECTSActive"];
		[studentRegistration setObject:[NSNumber numberWithInteger:66] forKey:@"ECTSFinished"];
		[studentRegistration setObject:[NSNumber numberWithDouble:7.5] forKey:@"AverageGrade"];
		[registration setObject:studentRegistration forKey:@"StudentRegistration"];
		
		[major setObject:@"BSc í tölvunarfræði" forKey:@"Name"];
		[major setObject:@"BSc in Computer Science" forKey:@"NameEnglish"];
		[major setObject:[NSNumber numberWithInteger:180] forKey:@"Credits"];
		[registration setObject:major forKey:@"Major"];
		
		[info setObject:registration forKey:@"Registration"];
	}
	else {
		return nil;
	}
	
	return info;
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
