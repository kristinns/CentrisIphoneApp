//
//  CourseInstance+Centris_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 27/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstance+Centris.h"

SPEC_BEGIN(CourseInstanceCentrisSpec)

describe(@"CourseInstance Category", ^{
    __block NSManagedObjectContext *context = nil;
    
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
        CourseInstance *courseInstance = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance" inManagedObjectContext:context];
        courseInstance.id = [NSNumber numberWithInteger:22363];
        courseInstance.courseID = @"T-111-PROG";
        courseInstance.name = @"Forritun";
        courseInstance.semester = @"20133";
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
        
        [CourseInstance courseInstanceWithCentrisInfo:courseInst2 inManagedObjectContext:context];
        NSArray *checkResults = [CourseInstance courseInstancesInManagedObjectContext:context];
        [[theValue([checkResults count]) should] equal:theValue(2)];

    });
});

SPEC_END
