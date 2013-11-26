//
//  Assignment+Centris_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 25/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Kiwi.h"
#import "Assignment+Centris.h"
#import "CourseInstance+Centris.h"

SPEC_BEGIN(AssignmentCentrisSpec)

describe(@"MyManagedObject", ^{
    
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
        
        // Set up dummy assignment instance to be ready for testing
        Assignment *assignment = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
        assignment.id = [NSNumber numberWithInteger:1];
        assignment.isInCourseInstance = courseInstance;
    });
    
    it(@"should retrieve all assignments in core data", ^{
        NSArray *checkAssignments = [Assignment assignmentsInManagedObjectContext:context];
        [[theValue([checkAssignments count]) should] equal:theValue(1)];
    });
});

SPEC_END
