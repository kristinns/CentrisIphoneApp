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
#import "ScheduleEvent+Centris.h"

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)

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
        courseInstance.ects = [NSNumber numberWithInteger:6];
        
        CourseInstance *courseInstance2 = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance" inManagedObjectContext:context];
        courseInstance2.id = [NSNumber numberWithInteger:22364];
        courseInstance2.courseID = @"T-109-INTO";
        courseInstance2.name = @"Inngangur að tölvunarfræði";
        courseInstance2.semester = @"20133";
        courseInstance2.isInSemester = semester;
        courseInstance2.ects = [NSNumber numberWithInteger:6];
        
        // Set up dummy assignments
        Assignment *assignment1 = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
        assignment1.id = [NSNumber numberWithInteger:1];
        assignment1.isInCourseInstance = courseInstance;
        assignment1.title = @"Assignment 1";
        assignment1.assignmentDescription = @"Some description";
        assignment1.isInCourseInstance = courseInstance;
        assignment1.handInDate = [NSDate convertToDate:@"2013-11-21T14:31:31" withFormat:nil]; // handed in
        assignment1.grade = [NSNumber numberWithFloat:8.5f];
        assignment1.weight = [NSNumber numberWithFloat:12.5f];

        Assignment *assignment2 = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
        assignment2.id = [NSNumber numberWithInteger:1];
        assignment2.isInCourseInstance = courseInstance;
        assignment2.title = @"Assignment 2";
        assignment2.assignmentDescription = @"Some description";
        assignment2.isInCourseInstance = courseInstance;
        assignment2.handInDate = [NSDate convertToDate:@"2013-11-21T14:31:31" withFormat:nil]; // handed in
        assignment2.grade = [NSNumber numberWithFloat:3.3f];
        assignment2.weight = [NSNumber numberWithFloat:5.0f];
        
        // Set up dummy events
        ScheduleEvent *scheduleEvent = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
        scheduleEvent.courseName = courseInstance.name;
        scheduleEvent.starts = [NSDate convertToDate:@"2013-08-18T08:30:00" withFormat:nil];
        scheduleEvent.ends = [NSDate convertToDate:@"2013-08-18T10:05:00" withFormat:nil];
        scheduleEvent.eventID = [NSNumber numberWithInteger:1];
        scheduleEvent.roomName = @"M101";
        scheduleEvent.typeOfClass = @"Fyrirlestur";
        scheduleEvent.hasCourseInstance = courseInstance;
        
        ScheduleEvent *finalExam = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
        finalExam.courseName = courseInstance.name;
        finalExam.starts = [NSDate convertToDate:@"2013-12-18T09:00:00" withFormat:nil];
        finalExam.ends = [NSDate convertToDate:@"2013-12-18T12:00:00" withFormat:nil];
        finalExam.eventID = [NSNumber numberWithInteger:2];
        finalExam.roomName = @"M101";
        finalExam.typeOfClass = @"Lokapróf";
        finalExam.hasCourseInstance = courseInstance;
        
        ScheduleEvent *scheduleEvent2 = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEvent" inManagedObjectContext:context];
        scheduleEvent2.courseName = courseInstance2.name;
        scheduleEvent2.starts = [NSDate convertToDate:@"2013-08-24T08:30:00" withFormat:nil];
        scheduleEvent2.ends = [NSDate convertToDate:@"2013-08-24T10:05:00" withFormat:nil];
        scheduleEvent2.eventID = [NSNumber numberWithInteger:1];
        scheduleEvent2.roomName = @"M101";
        scheduleEvent2.typeOfClass = @"Fyrirlestur";
        scheduleEvent2.hasCourseInstance = courseInstance2;
        
    });
    
    it(@"should be able to retrieve all semesters in core data", ^{
        NSArray *checkSemesters = [Semester semestersInManagedObjectContext:context];
        [[theValue([checkSemesters count]) should] equal:theValue(2)];
    });
    
    it(@"should be able to calculate the average of the average weighted grade for all courseinstances in a semester", ^{
        float checkAverageGrade = [semester averageGrade];
        NSString *stringCompare = [NSString stringWithFormat:@"%.2f", checkAverageGrade];
        [[theValue([stringCompare isEqualToString:@"7.01"]) should] beTrue];
    });
    
    it(@"should be able to get progress of the semester", ^{
        float checkProgress = [semester progressForDate:[NSDate convertToDate:@"2013-10-01T12:00:00" withFormat:nil]];
        NSString *stringCompare = [NSString stringWithFormat:@"%.3f", checkProgress];
        [[theValue([stringCompare isEqualToString:@"0.361"]) should] beTrue];
    });
    
    it(@"should be able to retrieve total ects for a semseter", ^{
        NSInteger checkECTS = [semester totalEcts];
        [[theValue(checkECTS) should] equal:theValue(12)];
    });
});
SPEC_END
























