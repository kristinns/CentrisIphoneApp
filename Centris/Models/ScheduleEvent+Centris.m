//
//  ScheduleEvent+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEvent+Centris.h"
#import "CourseInstance+Centris.h"

@implementation ScheduleEvent (Centris)

+(NSArray *)scheduledEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSArray *scheduledEvents;
	
	// create fetch request
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ScheduledEvent"];
	
	// determine what sort
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"starts" ascending:YES]];
	// create the query / predicate
	request.predicate = [NSPredicate predicateWithFormat:@"starts >= %@ AND ends <= %@", fromDate, toDate ];
	
	// execute the query
	NSError *error = nil;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches) { // error
		NSLog(@"Error: %@",[error userInfo]);
	}
	else if (![matches count]) { // no result
		NSLog(@"No scheduled events found");
	}
	else { // something was found!
		scheduledEvents = matches;
	}
	return scheduledEvents;
}

+ (ScheduleEvent *)addScheduleEventWithCentrisInfo:(NSDictionary *)eventInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
	ScheduleEvent *event = nil;
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ScheduleEvent"];
	
	request.predicate = [NSPredicate predicateWithFormat:@"eventID = %@", eventInfo[@"ID"]];
	
	// Execute the fetch
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches) { // error
		NSLog(@"Error: %@", [error userInfo]);
	}
	else if (![matches count]) { // no result, put the event in core data
		
		
		event = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
		
		event.starts = [self icelandicFormatWithDateString:eventInfo[@"StartTime"]];
		event.ends = [self icelandicFormatWithDateString:eventInfo[@"EndTime"]];
		event.eventID = [self convertToNumberFromString:eventInfo[@"ID"]];
		event.roomName = eventInfo[@"RoomName"];
		event.typeOfClass = eventInfo[@"TypeOfClass"];
		event.courseName = eventInfo[@"CourseName"];
		
//		NSInteger courseID = [eventInfo[@"CourseID"] integerValue];
//		
//		CourseInstance *courseInstance = [CourseInstance courseInstanceWithID:courseID inManagedObjectContext:context];
//		if (!courseInstance) {
//			// TODO , this is a bit dependant on existance of courses in core data
//		}
//		event.hasCourseInstance = courseInstance;
		
	}
	else { // event found, return it
		event = [matches lastObject];
	}
	
	return event;
}

+ (NSNumber *)convertToNumberFromString:(NSString *)numberString
{
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	
	return [f numberFromString:numberString];
}

+ (NSDate *)icelandicFormatWithDateString:(NSString *)dateString
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
	return [formatter dateFromString:dateString];
}

@end
