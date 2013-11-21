//
//  ScheduleEventUnit+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 18/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEventUnit.h"

@interface ScheduleEventUnit (Centris)
+ (void)addScheduleEventUnitForScheduleEvent:(ScheduleEvent *)scheduleEvent withScheduleEventUnits:(NSArray *)scheduleEventUnits inManagedObjectContext:(NSManagedObjectContext *)context;
@end
