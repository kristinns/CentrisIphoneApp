//
//  ScheduleEvent+Centris_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 27/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleEvent+Centris.h"
#import "ScheduleEventUnit+Centris.h"
#import "CourseInstance+Centris.h"
#import "NSDate+Helper.h"

SPEC_BEGIN(ScheduleEventCentrisSpec)
describe(@"ScheduleEvent Category", ^{
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
        
        // Set up dummy event to be ready for testing
        ScheduleEvent *scheduleEvent = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
        scheduleEvent.courseName = courseInstance.name;
        scheduleEvent.starts = [NSDate convertToDate:@"2013-11-27T08:30:00" withFormat:nil];
        scheduleEvent.ends = [NSDate convertToDate:@"2013-11-27T10:05:00" withFormat:nil];
        scheduleEvent.eventID = [NSNumber numberWithInteger:1];
        scheduleEvent.roomName = @"M101";
        scheduleEvent.typeOfClass = @"Fyrirlestur";
        scheduleEvent.hasCourseInstance = courseInstance;
        
        // set up dummy event units to be ready for testing
        ScheduleEventUnit *scheduleEventUnit = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEventUnit" inManagedObjectContext:context];
        scheduleEventUnit.starts = [NSDate convertToDate:@"2013-11-27T08:30:00" withFormat:nil];
        scheduleEventUnit.ends = [NSDate convertToDate:@"2013-11-27T09:15:00" withFormat:nil];
        scheduleEventUnit.id = @"1_1";
        scheduleEventUnit.isAUnitOf = scheduleEvent;
        
        ScheduleEventUnit *scheduleEventUnit2 = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEventUnit" inManagedObjectContext:context];
        scheduleEventUnit2.starts = [NSDate convertToDate:@"2013-11-27T09:20:00" withFormat:nil];
        scheduleEventUnit2.ends = [NSDate convertToDate:@"2013-11-27T10:05:00" withFormat:nil];
        scheduleEventUnit2.id = @"1_2";
        scheduleEventUnit2.isAUnitOf = scheduleEvent;
    });
    
    it(@"should be able to get an event with an id", ^{
        ScheduleEvent *checkEvent = [ScheduleEvent eventWithID:[NSNumber numberWithInteger:1] inManagedObjectContext:context];
        [[checkEvent shouldNot] beNil];
        [[theValue([checkEvent.hasUnits count]) should] equal:theValue(2)];
    });
    
});
SPEC_END
