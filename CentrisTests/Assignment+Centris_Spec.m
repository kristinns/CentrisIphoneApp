//
//  Assignment+Centris_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 25/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Assignment+Centris.h"
#import "CourseInstance+Centris.h"
#import "NSDate+Helper.h"

SPEC_BEGIN(AssignmentCentrisSpec)

describe(@"Assignment Category", ^{
    
    __block NSManagedObjectContext *context = nil;
    
    beforeEach(^{
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil]; // nil makes it retrieve our main bundle
        NSError *error;
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        if (![coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
            NSLog(@"Could not init coordinator in Unit Tests");
        }
        
        if (coordinator != nil) {
            context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [context setPersistentStoreCoordinator:coordinator];
        } else {
            NSLog(@"Could not set coordinator in Unit Tests");
        }
        
        // Set up dummy course instance to be ready for testing
        CourseInstance *courseInstance = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance" inManagedObjectContext:context];
        courseInstance.id = [NSNumber numberWithInteger:22363];
        courseInstance.courseID = @"T-111-PROG";
        courseInstance.name = @"Forritun";
        courseInstance.semester = @"20133";
        
        // Create a date range that is always available
        NSDictionary *range = [NSDate dateRangeForTheWholeDay:[NSDate date]];
        
        // Set up dummy assignments to be ready for testing
        Assignment *assignment1 = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
        assignment1.id = [NSNumber numberWithInteger:1];
        assignment1.isInCourseInstance = courseInstance;
        assignment1.title = @"Assignment 1";
        assignment1.assignmentDescription = @"Some description";
        assignment1.datePublished = range[@"from"];
        assignment1.dateClosed = [(NSDate *)range[@"to"] dateByAddingDays:5];
        assignment1.isInCourseInstance = courseInstance;
        assignment1.handInDate = [NSDate convertToDate:@"2013-11-21T14:31:31" withFormat:nil]; // handed in
        
        Assignment *assignment2 = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
        assignment2.id = [NSNumber numberWithInteger:2];
        assignment2.isInCourseInstance = courseInstance;
        assignment2.title = @"Assignment 2";
        assignment2.assignmentDescription = @"Some more description";
        assignment2.datePublished = range[@"from"];
        assignment2.dateClosed = range[@"to"];
        assignment2.isInCourseInstance = courseInstance;
        
    });
    
    it(@"should retrieve all assignments in core data", ^{
        NSArray *checkAssignments = [Assignment assignmentsInManagedObjectContext:context];
        [[theValue([checkAssignments count]) should] equal:theValue(2)];
    });
    
    it(@"should get a single assignment for a given id", ^{
        Assignment *checkAssignment = [Assignment assignmentWithID:[NSNumber numberWithInteger:1] inManagedObjectContext:context];
        [[checkAssignment shouldNot] beNil];
        [[theValue([checkAssignment.id integerValue]) should] equal:theValue(1)];
        [[theValue([checkAssignment.title isEqualToString:@"Assignment 1"]) should] beTrue];
    });
    
    it(@"should get the assignment that is due today and has not been handed in", ^{
        NSArray *checkAssignments = [Assignment assignmentsNotHandedInForCurrentDateInManagedObjectContext:context];
        [[theValue([checkAssignments count]) should] equal:theValue(1)];
    });
    
    it(@"should get assignment that have due date exceeding the current date", ^{
        NSArray *checkAssignments = [Assignment assignmentsWithDueDateThatExceeds:[NSDate date] inManagedObjectContext:context];
        [[theValue([checkAssignments count]) should] equal:theValue(2)];
    });
    
    it(@"should add assignments properly to core data and remove assignments that do not appear in the list", ^{
        NSMutableDictionary *newAssignment = [[NSMutableDictionary alloc] init];
        [newAssignment setObject:[NSNumber numberWithInteger:3] forKey:@"ID"];
        [newAssignment setObject:@"Assignment 3" forKey:@"Title"];
        [newAssignment setObject:@"Some even more description" forKey:@"Description"];
        NSMutableArray *l1 = [[NSMutableArray alloc] init];
        [l1 addObject:@"doc"];
        [l1 addObject:@"docx"];
        [l1 addObject:@"pdf"];
        [l1 addObject:@"html"];
        [l1 addObject:@"odt"];
        [newAssignment setObject:l1 forKey:@"AllowedFileExtensions"];
        [newAssignment setObject:[NSNumber numberWithInteger:8] forKey:@"Weight"];
        [newAssignment setObject:[NSNumber numberWithInteger:1] forKey:@"MaxStudentsInGroup"];
        [newAssignment setObject:@"2013-10-26T15:00:00" forKey:@"DatePublished"];
        [newAssignment setObject:@"2013-11-25T23:59:00" forKey:@"DateClosed"];
        [newAssignment setObject:[NSNumber numberWithInteger:22363] forKey:@"CourseInstanceID"];
        [newAssignment setObject:[NSNull null] forKey:@"GroupID"];
        [newAssignment setObject:[NSNull null] forKey:@"Grade"];
        [newAssignment setObject:[NSNull null] forKey:@"StudentMemo"];
        [newAssignment setObject:[NSNull null] forKey:@"TeacherMemo"];
        [newAssignment setObject:[NSNull null] forKey:@"Closes"];
        NSArray *checkAssignments = [Assignment assignmentsInManagedObjectContext:context];
        [Assignment addAssignmentsWithCentrisInfo:@[newAssignment] inManagedObjectContext:context];
        checkAssignments = [Assignment assignmentsInManagedObjectContext:context];
        [[theValue([checkAssignments count]) should] equal:theValue(1)]; // this should be the only assignment
    });
    
    it(@"should be able to add assignment properly without files", ^{
        NSMutableDictionary *newAssignment = [[NSMutableDictionary alloc] init];
        [newAssignment setObject:[NSNumber numberWithInteger:3] forKey:@"ID"];
        [newAssignment setObject:@"Assignment 3" forKey:@"Title"];
        [newAssignment setObject:@"Some even more description" forKey:@"Description"];
        [newAssignment setObject:[NSNull null] forKey:@"AllowedFileExtensions"];
        [newAssignment setObject:[NSNumber numberWithInteger:8] forKey:@"Weight"];
        [newAssignment setObject:[NSNumber numberWithInteger:1] forKey:@"MaxStudentsInGroup"];
        [newAssignment setObject:@"2013-10-26T15:00:00" forKey:@"DatePublished"];
        [newAssignment setObject:@"2013-11-25T23:59:00" forKey:@"DateClosed"];
        [newAssignment setObject:[NSNumber numberWithInteger:22363] forKey:@"CourseInstanceID"];
        [newAssignment setObject:[NSNull null] forKey:@"GroupID"];
        [newAssignment setObject:[NSNull null] forKey:@"Grade"];
        [newAssignment setObject:[NSNull null] forKey:@"StudentMemo"];
        [newAssignment setObject:[NSNull null] forKey:@"TeacherMemo"];
        [newAssignment setObject:[NSNull null] forKey:@"Closes"];
        NSArray *checkAssignments = [Assignment assignmentsInManagedObjectContext:context];
        [Assignment addAssignmentsWithCentrisInfo:@[newAssignment] inManagedObjectContext:context];
        checkAssignments = [Assignment assignmentsInManagedObjectContext:context];
        [[theValue([checkAssignments count]) should] equal:theValue(1)]; // this should be the only assignment
    });
    
    it(@"should update assignment properly with given dictionary ", ^{
        NSMutableDictionary *updateAssignment = [[NSMutableDictionary alloc] init];
        [updateAssignment setObject:[NSNumber numberWithInteger:2] forKey:@"ID"];
        [updateAssignment setObject:@"Assignment 3" forKey:@"Title"];
        [updateAssignment setObject:@"Some even more description" forKey:@"Description"];
        NSMutableArray *l1 = [[NSMutableArray alloc] init];
        [l1 addObject:@"doc"];
        [l1 addObject:@"docx"];
        [l1 addObject:@"pdf"];
        [l1 addObject:@"html"];
        [l1 addObject:@"odt"];
        [updateAssignment setObject:l1 forKey:@"AllowedFileExtensions"];
        [updateAssignment setObject:[NSNumber numberWithInteger:8] forKey:@"Weight"];
        [updateAssignment setObject:[NSNumber numberWithInteger:1] forKey:@"MaxStudentsInGroup"];
        [updateAssignment setObject:@"2013-10-26T15:00:00" forKey:@"DatePublished"];
        [updateAssignment setObject:@"2013-11-01T23:59:59" forKey:@"DateClosed"]; // put it to some random date
        [updateAssignment setObject:[NSNumber numberWithInteger:22363] forKey:@"CourseInstanceID"];
        [updateAssignment setObject:[NSNull null] forKey:@"GroupID"];
        [updateAssignment setObject:[NSNull null] forKey:@"Grade"];
        [updateAssignment setObject:[NSNull null] forKey:@"StudentMemo"];
        [updateAssignment setObject:[NSNull null] forKey:@"TeacherMemo"];
        [updateAssignment setObject:[NSNull null] forKey:@"Closes"];
        
        NSDictionary *range = [NSDate dateRangeForTheWholeDay:[NSDate date]];
        // first guarantee it has the dateClosed set to today
        Assignment *checkAssignment = [Assignment assignmentWithID:[NSNumber numberWithInteger:2] inManagedObjectContext:context];
        [[theValue([checkAssignment.dateClosed compare:range[@"to"]] == NSOrderedSame) should] beTrue];
        
        [Assignment updateAssignmentWithCentrisInfo:updateAssignment inManagedObjectContext:context];
        checkAssignment = [Assignment assignmentWithID:[NSNumber numberWithInteger:2] inManagedObjectContext:context];
        [[theValue([checkAssignment.dateClosed compare:[NSDate convertToDate:@"2013-11-01T23:59:59" withFormat:nil]] == NSOrderedSame) should] beTrue];
    });
});

SPEC_END
