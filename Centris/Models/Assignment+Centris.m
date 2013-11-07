//
//  Assignment+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 10/22/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Assignment+Centris.h"
#import "DataFetcher.h"
#import "CourseInstance+Centris.h"
#import "CDDataFetcher.h"
#import "NSDate+Helper.h"

@implementation Assignment (Centris)

+(Assignment *)addAssignmentWithCentrisInfo:(NSDictionary *)assignmentInfo withCourseInstanceID:(NSInteger)courseInstanceID inManagedObjectContext:(NSManagedObjectContext *)context
{
	Assignment *assignment = nil;

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", assignmentInfo[@"ID"]];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"Assignment" forKey:@"id" sortAscending:NO withPredicate:pred inManagedObjectContext:context];
	
	if (![matches count]) { // no results
		assignment = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
		assignment.id = assignmentInfo[ASSIGNMENT_ID];
		assignment.title = assignmentInfo[ASSIGNMENT_TITLE];
		assignment.assignmentDescription = assignmentInfo[ASSIGNMENT_DESCRIPTION];
		for (NSString *extension in assignmentInfo[ASSIGNMENT_ALLOWED_FILE_EXTENSIONS]) {
			assignment.fileExtensions = [assignment.fileExtensions stringByAppendingString:extension];
			assignment.fileExtensions = [assignment.fileExtensions stringByAppendingString:@" "]; // Maybe a bad implementation. Suggestions are well appreciated.
		}
		assignment.weight = assignmentInfo[ASSIGNMENT_WEIGHT];
		assignment.maxGroupSize = assignmentInfo[ASSIGNMENT_MAX_STUDENTS_IN_GROUP];
		assignment.datePublished = [NSDate formatDateString:assignmentInfo[ASSIGNMENT_DATE_PUBLISHED]];
		assignment.dateClosed = [NSDate formatDateString:assignmentInfo[ASSIGNMENT_DATE_CLOSED]];
		CourseInstance *courseInst = [CourseInstance courseInstanceWithID:courseInstanceID inManagedObjectContext:context];
        assignment.isInCourseInstance = courseInst;
        assignment.groupID = assignmentInfo[ASSIGNMENT_GROUP_ID] == (id)[NSNull null] ? nil : assignmentInfo[ASSIGNMENT_GROUP_ID] ;
        assignment.grade = assignmentInfo[ASSIGNMENT_GRADE] == (id)[NSNull null] ? nil : assignmentInfo[ASSIGNMENT_GRADE];
        assignment.studentMemo = assignmentInfo[ASSIGNMENT_STUDENT_MEMO] == (id)[NSNull null] ? nil : assignmentInfo[ASSIGNMENT_STUDENT_MEMO];
        assignment.teacherMemo = assignmentInfo[ASSIGNMENT_TEACHER_MEMO] == (id)[NSNull null] ? nil : assignmentInfo[ASSIGNMENT_TEACHER_MEMO];
        assignment.handInDate = assignmentInfo[ASSIGNMENT_HANDIN_DATE] == (id)[NSNull null] ? nil : [NSDate formatDateString:assignmentInfo[ASSIGNMENT_HANDIN_DATE]];
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

@end
