//
//  ScheduleEvent+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEvent+Centris.h"
#import "CourseInstance+Centris.h"
#import "CentrisManagedObjectContext.h"

@implementation ScheduleEvent (Centris)

+(NSArray *)scheduledEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"starts >= %@ AND ends <= %@", fromDate, toDate ];
	
	NSArray *scheduledEvents = [self fetchEventsFromDBWithEntity:@"ScheduledEvent"
														  forKey:@"starts"
												   withPredicate:pred
										  inManagedObjectContext:context];
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
		CourseInstance *courseInst = [CourseInstance courseInstanceWithID:[eventInfo[@"CourseID"] intValue] inManagedObjectContext:context];
        event.hasCourseInstance = courseInst;
	} else { // event found, return it
		event = [matches lastObject];
	}
	return event;
}

#pragma mark - Helpers
+ (NSMutableArray*)fetchEventsFromDBWithEntity:(NSString*)entityName forKey:(NSString*)keyName withPredicate:(NSPredicate*)predicate inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyName ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
	
    if (predicate != nil)
        [request setPredicate:predicate];
	
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"%@", error);
    }
    return mutableFetchResults;
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
