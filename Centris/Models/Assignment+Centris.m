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

+ (NSDate *)icelandicFormatWithDateString:(NSString *)dateString
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
	return [formatter dateFromString:dateString];
}

@end
