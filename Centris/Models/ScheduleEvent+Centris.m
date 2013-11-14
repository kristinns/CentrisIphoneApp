//
//  ScheduleEvent+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEvent+Centris.h"
#import "CourseInstance+Centris.h"
#import "DataFetcher.h"
#import "CDDataFetcher.h"
#import "NSDate+Helper.h"

@implementation ScheduleEvent (Centris)

+ (NSArray *)scheduleEventsFromDay:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
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

+ (void)addScheduleEventsWithCentrisInfo:(NSArray *)events inManagedObjectContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *eventInfo in events) {
        ScheduleEvent *event = nil;
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"eventID = %d", [eventInfo[@"ID"] integerValue]];
        NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent" forKey:@"eventID" sortAscending:NO withPredicate:pred inManagedObjectContext:context];
        
        if (![matches count]) { // no result, put the event in core data
            event = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
            event.eventID = [NSNumber numberWithInt:[eventInfo[EVENT_ID] intValue]];
            // rest can be populated by helper
            [self populeScheduleEventFieldsForScheduleEvent:event withEventInfo:eventInfo inManagedObjectContext:context];
        } else { // event found, update its field
            event = [matches lastObject];
            [self populeScheduleEventFieldsForScheduleEvent:event withEventInfo:eventInfo inManagedObjectContext:context];
        }
    }
    // find events that need to be removed, if any
    NSArray *eventsInCoreData = [self eventsInManagedObjectContext:context];
    NSMutableSet *setToBeDeleted = [[NSMutableSet alloc] init];
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (ScheduleEvent *e in eventsInCoreData)
        [setToBeDeleted addObject:e.eventID];
    for (NSDictionary *dic in events)
        [set addObject:dic[EVENT_ID]];
    NSArray *arrayToBeDeleted = [setToBeDeleted allObjects];
    if ([arrayToBeDeleted count]) { // there are some events that needs to be removed
        for (int i = 0; i < [arrayToBeDeleted count]; i++) {
            ScheduleEvent *scheduleEvent = [[self eventWithID:arrayToBeDeleted[i] inManagedObjectContext:context] lastObject];
            [context deleteObject:scheduleEvent];
        }
    }
}

+ (NSArray *)eventWithID:(NSNumber *)ID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"eventID = %d", ID];
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                forKey:@"eventID"
                                         sortAscending:NO
                                         withPredicate:pred
                                inManagedObjectContext:context];
}

+ (NSArray *)eventsInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                forKey:@"eventID"
                                         sortAscending:NO
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

#pragma mark - Helper methods

+ (void)populeScheduleEventFieldsForScheduleEvent:(ScheduleEvent *)event withEventInfo:(NSDictionary *)eventInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    event.starts = [NSDate formatDateString:eventInfo[EVENT_START_TIME]];
    event.ends = [NSDate formatDateString:eventInfo[EVENT_END_TIME]];
    event.roomName = eventInfo[EVENT_ROOM_NAME];
    event.typeOfClass = eventInfo[EVENT_TYPE_OF_CLASS];
    event.courseName = eventInfo[EVENT_COURSE_NAME];
    CourseInstance *courseInst = [CourseInstance courseInstanceWithID:[eventInfo[EVENT_COURSE_INSTANCE_ID] intValue] inManagedObjectContext:context];
    event.hasCourseInstance = courseInst;
}
@end
