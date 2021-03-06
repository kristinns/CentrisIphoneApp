//
//  Assignment+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 10/22/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Assignment+Centris.h"
#import "AssignmentFile+Centris.h"
#import "DataFetcher.h"
#import "CourseInstance+Centris.h"
#import "CDDataFetcher.h"
#import "NSDate+Helper.h"

@implementation Assignment (Centris)

// For given array of assignments it will put those assignments in core data and remove everything else (if any) that
// was before. 
+ (void)addAssignmentsWithCentrisInfo:(NSArray *)assignments inManagedObjectContext:(NSManagedObjectContext *)context
{
    for ( NSDictionary *assignmentInfo in assignments) {
        Assignment *assignment;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [NSNumber numberWithInteger:[assignmentInfo[ASSIGNMENT_ID] integerValue]]];
        NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"Assignment" forKey:@"id" sortAscending:NO withPredicate:pred inManagedObjectContext:context];
        if (![matches count]) { // no results
            assignment = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
            assignment.id = assignmentInfo[ASSIGNMENT_ID];
            // the rest can be updated in the helper function
            [self populateAssignmentFieldsForAssignment:assignment withAssignmentInfo:assignmentInfo inManagedObjectContext:context];
        } else { // assignment found, update its fields
            assignment = [matches lastObject];
            [self populateAssignmentFieldsForAssignment:assignment withAssignmentInfo:assignmentInfo inManagedObjectContext:context];
        }
    }
    // find assignments that needs to be deleted, if any
    [self checkToRemoveAssignmentsForCentrisAssignments:assignments inMangedObjectContext:context];
}

+ (void)updateAssignmentWithCentrisInfo:(NSDictionary *)assignmentInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Assignment *assignment = [self assignmentWithID:[NSNumber numberWithInteger:[assignmentInfo[@"ID"] integerValue]] inManagedObjectContext:context];
    if (assignment != nil)
    {
        [self populateAssignmentFieldsForAssignment:assignment withAssignmentInfo:assignmentInfo inManagedObjectContext:context];
    }
}

// get single assignment
+ (Assignment *)assignmentWithID:(NSNumber *)ID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", ID];
    return [[CDDataFetcher fetchObjectsFromDBWithEntity:@"Assignment"
                                                forKey:@"id"
                                         sortAscending:NO
                                         withPredicate:pred
                                inManagedObjectContext:context] lastObject];
}

// assignments that have due date after some date
+ (NSArray *)assignmentsWithDueDateThatExceeds:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"dateClosed > %@", date];
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"Assignment"
                                                forKey:@"dateClosed"
                                         sortAscending:YES
                                         withPredicate:pred
                                inManagedObjectContext:context];
}

// all assignments
+ (NSArray *)assignmentsInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"Assignment"
                                                forKey:@"dateClosed"
                                         sortAscending:NO
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

// Retrieves all assignments that have not been handed in for the current date
+ (NSArray *)assignmentsNotHandedInForCurrentDateInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSDictionary *range = [[NSDate date] dateRangeForTheWholeDay];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(dateClosed >= %@) AND (dateClosed <= %@) AND (handInDate = nil)", range[@"from"], range[@"to"]];
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"Assignment"
                                                forKey:@"dateClosed"
                                         sortAscending:NO
                                         withPredicate:pred
                                inManagedObjectContext:context];
}


#pragma mark - Helper methods

+ (void)populateAssignmentFieldsForAssignment:(Assignment *)assignment withAssignmentInfo:(NSDictionary *)assignmentInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    assignment.title = assignmentInfo[ASSIGNMENT_TITLE];
    assignment.assignmentDescription = assignmentInfo[ASSIGNMENT_DESCRIPTION];
    if (assignmentInfo[ASSIGNMENT_ALLOWED_FILE_EXTENSIONS] != (id)[NSNull null]) {
        for (NSString *extension in assignmentInfo[ASSIGNMENT_ALLOWED_FILE_EXTENSIONS]) {
            assignment.fileExtensions = [assignment.fileExtensions stringByAppendingString:extension];
            assignment.fileExtensions = [assignment.fileExtensions stringByAppendingString:@" "]; // Maybe a bad implementation. Suggestions are well appreciated.
        }
    }
    assignment.weight = assignmentInfo[ASSIGNMENT_WEIGHT];
    assignment.maxGroupSize = assignmentInfo[ASSIGNMENT_MAX_STUDENTS_IN_GROUP];
    assignment.datePublished = [NSDate dateFromString:assignmentInfo[ASSIGNMENT_DATE_PUBLISHED] withFormat:nil];
    assignment.dateClosed = [NSDate dateFromString:assignmentInfo[ASSIGNMENT_DATE_CLOSED] withFormat:nil];
    CourseInstance *courseInst = [CourseInstance courseInstanceWithID:[assignmentInfo[ASSIGNMENT_COURSE_INSTANCE_ID] integerValue] inManagedObjectContext:context];
    assignment.isInCourseInstance = courseInst;
    assignment.groupID = assignmentInfo[ASSIGNMENT_GROUP_ID] == (id)[NSNull null] ? nil : assignmentInfo[ASSIGNMENT_GROUP_ID] ;
    assignment.grade = assignmentInfo[ASSIGNMENT_GRADE] == (id)[NSNull null] ? nil : assignmentInfo[ASSIGNMENT_GRADE];
    assignment.studentMemo = assignmentInfo[ASSIGNMENT_STUDENT_MEMO] == (id)[NSNull null] ? nil : assignmentInfo[ASSIGNMENT_STUDENT_MEMO];
    assignment.teacherMemo = assignmentInfo[ASSIGNMENT_TEACHER_MEMO] == (id)[NSNull null] ? nil : assignmentInfo[ASSIGNMENT_TEACHER_MEMO];
    assignment.handInDate = assignmentInfo[ASSIGNMENT_HANDIN_DATE] == (id)[NSNull null] ? nil : [NSDate dateFromString:assignmentInfo[ASSIGNMENT_HANDIN_DATE] withFormat:nil];
    
    // add the files
    [AssignmentFile addAssignmentFilesForAssignment:assignment withAssignmentFiles:assignmentInfo[ASSIGNMENT_FILES] inManagedObjectContext:context];
}

// will check if the API has removed some assignments. If so, we will remove it to from core data
+ (void)checkToRemoveAssignmentsForCentrisAssignments:(NSArray *)centrisAssignments inMangedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *assignmentsInCoreData = [self assignmentsInManagedObjectContext:context];
    NSMutableSet *setToBeDeleted = [[NSMutableSet alloc] init ];
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (Assignment *a in assignmentsInCoreData)
        [setToBeDeleted addObject:a.id];
    for (NSDictionary *dic in centrisAssignments)
        [set addObject:dic[ASSIGNMENT_ID]];
    [setToBeDeleted minusSet:set];
    NSArray *arrayToBeDeleted = [setToBeDeleted allObjects];
    if ([arrayToBeDeleted count]) { // are there some assignments that needs to be removed?
        for (int i = 0; i < [arrayToBeDeleted count]; i++) {
            Assignment *assignment = [self assignmentWithID:arrayToBeDeleted[i] inManagedObjectContext:context];
            // remove its files first
            [AssignmentFile removeAssignmentFilesForAssignment:assignment inManagedObjectContext:context];
            // then remove the assignment itself
            [context deleteObject:assignment];
        }
    }
}
@end
