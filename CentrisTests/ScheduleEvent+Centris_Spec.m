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
    __block NSDictionary *range = nil;
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
        range = [NSDate dateRangeForTheWholeDay:[NSDate date]];
        // Set up dummy course instance to be ready for testing
        CourseInstance *courseInstance = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance" inManagedObjectContext:context];
        courseInstance.id = [NSNumber numberWithInteger:22363];
        courseInstance.courseID = @"T-111-PROG";
        courseInstance.name = @"Forritun";
        courseInstance.semester = @"20133";
        
        CourseInstance *courseInstance2 = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance" inManagedObjectContext:context];
        courseInstance2.id = [NSNumber numberWithInteger:22364];
        courseInstance2.courseID = @"T-109-INTO";
        courseInstance2.name = @"Inngangur að tölvunarfræði";
        courseInstance2.semester = @"20133";
        
        
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
        
        // SCHEDULEEVENT 2
        ScheduleEvent *scheduleEvent2 = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
        scheduleEvent2.courseName = courseInstance.name;
        scheduleEvent2.starts = [[(NSDate *)range[@"from"] dateByAddingHours:10] dateByAddingMintues:20];
        scheduleEvent2.ends = [[(NSDate *)range[@"from"] dateByAddingHours:11] dateByAddingMintues:55];
        scheduleEvent2.eventID = [NSNumber numberWithInteger:2];
        scheduleEvent2.roomName = @"M101";
        scheduleEvent2.typeOfClass = @"Fyrirlestur";
        scheduleEvent2.hasCourseInstance = courseInstance;
        
        ScheduleEventUnit *scheduleEventUnit3 = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEventUnit" inManagedObjectContext:context];
        scheduleEventUnit3.starts = [[(NSDate *)range[@"from"] dateByAddingHours:10] dateByAddingMintues:20];
        scheduleEventUnit3.ends = [[(NSDate *)range[@"from"] dateByAddingHours:11] dateByAddingMintues:05];
        scheduleEventUnit3.id = @"2_1";
        scheduleEventUnit3.isAUnitOf = scheduleEvent2;

        ScheduleEventUnit *scheduleEventUnit4 = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEventUnit" inManagedObjectContext:context];
        scheduleEventUnit4.starts = [[(NSDate *)range[@"from"] dateByAddingHours:11] dateByAddingMintues:10];
        scheduleEventUnit4.ends = [[(NSDate *)range[@"from"] dateByAddingHours:11] dateByAddingMintues:55];
        scheduleEventUnit4.id = @"2_2";
        scheduleEventUnit4.isAUnitOf = scheduleEvent2;
        // END OF SCHEDULEEVENT 2
        
        // SCHEDULEEVENT 3
        ScheduleEvent *scheduleEvent3 = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
        scheduleEvent3.courseName = courseInstance.name;
        scheduleEvent3.starts = [[(NSDate *)range[@"from"] dateByAddingDays:1] dateByAddingHours:8];
        scheduleEvent3.ends = [[[(NSDate *)range[@"from"] dateByAddingDays:1] dateByAddingHours:10] dateByAddingMintues:5];
        scheduleEvent3.eventID = [NSNumber numberWithInteger:2];
        scheduleEvent3.roomName = @"M101";
        scheduleEvent3.typeOfClass = @"Fyrirlestur";
        scheduleEvent3.hasCourseInstance = courseInstance;
        
        ScheduleEventUnit *scheduleEventUnit5 = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEventUnit" inManagedObjectContext:context];
        scheduleEventUnit5.starts = [[(NSDate *)range[@"from"] dateByAddingDays:1] dateByAddingHours:8];
        scheduleEventUnit5.ends = [[[(NSDate *)range[@"from"] dateByAddingDays:1] dateByAddingHours:9] dateByAddingMintues:15];
        scheduleEventUnit5.id = @"3_1";
        scheduleEventUnit5.isAUnitOf = scheduleEvent3;
        
        ScheduleEventUnit *scheduleEventUnit6 = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEventUnit" inManagedObjectContext:context];
        scheduleEventUnit6.starts = [[[(NSDate *)range[@"from"] dateByAddingDays:1] dateByAddingHours:9] dateByAddingMintues:20];
        scheduleEventUnit6.ends = [[[(NSDate *)range[@"from"] dateByAddingDays:1] dateByAddingHours:10] dateByAddingMintues:5];
        scheduleEventUnit6.id = @"3_2";
        scheduleEventUnit6.isAUnitOf = scheduleEvent3;
        // END OF SCHEDULEEVENT 3
        
        // Set up dummy final exam to be ready for testing
        ScheduleEvent *finalExam = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
        finalExam.courseName = courseInstance.name;
        finalExam.starts = [NSDate convertToDate:@"2013-12-04T09:00:00" withFormat:nil];
        finalExam.ends = [NSDate convertToDate:@"2013-12-04T12:00:00" withFormat:nil];
        finalExam.eventID = [NSNumber numberWithInteger:2];
        finalExam.roomName = @"M101";
        finalExam.typeOfClass = @"Lokapróf";
        finalExam.hasCourseInstance = courseInstance;
        
        ScheduleEvent *finalExam2 = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
        finalExam2.courseName = courseInstance2.name;
        finalExam2.starts = [NSDate convertToDate:@"2013-12-10T09:00:00" withFormat:nil];
        finalExam2.ends = [NSDate convertToDate:@"2013-12-10T12:00:00" withFormat:nil];
        finalExam2.eventID = [NSNumber numberWithInteger:2];
        finalExam2.roomName = @"M101";
        finalExam2.typeOfClass = @"Lokapróf";
        finalExam2.hasCourseInstance = courseInstance;

    });
    
    it(@"should be able to get an event with an id", ^{
        ScheduleEvent *checkEvent = [ScheduleEvent eventWithID:[NSNumber numberWithInteger:1] inManagedObjectContext:context];
        [[checkEvent shouldNot] beNil];
        [[theValue([checkEvent.hasUnits count]) should] equal:theValue(2)];
    });
    
    it(@"should be able to get schedule event units for certain date", ^{
        NSArray *checkEventUnits = [ScheduleEvent scheduleEventUnitsForDay:[NSDate convertToDate:@"2013-11-27T00:00:00" withFormat:nil] inManagedObjectContext:context];
        [[theValue([checkEventUnits count]) should] equal:theValue(2)];
    });
    
    it(@"should be able to retrieve all events from core data", ^{
        NSArray *checkEvents = [ScheduleEvent eventsInManagedObjectContext:context];
        [[theValue([checkEvents count]) should] equal:theValue(5)];
    });
    
    it(@"should be able to retrieve all event units for the current date", ^{
        NSArray *checkEvents = [ScheduleEvent scheduleEventUnitsForCurrentDateInMangedObjectContext:context];
        [[theValue([checkEvents count]) should] equal:theValue(1)];
    });
    
    it(@"should be able to retrieve the next event schedule for the current date or the next morning", ^{
        NSArray *nextEvents = [ScheduleEvent nextEventForDate:[(NSDate *)range[@"from"] dateByAddingHours:8] InManagedObjectContext:context];
        [[theValue([nextEvents count]) should] equal:theValue(1)];
        NSArray *nextEvents2 = [ScheduleEvent nextEventForDate:[(NSDate *)range[@"from"] dateByAddingHours:22] InManagedObjectContext:context];
        [[theValue([nextEvents2 count]) should] equal:theValue(1)];
    });
    
    it(@"should be able to retrieve final exams properly", ^{
        NSArray *checkFinalExams = [ScheduleEvent finalExamsExceedingDate:[NSDate convertToDate:@"2013-11-27T12:00:00" withFormat:nil] InManagedObjectContext:context];
        [[theValue([checkFinalExams count]) should] equal:theValue(2)];
    });
    
    it(@"should be able to add schedule events to core data", ^{
        NSMutableArray *events = [[NSMutableArray alloc] init];
        [events addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                             @"1", @"ID",
                             @"22363", @"CourseID",
                             @"Inngangur að tölvunarfræði", @"CourseName",
                             @"M106", @"RoomName",
                             @"2013-11-28T12:20:00", @"StartTime",
                             @"2013-11-28T13:55:00", @"EndTime",
                             @"Dæmatími",@"TypeOfClass", nil]];
        [ScheduleEvent addScheduleEventsWithCentrisInfo:events inManagedObjectContext:context];
        NSArray *checkEventUnits = [ScheduleEvent scheduleEventUnitsForDay:[NSDate convertToDate:@"2013-11-28T12:00:00" withFormat:nil] inManagedObjectContext:context];
        [[theValue([checkEventUnits count]) should] equal:theValue(2)];
    });
    
});
SPEC_END
