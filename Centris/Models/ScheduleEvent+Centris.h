//
//  ScheduleEvent+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEvent.h"

@interface ScheduleEvent (Centris)
+(NSSet *)scheduledEventsFrom:(NSDate *)fromDate
						   to:(NSDate *)toDate
	   inManagedObjectContext:(NSManagedObjectContext *)context;


@end
