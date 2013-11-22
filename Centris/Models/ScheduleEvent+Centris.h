//
//  ScheduleEvent+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEvent.h"
#import "ScheduleEventUnit.h"

@interface ScheduleEvent (Centris)
+ (NSArray *)scheduleEventUnitsFromDay:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)eventsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)eventWithID:(NSNumber *)ID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (ScheduleEvent *)nextEventForDay:(NSDate *)day inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)addScheduleEventsWithCentrisInfo:(NSArray *)events inManagedObjectContext:(NSManagedObjectContext *)context;
@end
