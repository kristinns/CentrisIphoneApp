//
//  CourseInstance+Centris_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 27/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstance+Centris.h"
#import "Assignment+Centris.h"
#import "NSDate+Helper.h"

SPEC_BEGIN(CourseInstanceCentrisSpec)

describe(@"CourseInstance Category", ^{
    __block NSManagedObjectContext *context = nil;
    __block CourseInstance *courseInstance;
    
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
        
        // Set up dummy course instance to be ready for testing
        courseInstance = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance" inManagedObjectContext:context];
        courseInstance.id = [NSNumber numberWithInteger:22363];
        courseInstance.courseID = @"T-111-PROG";
        courseInstance.name = @"Forritun";
        courseInstance.semester = @"20133";
        
        // Set up dummy assignments to be ready for testing
        Assignment *assignment1 = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
        assignment1.id = [NSNumber numberWithInteger:1];
        assignment1.isInCourseInstance = courseInstance;
        assignment1.title = @"Assignment 1";
        assignment1.assignmentDescription = @"Some description";
        assignment1.datePublished = [NSDate convertToDate:@"2013-11-12T14:31:31" withFormat:nil];
        assignment1.dateClosed = [NSDate convertToDate:@"2013-11-25T14:31:31" withFormat:nil];
        assignment1.isInCourseInstance = courseInstance;
        assignment1.handInDate = [NSDate convertToDate:@"2013-11-21T14:31:31" withFormat:nil]; // handed in
        assignment1.grade = [NSNumber numberWithFloat:8.5];
        assignment1.weight = [NSNumber numberWithFloat:5];
        
        Assignment *assignment2 = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
        assignment2.id = [NSNumber numberWithInteger:1];
        assignment2.isInCourseInstance = courseInstance;
        assignment2.title = @"Assignment 1";
        assignment2.assignmentDescription = @"Some description";
        assignment2.datePublished = [NSDate convertToDate:@"2013-10-12T14:31:31" withFormat:nil];
        assignment2.dateClosed = [NSDate convertToDate:@"2013-10-25T14:31:31" withFormat:nil];
        assignment2.isInCourseInstance = courseInstance;
        assignment2.handInDate = [NSDate convertToDate:@"2013-10-21T14:31:31" withFormat:nil]; // handed in
        assignment2.grade = [NSNumber numberWithFloat:10];
        assignment2.weight = [NSNumber numberWithFloat:10.5];

    });
    
    it(@"should be able to retrieve single courseinstance by id", ^{
        CourseInstance *checkCourseInstance = [CourseInstance courseInstanceWithID:22363 inManagedObjectContext:context];
        [[checkCourseInstance shouldNot] beNil];
    });
    
    it(@"should be able to retrieve all courseinstances in core data", ^{
        NSArray *checkResults = [CourseInstance courseInstancesInManagedObjectContext:context];
        [[theValue([checkResults count]) should] equal:theValue(1)];
    });
    
    it(@"should be able to add courseinstance with given dictionary to core data", ^{
        // T-111-PROG
        NSMutableDictionary *courseInst2 = [[NSMutableDictionary alloc] init];
        [courseInst2 setObject:[NSNumber numberWithInt:22212] forKey:@"ID"];
        [courseInst2 setObject:@"T-111-PROG" forKey:@"CourseID"];
        [courseInst2 setObject:@"Forritun" forKey:@"Name"];
        [courseInst2 setObject:@"20113" forKey:@"Semester"];
        [courseInst2 setObject:@"Some syllabus" forKey:@"Syllabus"];
        [courseInst2 setObject:@"Some content" forKey:@"Content"];
        [courseInst2 setObject:@"Some assessment methods" forKey:@"AssessmentMethods"];
        [courseInst2 setObject:@"Some learning outcome" forKey:@"LearningOutcome"];
        [courseInst2 setObject:@"Some teaching methods" forKey:@"TeachingMethods"];

        
        [CourseInstance addCourseInstanceWithCentrisInfo:courseInst2 inManagedObjectContext:context];
        NSArray *checkResults = [CourseInstance courseInstancesInManagedObjectContext:context];
        [[theValue([checkResults count]) should] equal:theValue(2)];

    });
    
    it(@"should be able to get average grade for graded assignments in a course", ^{
        float avg = [courseInstance averageGrade];
        [[theValue(avg) should] equal:theValue(9.25)];
    });
    
    it(@"should be able to get total percentages for graded assignments in a course", ^{
        float totalPercentages = [courseInstance totalPercentagesFromAssignments];
        [[theValue(totalPercentages) should] equal:theValue(15.5)];
    });
    
    it(@"should be able to get weighted average for graded assignments in a course", ^{
        NSNumber *weightedAvg = [NSNumber numberWithFloat:[courseInstance weightedAverageGrade]];
        [[theValue([weightedAvg isEqual:@1.475f]) should] beTrue];
    });
    
    it(@"should be able to get assignments that have been graded in a courseinstance", ^{
        NSArray *checkAssignments = [courseInstance gradedAssignments];
        [[theValue([checkAssignments count]) should] equal:theValue(2)];
    });
});

SPEC_END





























