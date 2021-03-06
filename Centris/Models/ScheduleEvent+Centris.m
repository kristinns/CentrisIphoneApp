//
//  ScheduleEvent+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEvent+Centris.h"
#import "ScheduleEventUnit+Centris.h"
#import "CourseInstance+Centris.h"
#import "DataFetcher.h"
#import "CDDataFetcher.h"
#import "NSDate+Helper.h"

#define SCHEDULE_EVENT_LENGTH 45

@implementation ScheduleEvent (Centris)

+ (NSArray *)scheduleEventUnitsForDay:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSDictionary *range = [date dateRangeForTheWholeDay];
    
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"starts >= %@ AND ends <= %@", range[@"from"], range[@"to"]];
    
    NSArray *scheduleEvents = [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                                   forKey:@"starts"
                                                            sortAscending:YES
                                                            withPredicate:pred
                                                   inManagedObjectContext:context];
    
    NSMutableArray *scheduleEventList = [[NSMutableArray alloc] init];
    for (ScheduleEvent *event in scheduleEvents) {
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"starts" ascending:YES];
        for (ScheduleEventUnit *unit in [event.hasUnits sortedArrayUsingDescriptors:@[descriptor]]) {
            [scheduleEventList addObject:unit];
        }
    }
	return scheduleEventList;
}

+ (void)addScheduleEventsWithCentrisInfo:(NSArray *)events inManagedObjectContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *eventInfo in events) {
        ScheduleEvent *event = nil;
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"eventID = %d", [eventInfo[@"ID"] integerValue]];
        NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                                forKey:@"eventID"
                                                         sortAscending:NO
                                                         withPredicate:pred
                                                inManagedObjectContext:context];
        // get the event units
        NSArray *eventUnits = [self splitEventsDownToUnits:eventInfo];
        
        if (![matches count]) { // no result, put the event in core data
            event = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
            event.eventID = [NSNumber numberWithInt:[eventInfo[EVENT_ID] intValue]];
            // rest can be populated by helper
            [self populateScheduleEventFieldsForScheduleEvent:event withEventInfo:eventInfo inManagedObjectContext:context];
            // add event units
            [ScheduleEventUnit addScheduleEventUnitForScheduleEvent:event withScheduleEventUnits:eventUnits inManagedObjectContext:context];
        } else { // event found, update its field
            event = [matches lastObject];
            [self populateScheduleEventFieldsForScheduleEvent:event withEventInfo:eventInfo inManagedObjectContext:context];
            // add event units again
            [ScheduleEventUnit addScheduleEventUnitForScheduleEvent:event withScheduleEventUnits:eventUnits inManagedObjectContext:context];
        }
    }
    // finally, find events that need to be removed, if any
    [self checkToRemoveScheduleEventsForCentrisScheduleEvents:events inMangedObjectContext:context];
}

+ (ScheduleEvent *)eventWithID:(NSNumber *)ID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"eventID = %d", [ID integerValue]];
    return [[CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                forKey:@"eventID"
                                         sortAscending:NO
                                         withPredicate:pred
                                inManagedObjectContext:context] lastObject];
}

+ (NSArray *)eventsInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                forKey:@"eventID"
                                         sortAscending:NO
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

// Returns all the NEXT schedule events for that given day. If, however, the time of the date is past 21:00
// it will return the next events before 11:00 the next day
+ (NSArray *)nextEventForDate:(NSDate *)date InManagedObjectContext:(NSManagedObjectContext *)context
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [date dateComponentForDateWithCalendar:gregorian];
    NSDictionary *range = nil;
    
    if ([comps hour] > 21) {
        range = [date dateRangeToNextMorning];
    } else {
        range = [date dateRangeToMidnightFromDate];
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"starts >= %@ AND ends <= %@", range[@"from"], range[@"to"]];
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                forKey:@"starts"
                                         sortAscending:YES
                                         withPredicate:pred
                                inManagedObjectContext:context];
}

// Retrieves all the schedule event units for the current date
+ (NSArray *)scheduleEventUnitsForCurrentDateInMangedObjectContext:(NSManagedObjectContext *)context
{
    NSDictionary *range = [[NSDate date] dateRangeForTheWholeDay];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"starts >= %@ AND ends <= %@", range[@"from"], range[@"to"]];
    
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                forKey:@"starts"
                                         sortAscending:NO
                                         withPredicate:pred
                                inManagedObjectContext:context];
}

// Retrieves all the final exams
+ (NSArray *)finalExamsExceedingDate:(NSDate *)date InManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"starts >= %@ AND typeOfClass == 'Lokapróf'", date];
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"ScheduleEvent"
                                                forKey:@"starts"
                                         sortAscending:YES
                                         withPredicate:pred
                                inManagedObjectContext:context];
}

#pragma mark - Helper methods

+ (void)checkToRemoveScheduleEventsForCentrisScheduleEvents:(NSArray *)centrisScheduleEvents inMangedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *eventsInCoreData = [self eventsInManagedObjectContext:context];
    NSMutableSet *setToBeDeleted = [[NSMutableSet alloc] init];
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (ScheduleEvent *e in eventsInCoreData)
        [setToBeDeleted addObject:e.eventID];
    for (NSDictionary *dic in centrisScheduleEvents)
        [set addObject: [NSNumber numberWithInteger:[dic[EVENT_ID] integerValue]]];
    [setToBeDeleted minusSet:set];
    NSArray *arrayToBeDeleted = [setToBeDeleted allObjects];
    if ([arrayToBeDeleted count]) { // there are some events that needs to be removed
        for (int i = 0; i < [arrayToBeDeleted count]; i++) {
            ScheduleEvent *scheduleEvent = [self eventWithID:arrayToBeDeleted[i] inManagedObjectContext:context];
            [context deleteObject:scheduleEvent];
        }
    }
}

+ (void)populateScheduleEventFieldsForScheduleEvent:(ScheduleEvent *)event withEventInfo:(NSDictionary *)eventInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    event.starts = [NSDate dateFromString:eventInfo[EVENT_START_TIME] withFormat:nil];
    event.ends = [NSDate dateFromString:eventInfo[EVENT_END_TIME] withFormat:nil];
    event.roomName = eventInfo[EVENT_ROOM_NAME];
    event.typeOfClass = eventInfo[EVENT_TYPE_OF_CLASS];
    event.courseName = eventInfo[EVENT_COURSE_NAME];
    CourseInstance *courseInst = [CourseInstance courseInstanceWithID:[eventInfo[EVENT_COURSE_INSTANCE_ID] intValue] inManagedObjectContext:context];
    event.hasCourseInstance = courseInst;
}

+ (NSArray *)splitEventsDownToUnits:(NSDictionary *)eventInfo
{
    NSMutableArray *splittedEvents = [[NSMutableArray alloc] init];
    NSDate *starts = [NSDate dateFromString:eventInfo[EVENT_START_TIME] withFormat:nil];
    NSDate *to = [NSDate dateFromString:eventInfo[EVENT_END_TIME] withFormat:nil];
    CGFloat length = [to timeIntervalSinceDate:starts];
    if (length <= SCHEDULE_EVENT_LENGTH || (![eventInfo[EVENT_TYPE_OF_CLASS] isEqualToString:@"Fyrirlestur"] && ![eventInfo[EVENT_TYPE_OF_CLASS] isEqualToString:@"Dæmatími"])) {
        [splittedEvents addObject:eventInfo];
        return splittedEvents;
    } else {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *compsStarts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit fromDate:starts];
    
        // either component is fine because they both have the same day
        NSArray *breaks = [self getRUbreaksForDateComponent:compsStarts inCalendar:gregorian];
        
        NSDate *runner = starts;
        //NSDateComponents *compRunner = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit fromDate:runner];
        while ([runner compare:to] != NSOrderedDescending)
        {
            NSMutableDictionary *splittedEvent = [[NSMutableDictionary alloc] init];
            [splittedEvent setObject:eventInfo[EVENT_COURSE_INSTANCE_ID] forKey:EVENT_COURSE_INSTANCE_ID];
            [splittedEvent setObject:eventInfo[EVENT_COURSE_NAME] forKey:EVENT_COURSE_NAME];
            [splittedEvent setObject:eventInfo[EVENT_ROOM_NAME] forKey:EVENT_ROOM_NAME];
            [splittedEvent setObject:eventInfo[EVENT_TYPE_OF_CLASS] forKey:EVENT_TYPE_OF_CLASS];
            [splittedEvent setObject:eventInfo[EVENT_ID] forKey:EVENT_ID];
            [splittedEvent setObject:runner forKey:EVENT_START_TIME];
            runner = [runner dateByAddingMintues:SCHEDULE_EVENT_LENGTH];
            [splittedEvent setObject:runner forKey:EVENT_END_TIME];
            [splittedEvents addObject:splittedEvent];
            
            // now find how long the next pause is
            for (int i = 0; i < [breaks count]; i++) {
                if ([(NSDate *)[breaks[i] objectForKey:@"from"] compare:runner] == NSOrderedSame) {
                    runner = [runner dateByAddingMintues:[[breaks[i] objectForKey:@"length"] integerValue]];
                    break;
                }
            }
        }
        return splittedEvents;
    }
}


// For a given date component, will look at the given date for that component and return list of pauses and breaks
// for that day.
+ (NSArray *)getRUbreaksForDateComponent:(NSDateComponents *)comps inCalendar:(NSCalendar *)calendar
{
    NSMutableArray *breaks = [[NSMutableArray alloc] init];
    NSDate *fromDate;
    NSDate *toDate;
    [comps setHour:9];
    [comps setMinute:15];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:9];
    [comps setMinute:20];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates1 = [[NSMutableDictionary alloc] init];
    [dates1 setObject:fromDate forKey:@"from"];
    [dates1 setObject:toDate forKey:@"to"];
    [dates1 setObject:[NSNumber numberWithInteger:5] forKey:@"length"];
    [breaks addObject:dates1];
    
    [comps setHour:10];
    [comps setMinute:5];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:10];
    [comps setMinute:20];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates2 = [[NSMutableDictionary alloc] init];
    [dates2 setObject:fromDate forKey:@"from"];
    [dates2 setObject:toDate forKey:@"to"];
    [dates2 setObject:[NSNumber numberWithInteger:15] forKey:@"length"];
    [breaks addObject:dates2];
    
    [comps setHour:11];
    [comps setMinute:5];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:11];
    [comps setMinute:10];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates3 = [[NSMutableDictionary alloc] init];
    [dates3 setObject:fromDate forKey:@"from"];
    [dates3 setObject:toDate forKey:@"to"];
    [dates3 setObject:[NSNumber numberWithInteger:5] forKey:@"length"];
    [breaks addObject:dates3];
    
    [comps setHour:11];
    [comps setMinute:55];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:12];
    [comps setMinute:20];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates4 = [[NSMutableDictionary alloc] init];
    [dates4 setObject:fromDate forKey:@"from"];
    [dates4 setObject:toDate forKey:@"to"];
    [dates4 setObject:[NSNumber numberWithInteger:25] forKey:@"length"];
    [breaks addObject:dates4];
    
    [comps setHour:13];
    [comps setMinute:5];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:13];
    [comps setMinute:10];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates5 = [[NSMutableDictionary alloc] init];
    [dates5 setObject:fromDate forKey:@"from"];
    [dates5 setObject:toDate forKey:@"to"];
    [dates5 setObject:[NSNumber numberWithInteger:5] forKey:@"length"];
    [breaks addObject:dates5];
    
    [comps setHour:13];
    [comps setMinute:55];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:14];
    [comps setMinute:00];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates6 = [[NSMutableDictionary alloc] init];
    [dates6 setObject:fromDate forKey:@"from"];
    [dates6 setObject:toDate forKey:@"to"];
    [dates6 setObject:[NSNumber numberWithInteger:5] forKey:@"length"];
    [breaks addObject:dates6];
    
    [comps setHour:14];
    [comps setMinute:45];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:14];
    [comps setMinute:55];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates7 = [[NSMutableDictionary alloc] init];
    [dates7 setObject:fromDate forKey:@"from"];
    [dates7 setObject:toDate forKey:@"to"];
    [dates7 setObject:[NSNumber numberWithInteger:10] forKey:@"length"];
    [breaks addObject:dates7];
    
    [comps setHour:15];
    [comps setMinute:40];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:15];
    [comps setMinute:45];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates8 = [[NSMutableDictionary alloc] init];
    [dates8 setObject:fromDate forKey:@"from"];
    [dates8 setObject:toDate forKey:@"to"];
    [dates8 setObject:[NSNumber numberWithInteger:5] forKey:@"length"];
    [breaks addObject:dates8];
    
    [comps setHour:16];
    [comps setMinute:30];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:16];
    [comps setMinute:35];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates9 = [[NSMutableDictionary alloc] init];
    [dates9 setObject:fromDate forKey:@"from"];
    [dates9 setObject:toDate forKey:@"to"];
    [dates9 setObject:[NSNumber numberWithInteger:5] forKey:@"length"];
    [breaks addObject:dates9];
    
    [comps setHour:17];
    [comps setMinute:20];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:17];
    [comps setMinute:25];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates10 = [[NSMutableDictionary alloc] init];
    [dates10 setObject:fromDate forKey:@"from"];
    [dates10 setObject:toDate forKey:@"to"];
    [dates10 setObject:[NSNumber numberWithInteger:5] forKey:@"length"];
    [breaks addObject:dates10];
    
    [comps setHour:18];
    [comps setMinute:10];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:18];
    [comps setMinute:15];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates11 = [[NSMutableDictionary alloc] init];
    [dates11 setObject:fromDate forKey:@"from"];
    [dates11 setObject:toDate forKey:@"to"];
    [dates11 setObject:[NSNumber numberWithInteger:5] forKey:@"length"];
    [breaks addObject:dates11];
    
    [comps setHour:19];
    [comps setMinute:0];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:19];
    [comps setMinute:5];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates12 = [[NSMutableDictionary alloc] init];
    [dates12 setObject:fromDate forKey:@"from"];
    [dates12 setObject:toDate forKey:@"to"];
    [dates12 setObject:[NSNumber numberWithInteger:5] forKey:@"length"];
    [breaks addObject:dates12];
    
    [comps setHour:20];
    [comps setMinute:35];
    [comps setSecond:0];
    fromDate = [calendar dateFromComponents:comps];
    [comps setHour:20];
    [comps setMinute:40];
    [comps setSecond:00];
    toDate = [calendar dateFromComponents:comps];
    NSMutableDictionary *dates13 = [[NSMutableDictionary alloc] init];
    [dates13 setObject:fromDate forKey:@"from"];
    [dates13 setObject:toDate forKey:@"to"];
    [dates13 setObject:[NSNumber numberWithInteger:5] forKey:@"length"];
    [breaks addObject:dates13];
    
    return breaks;
    
}

@end
