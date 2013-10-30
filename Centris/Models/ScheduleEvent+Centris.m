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
#import "CDDataFetcher.h"
#import "NSDate+Helper.h"

@implementation ScheduleEvent (Centris)

+(NSArray *)scheduleEventsFromDay:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    [comps setMinute:0];
    [comps setHour:0];
    [comps setSecond:0];
    NSDate *fromDate = [gregorian dateFromComponents:comps];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    NSDate *toDate = [gregorian dateFromComponents:comps];
    
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"starts >= %@ AND ends <= %@", fromDate, toDate ];
    
    NSArray *scheduleEvents = [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                                   forKey:@"starts"
                                                            sortAscending:YES
                                                            withPredicate:pred
                                                   inManagedObjectContext:context];
    
	return scheduleEvents;
}

+ (ScheduleEvent *)addScheduleEventWithCentrisInfo:(NSDictionary *)eventInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
	ScheduleEvent *event = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"eventID = %d", [eventInfo[@"ID"] integerValue]];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                            forKey:@"eventID"
                                                     sortAscending:NO
                                                     withPredicate:pred
                                            inManagedObjectContext:context];
    
    if (![matches count]) { // no result, put the event in core data
		event = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
		event.starts = [NSDate formatDateString:eventInfo[@"StartTime"]];
		event.ends = [NSDate formatDateString:eventInfo[@"EndTime"]];
		event.eventID = eventInfo[@"ID"];
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

@end
