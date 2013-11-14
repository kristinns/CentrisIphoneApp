//
//  ScheduleEvent+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEvent.h"

@interface ScheduleEvent (Centris)
+ (NSArray *)scheduleEventsFromDay:(NSDate *)fromDate inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)eventsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)eventWithID:(NSNumber *)ID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)addScheduleEventsWithCentrisInfo:(NSArray *)events inManagedObjectContext:(NSManagedObjectContext *)context;
@end
