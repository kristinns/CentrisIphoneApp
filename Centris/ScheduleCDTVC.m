//
//  ScheduleCDTVC.m
//  Centris
//
//  Created by Bjarki Sörens on 10/8/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleCDTVC.h"

@implementation ScheduleCDTVC

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
	_managedObjectContext = managedObjectContext;
	if (managedObjectContext) {
		NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ScheduleEvent"];
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"starts" ascending:YES]];
		request.predicate = nil; // All events... might be better to only get some events
		self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
	} else {
		self.fetchedResultsController = nil;
	}
}
@end
