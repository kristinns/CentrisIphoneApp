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

+ (NSArray *)getAssignmentsForUserWithSSN:(NSString *)SSN
{
	NSMutableArray *assignments = [[NSMutableArray alloc] init];
	
	NSMutableDictionary *assignment1 = [[NSMutableDictionary alloc] init];
	[assignment1 setObject:[NSNumber numberWithInteger:28947] forKey:@"ID"];
	[assignment1 setObject:@"7. Essay" forKey:@"Title"];
	[assignment1 setObject:@"<p>Write a short paper (approximately 2-3 pages) about a person who has contributed to computer science. You may choose to write about any one of the persons mentioned in the slides, or you could pick someone which isn't mentioned there, but in that case you need to get a permission (basically so we can ensure that the person in question is somewhat connected to computer science!).</p>\r\n<p>The paper should be roughly 2-3 pages long (excluding the front page), students should use their own judgement with regards to spacing, font sizes etc. You should pick your own style, i.e. APA, MLA etc, and stick to it.</p>\r\n<p>You may write in either Icelandic or English, just stick to either language.</p>\r\n<p>You should use at least 2&nbsp;sources (other than Wikipedia), and at least one of them should be a regular book (not just a web page). However, the book may be in electronic form (for instance, found at books.google.com).</p>\r\n<p>Hand in a single document, either in Microsoft Word format (.doc,.docx), Open Document Format (.odt), .pdf or .html.</p>" forKey:@"Description"];
	NSMutableArray *l1 = [[NSMutableArray alloc] init];
	[l1 addObject:@"doc"];
	[l1 addObject:@"docx"];
	[l1 addObject:@"pdf"];
	[l1 addObject:@"html"];
	[l1 addObject:@"odt"];
	[assignment1 setObject:l1 forKey:@"AllowedFileExtensions"];
	[assignment1 setObject:[NSNumber numberWithInteger:8] forKey:@"Weight"];
	[assignment1 setObject:[NSNumber numberWithInteger:1] forKey:@"MaxStudentsInGroup"];
	[assignment1 setObject:@"2013-10-26T15:00:00" forKey:@"DatePublished"];
	[assignment1 setObject:@"2013-11-02T23:59:00" forKey:@"DateClosed"];
	
	NSMutableDictionary *assignment2 = [[NSMutableDictionary alloc] init];
	[assignment2 setObject:[NSNumber numberWithInteger:29000] forKey:@"ID"];
	[assignment2 setObject:@"1. Computations in real life" forKey:@"Title"];
	[assignment2 setObject:@"<h3>First practical assignment</h3>\r\n<p>1. Keep a diary for one day, and record everything you do. For each activity, try to determine if some computation was involved, either in the activity itself, or in the required infrastructure.</p>\r\n<p>2. Which of your activities did you follow mechanically? For instance, is there a lot of thinking involved in brushing your teeth? Do you always brush your teeth the same way? If not, why?</p>\r\n<p>&nbsp;</p>\r\n<p>Hand in a single text document (with the .txt extension), containing your answers to these questions.</p>" forKey:@"Description"];
	NSMutableArray *l2 = [[NSMutableArray alloc] init];
	[l2 addObject:@"txt"];
	[l2 addObject:@"zip"];
	[l2 addObject:@"rar"];
	[assignment2 setObject:l2 forKey:@"AllowedFileExtensions"];
	[assignment2 setObject:[NSNumber numberWithInteger:2] forKey:@"Weight"];
	[assignment2 setObject:[NSNumber numberWithInteger:1] forKey:@"MaxStudentsInGroup"];
	[assignment2 setObject:@"2013-09-20T15:00:00" forKey:@"DatePublished"];
	[assignment2 setObject:@"2013-09-27T23:59:00" forKey:@"DateClosed"];
	
	[assignments addObject:assignment1];
	[assignments addObject:assignment2];
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

+ (NSArray *)getCoursesForStudentWithSSN:(NSString *)SSN
{
    NSMutableArray  *courseInstArray = [[NSMutableArray alloc] init];
    
    // T-109-INTO
    NSMutableDictionary *courseInst1 = [[NSMutableDictionary alloc] init];
    [courseInst1 setObject:[NSNumber numberWithInt:22363] forKey:@"ID"];
    [courseInst1 setObject:@"T-109-INTO" forKey:@"CourseID"];
    [courseInst1 setObject:@"Inngangur að tölvunarfræði" forKey:@"Name"];
    [courseInst1 setObject:@"20113" forKey:@"Semester"];
    [courseInstArray addObject:courseInst1];
    
    // T-111-PROG
    NSMutableDictionary *courseInst2 = [[NSMutableDictionary alloc] init];
    [courseInst2 setObject:[NSNumber numberWithInt:22212] forKey:@"ID"];
    [courseInst2 setObject:@"T-111-PROG" forKey:@"CourseID"];
    [courseInst2 setObject:@"Forritun" forKey:@"Name"];
    [courseInst2 setObject:@"20113" forKey:@"Semester"];
    [courseInstArray addObject:courseInst2];
    
    // T-117-STR1
    NSMutableDictionary *courseInst3 = [[NSMutableDictionary alloc] init];
    [courseInst3 setObject:[NSNumber numberWithInt:22218] forKey:@"ID"];
    [courseInst3 setObject:@"T-117-STR1" forKey:@"CourseID"];
    [courseInst3 setObject:@"Strjál Stærðfræði I" forKey:@"Name"];
    [courseInst3 setObject:@"20113" forKey:@"Semester"];
    [courseInstArray addObject:courseInst3];
    
    // T-107-TOLH
    NSMutableDictionary *courseInst4 = [[NSMutableDictionary alloc] init];
    [courseInst4 setObject:[NSNumber numberWithInt:22219] forKey:@"ID"];
    [courseInst4 setObject:@"T-107-TOLH" forKey:@"CourseID"];
    [courseInst4 setObject:@"Tölvuhögun" forKey:@"Name"];
    [courseInst4 setObject:@"20113" forKey:@"Semester"];
    [courseInstArray addObject:courseInst4];
    
    // T-110-VERK
    NSMutableDictionary *courseInst5 = [[NSMutableDictionary alloc] init];
    [courseInst5 setObject:[NSNumber numberWithInt:22220] forKey:@"ID"];
    [courseInst5 setObject:@"T-110-VERK" forKey:@"CourseID"];
    [courseInst5 setObject:@"Verkefnalausnir" forKey:@"Name"];
    [courseInst5 setObject:@"20113" forKey:@"Semester"];
    [courseInstArray addObject:courseInst5];
    
    // Finally, return courseInstArray
    return courseInstArray;
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

+ (NSArray *)getScheduleBySSN:(NSString *)SSN
{
	NSMutableArray *schedule = [[NSMutableArray alloc] init];
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"1", @"ID",
						 @"22363", @"CourseID",
						 @"Inngangur að tölvunarfræði", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-27T08:30:00", @"StartTime",
						 @"2013-10-27T09:15:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"2", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-27T11:10:00", @"StartTime",
						 @"2013-10-27T11:55:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"5", @"ID",
						 @"24419", @"CourseID",
						 @"Stýrikerfi", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-27T12:20:00", @"StartTime",
						 @"2013-10-27T13:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"6", @"ID",
						 @"24419", @"CourseID",
						 @"Stýrikerfi", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-27T13:10:00", @"StartTime",
						 @"2013-10-27T13:55:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"7", @"ID",
						 @"24419", @"CourseID",
						 @"Gagnasafnsfræði", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-27T14:00:00", @"StartTime",
						 @"2013-10-27T14:45:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"8", @"ID",
						 @"24419", @"CourseID",
						 @"Gagnasafnsfræði", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-27T14:55:00", @"StartTime",
						 @"2013-10-27T15:40:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    
    /* Monday */
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"12", @"ID",
						 @"24419", @"CourseID",
						 @"Vefforritun II", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-28T09:20:00", @"StartTime",
						 @"2013-10-28T10:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"13", @"ID",
						 @"24419", @"CourseID",
						 @"Forritunarmál", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-28T10:20:00", @"StartTime",
						 @"2013-10-28T11:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"14", @"ID",
						 @"24419", @"CourseID",
						 @"Forritunarmál", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-28T11:10:00", @"StartTime",
						 @"2013-10-28T11:55:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"15", @"ID",
						 @"24419", @"CourseID",
						 @"Stýrikerfi", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-28T12:20:00", @"StartTime",
						 @"2013-10-28T13:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"16", @"ID",
						 @"24419", @"CourseID",
						 @"Stýrikerfi", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-28T13:10:00", @"StartTime",
						 @"2013-10-28T13:55:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"17", @"ID",
						 @"24419", @"CourseID",
						 @"Gagnasafnsfræði", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-28T14:00:00", @"StartTime",
						 @"2013-10-28T14:45:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"18", @"ID",
						 @"24419", @"CourseID",
						 @"Gagnasafnsfræði", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-10-28T14:55:00", @"StartTime",
						 @"2013-10-28T15:40:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];

	
	return schedule;
}



@end
