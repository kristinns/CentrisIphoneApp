//
//  ScheduleEvent+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEvent+Centris.h"

@implementation ScheduleEvent (Centris)

+(NSArray *)scheduledEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSArray *scheduledEvents;
	
	// create fetch request
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ScheduledEvent"];
	
	// determine what sort
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"starts" ascending:YES]];
	// create the query / predicate
	request.predicate = [NSPredicate predicateWithFormat:@"starts >= %@ AND ends <= %@", fromDate, toDate ];
	
	// execute the query
	NSError *error = nil;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches) { // error
		NSLog(@"%@",[error userInfo]);
	}
	else if (![matches count]) { // no result
		NSLog(@"No scheduled events found");
	}
	else { // something was found!
		scheduledEvents = matches;
	}
	return scheduledEvents;
}
@end
