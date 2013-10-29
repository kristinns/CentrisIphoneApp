//
//  Assignment+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 10/22/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Assignment+Centris.h"
#import "CourseInstance+Centris.h"
#import "CDDataFetcher.h"

@implementation Assignment (Centris)

+(Assignment *)addAssignmentWithCentrisInfo:(NSDictionary *)assignmentInfo withCourseInstanceID:(NSInteger)courseInstanceID inManagedObjectContext:(NSManagedObjectContext *)context
{
	Assignment *assignment = nil;

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", assignmentInfo[@"ID"]];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"Assignment" forKey:@"id" sortAscending:NO withPredicate:pred inManagedObjectContext:context];
	
	if (![matches count]) { // no results
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
		CourseInstance *courseInst = [CourseInstance courseInstanceWithID:courseInstanceID inManagedObjectContext:context];
        assignment.isInCourseInstance = courseInst;
	} else { // assignment found, return it.
		assignment = [matches lastObject];
	}
	
	return assignment;
}

+(NSArray *)assignmentsWithDueDateThatExceeds:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"dateClosed > %@", date];
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"Assignment"
                                                forKey:@"dateClosed"
                                         sortAscending:NO
                                         withPredicate:pred
                                inManagedObjectContext:context];
}

+ (NSArray *)assignmentsInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"Assignment"
                                                forKey:@"dateClosed"
                                         sortAscending:NO
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

#pragma mark - Helpers

+ (NSDate *)icelandicFormatWithDateString:(NSString *)dateString
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
	return [formatter dateFromString:dateString];
}

@end
