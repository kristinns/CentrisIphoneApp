//
//  ScheduleEventUnit+Centris_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 11/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstance+Centris.h"
#import "ScheduleEvent+Centris.h"
#import "ScheduleEventUnit+Centris.h"
#import "NSDate+Helper.h"

SPEC_BEGIN(ScheduleEventUnitCentrisSpec)
describe(@"ScheduleEventUnit Category", ^{
    __block NSManagedObjectContext *context = nil;
    __block ScheduleEvent *scheduleEvent = nil;
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
        scheduleEvent = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
        scheduleEvent.courseName = courseInstance.name;
        scheduleEvent.starts = [NSDate convertToDate:@"2013-11-27T08:30:00" withFormat:nil];
        scheduleEvent.ends = [NSDate convertToDate:@"2013-11-27T10:05:00" withFormat:nil];
        scheduleEvent.eventID = [NSNumber numberWithInteger:1];
        scheduleEvent.roomName = @"M101";
        scheduleEvent.typeOfClass = @"Fyrirlestur";
        scheduleEvent.hasCourseInstance = courseInstance;
    });
    
    it(@"should be able to add schedule event unit properly and update properly", ^{
        NSMutableArray *eventUnits = [[NSMutableArray alloc] init];
        [eventUnits addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                           @"2013-11-27T12:20", @"StartTime",
                           @"2013-11-27T13:05", @"EndTime", nil]];
        [eventUnits addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"2013-11-27T13:10", @"StartTime",
                               @"2013-11-27T13:55", @"EndTime", nil]];
        [ScheduleEventUnit addScheduleEventUnitForScheduleEvent:scheduleEvent withScheduleEventUnits:eventUnits inManagedObjectContext:context];
        [[theValue([scheduleEvent.hasUnits count] == 2) should] beTrue];
        
        NSMutableArray *eventUnits2 = [[NSMutableArray alloc] init];
        [eventUnits2 addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"2013-11-27T14:00", @"StartTime",
                               @"2013-11-27T14:45", @"EndTime", nil]];
        [eventUnits2 addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"2013-11-27T14:55", @"StartTime",
                               @"2013-11-27T15:40", @"EndTime", nil]];
        [ScheduleEventUnit addScheduleEventUnitForScheduleEvent:scheduleEvent withScheduleEventUnits:eventUnits inManagedObjectContext:context];
        [[theValue([scheduleEvent.hasUnits count] == 2) should] beTrue];
    });

});
SPEC_END