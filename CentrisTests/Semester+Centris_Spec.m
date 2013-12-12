//
//  Semester+Centris_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 12/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Semester+Centris.h"
#import "CourseInstance+Centris.h"
#import "Assignment+Centris.h"
#import "NSDate+Helper.h"
SPEC_BEGIN(SemesterCentrisSpec)
describe(@"Semester Category", ^{
    __block NSManagedObjectContext *context = nil;
    __block Semester *semester = nil;
    beforeAll(^{
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
        
        // Set up dummy semesters
        semester = [NSEntityDescription insertNewObjectForEntityForName:@"Semester" inManagedObjectContext:context];
        semester.id_semester = @"20133";
        Semester *semester2 = [NSEntityDescription insertNewObjectForEntityForName:@"Semester" inManagedObjectContext:context];
        semester2.id_semester = @"20131";
        
        // Set up dummy course instance to be ready for testing
        CourseInstance *courseInstance = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance" inManagedObjectContext:context];
        courseInstance.id = [NSNumber numberWithInteger:22363];
        courseInstance.courseID = @"T-111-PROG";
        courseInstance.name = @"Forritun";
        courseInstance.semester = @"20133";
        courseInstance.isInSemester = semester;
        
        // Set up dummy assignments
        Assignment *assignment1 = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
        assignment1.id = [NSNumber numberWithInteger:1];
        assignment1.isInCourseInstance = courseInstance;
        assignment1.title = @"Assignment 1";
        assignment1.assignmentDescription = @"Some description";
        assignment1.isInCourseInstance = courseInstance;
        assignment1.handInDate = [NSDate convertToDate:@"2013-11-21T14:31:31" withFormat:nil]; // handed in
        assignment1.grade = [NSNumber numberWithFloat:8.5f];
        
        Assignment *assignment2 = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
        assignment2.id = [NSNumber numberWithInteger:1];
        assignment2.isInCourseInstance = courseInstance;
        assignment2.title = @"Assignment 2";
        assignment2.assignmentDescription = @"Some description";
        assignment2.isInCourseInstance = courseInstance;
        assignment2.handInDate = [NSDate convertToDate:@"2013-11-21T14:31:31" withFormat:nil]; // handed in
        assignment2.grade = [NSNumber numberWithFloat:3.3f];
        
    });
    
    it(@"should be able to retrieve all semesters in core data", ^{
        NSArray *checkSemesters = [Semester semestersInManagedObjectContext:context];
        [[theValue([checkSemesters count]) should] equal:theValue(2)];
    });
    
    it(@"should be able to calculate the average grade for all graded assignments in a semester", ^{
        NSNumber *checkAverageGrade = [NSNumber numberWithFloat:[semester averageGrade]];
        [[theValue([checkAverageGrade isEqual:[NSNumber numberWithFloat:5.9f]]) should] beTrue];
    });
});
SPEC_END
























