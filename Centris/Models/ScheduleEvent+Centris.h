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
+ (ScheduleEvent *)eventWithID:(NSNumber *)ID inManagedObjectContext:(NSManagedObjectContext *)context;                 // tested
+ (NSArray *)scheduleEventUnitsForDay:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;          // tested
+ (NSArray *)eventsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)scheduleEventUnitsForCurrentDateInMangedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)nextEventForCurrentDateInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)finalExamsExceedingDate:(NSDate *)date InManagedObjectContext:(NSManagedObjectContext *)context;           // tested

+ (void)addScheduleEventsWithCentrisInfo:(NSArray *)events inManagedObjectContext:(NSManagedObjectContext *)context;
@end
