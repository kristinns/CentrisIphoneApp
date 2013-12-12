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
+ (NSArray *)eventsInManagedObjectContext:(NSManagedObjectContext *)context;                                            // tested
+ (NSArray *)scheduleEventUnitsForCurrentDateInMangedObjectContext:(NSManagedObjectContext *)context;                   // tested
+ (NSArray *)nextEventForDate:(NSDate *)date InManagedObjectContext:(NSManagedObjectContext *)context;                  // tested
+ (NSArray *)finalExamsExceedingDate:(NSDate *)date InManagedObjectContext:(NSManagedObjectContext *)context;           // tested

+ (void)addScheduleEventsWithCentrisInfo:(NSArray *)events inManagedObjectContext:(NSManagedObjectContext *)context;    // tested
@end
