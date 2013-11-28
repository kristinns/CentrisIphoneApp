//
//  AssignmentFile+Centris_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 26/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentFile+Centris.h"
#import "Assignment+Centris.h"
#import "CourseInstance+Centris.h"
#import "NSDate+Helper.h"

SPEC_BEGIN(AssignmentFileCentrisSpec)

describe(@"AssignmentFile Category", ^{
    __block NSManagedObjectContext *context = nil;
    __block Assignment *assignment = nil;
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
        assignment = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
        assignment.id = [NSNumber numberWithInteger:1];
        assignment.isInCourseInstance = courseInstance;
        assignment.title = @"Assignment 1";
        assignment.assignmentDescription = @"Some description";
        assignment.datePublished = range[@"from"];
        assignment.dateClosed = [(NSDate *)range[@"to"] dateByAddingDays:5];
        assignment.isInCourseInstance = courseInstance;
        assignment.handInDate = [NSDate convertToDate:@"2013-11-21T14:31:31" withFormat:nil]; // handed in
    });
    
    it(@"should be able to add assignmentfiles to assignment", ^{
        NSMutableDictionary *newAssignmentFile = [[NSMutableDictionary alloc] init];
        [newAssignmentFile setObject:@"test.pdf" forKey:@"Filename"];
        [newAssignmentFile setObject:@"2013-11-21T13:37:01" forKey:@"LastUpdated"];
        [newAssignmentFile setObject:@"SolutionFile" forKey:@"Type"];
        [newAssignmentFile setObject:@"http://www.mbl.is" forKey:@"URL"];
        
        [AssignmentFile addAssignmentFilesForAssignment:assignment withAssignmentFiles:@[newAssignmentFile] inManagedObjectContext:context];
        [[theValue([assignment.hasFiles count]) should] equal:theValue(1)];
        AssignmentFile *file = [[assignment.hasFiles allObjects] firstObject];
        [[theValue([file.fileName isEqualToString:@"test.pdf"]) should] beTrue];
    });
    
    it(@"should be able to remove assignmentfiles from assignment", ^{
        NSMutableDictionary *newAssignmentFile = [[NSMutableDictionary alloc] init];
        [newAssignmentFile setObject:@"test.pdf" forKey:@"Filename"];
        [newAssignmentFile setObject:@"2013-11-21T13:37:01" forKey:@"LastUpdated"];
        [newAssignmentFile setObject:@"SolutionFile" forKey:@"Type"];
        [newAssignmentFile setObject:@"http://www.mbl.is" forKey:@"URL"];
        [[theValue([assignment.hasFiles count]) should] equal:theValue(0)];
        [AssignmentFile addAssignmentFilesForAssignment:assignment withAssignmentFiles:@[newAssignmentFile] inManagedObjectContext:context];
        [AssignmentFile removeAssignmentFilesForAssignment:assignment inManagedObjectContext:context];
        [[theValue([assignment.hasFiles count]) should] equal:theValue(0)];
    });
});

SPEC_END


