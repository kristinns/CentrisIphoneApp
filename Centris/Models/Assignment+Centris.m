//
//  Assignment+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 10/22/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Assignment+Centris.h"

@implementation Assignment (Centris)

+(Assignment *)addAssignmentWithCentrisInfo:(NSDictionary *)assignmentInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
	Assignment *assignment = nil;
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Assignment"];
	
	request.predicate = [NSPredicate predicateWithFormat:@"id = %@", assignmentInfo[@"ID"]];
	
	NSError *error = nil;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches) { // error
		NSLog(@"Error %@", error);
	} else if (![matches count]) { // no results
		assignment = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
		assignment.id = assignmentInfo[@"ID"];
		assignment.title = assignmentInfo[@"Title"];
		assignment.assignmentDescription = assignmentInfo[@"Description"];
		for (NSString *extension in assignmentInfo[@"AllowedFileExtensions"]) {
			assignment.fileExtensions = [assignment.fileExtensions stringByAppendingString:extension];
			assignment.fileExtensions = [assignment.fileExtensions stringByAppendingString:@" "]; // Maybe a bad implementation. Suggestions are well appreciated.
		}
		assignment.weight = assignmentInfo[@"Weight"];
		assignment.maxGroupSize = assignmentInfo[@"MaxStudentsInGroup"];
		assignment.datePublished = [self icelandicFormatWithDateString:assignmentInfo[@"DatePublished"]];
		assignment.dateClosed = [self icelandicFormatWithDateString:assignmentInfo[@"DateClosed"]];
		
		// TODO, hook it up to a courseinstance
		
	} else { // assignment found, return it.
		assignment = [matches lastObject];
	}
	
	return assignment;
}

+(NSArray *)assignmentsWithDueDateThatExceeds:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"dateClosed > %@", date];
    return [self fetchEventsFromDBWithEntity:@"Assignment"
                                      forKey:@"dateClosed"
                               withPredicate:pred
                      inManagedObjectContext:context];
}

#pragma mark - Helpers

+ (NSMutableArray*)fetchEventsFromDBWithEntity:(NSString*)entityName forKey:(NSString*)keyName withPredicate:(NSPredicate*)predicate inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyName ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
	
    if (predicate != nil)
        [request setPredicate:predicate];
	
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"%@", error);
    }
    return mutableFetchResults;
}

+ (NSDate *)icelandicFormatWithDateString:(NSString *)dateString
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
	return [formatter dateFromString:dateString];
}

@end
