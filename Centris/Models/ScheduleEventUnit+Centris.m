//
//  ScheduleEventUnit+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 18/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEventUnit+Centris.h"
#import "ScheduleEvent.h"
#import "DataFetcher.h"

@implementation ScheduleEventUnit (Centris)

+ (void)addScheduleEventUnitForScheduleEvent:(ScheduleEvent *)scheduleEvent withScheduleEventUnits:(NSArray *)scheduleEventUnits inManagedObjectContext:(NSManagedObjectContext *)context
{
    // erase all units before inserting (for update purpose)
    [self removeScheduleEventsForScheduleEvent:scheduleEvent inManagedObjectContext:context];
    
    NSInteger index = 0;
    for (NSDictionary *subEvent in scheduleEventUnits) {
        ScheduleEventUnit *eventUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEventUnit" inManagedObjectContext:context];
        eventUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEventUnit" inManagedObjectContext:context];
        eventUnit.isAUnitOf = scheduleEvent;
        eventUnit.id = [NSString stringWithFormat:@"%d_%d", [scheduleEvent.eventID integerValue], ++index];
        eventUnit.starts = subEvent[EVENT_START_TIME];
        eventUnit.ends = subEvent[EVENT_END_TIME];
    }
}

+ (void)removeScheduleEventsForScheduleEvent:(ScheduleEvent *)scheduleEvent inManagedObjectContext:(NSManagedObjectContext *)context
{
    if (scheduleEvent.hasUnits != nil) {
        for (ScheduleEventUnit *unit in scheduleEvent.hasUnits) {
            [context deleteObject:unit];
        }
    }
}
@end
