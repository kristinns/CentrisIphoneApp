//
//  Semester+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 12/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Semester+Centris.h"
#import "CDDataFetcher.h"
#import "CourseInstance+Centris.h"
#import "ScheduleEvent+Centris.h"

@implementation Semester (Centris)

+ (Semester *)semesterWithID:(NSString *)semesterID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id_semester = %@", semesterID];
    return [[CDDataFetcher fetchObjectsFromDBWithEntity:@"Semester"
                                                forKey:@"id_semester"
                                         sortAscending:NO
                                         withPredicate:pred
                                inManagedObjectContext:context] lastObject];
}

+ (NSArray *)semestersInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"Semester"
                                                forKey:@"id_semester"
                                         sortAscending:YES
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

- (float)averageGrade
{
    NSSet *courseInstances = self.hasCourseInstances;
    if (![courseInstances count])
        return 0.0;
    float average = 0.0f;
    float totalECTS = 0.0f;
    for (CourseInstance *courseInstance in courseInstances) {
        if ([courseInstance hasFinalResults]) {
            if (courseInstance.finalGrade != nil) {
                average += [courseInstance.finalGrade floatValue] * [courseInstance.ects floatValue];
                totalECTS += [courseInstance.ects floatValue];
            }
        } else {
            float weightedAverageFromCourseInstance = [courseInstance weightedAverageGrade];
            average += weightedAverageFromCourseInstance * [courseInstance.ects floatValue];
            if (weightedAverageFromCourseInstance)
                totalECTS+= [courseInstance.ects floatValue];
        }
    }
    return average / totalECTS;
}


- (float)progressForDate:(NSDate *)date
{
    NSDictionary *semesterRange = [self semesterRange];
    NSInteger totalTime = [semesterRange[@"ends"] timeIntervalSinceDate:semesterRange[@"starts"]];
    return totalTime == 0 ? 0.0 : [date timeIntervalSinceDate:semesterRange[@"starts"]] / totalTime;
}

- (NSInteger)totalEcts
{
    NSInteger totalECTS = 0;
    for (CourseInstance *courseInstance in self.hasCourseInstances) {
        totalECTS = totalECTS + [courseInstance.ects integerValue];
    }
    return totalECTS;
}

- (NSInteger)finishedEcts
{
    NSInteger finishedEcts = 0;
    for (CourseInstance *courseInstance in [self.hasCourseInstances allObjects]) {
        if ([courseInstance isPassed])
            finishedEcts = finishedEcts + [courseInstance.ects integerValue];
    }
    return finishedEcts;
}

- (float)totalPercentagesFromGradesInSemester
{
    NSSet *courseInstances = self.hasCourseInstances;
    if (![courseInstances count])
        return 0.0;
    float totalPercentagesFromAssignmentsInSemester = 0.0f;
    float totalEcts = 0;
    for (CourseInstance *courseInstance in courseInstances) {
        float totalPercentagesFromAssignmentsInCourse = [courseInstance totalPercentagesFromAssignments];
        totalPercentagesFromAssignmentsInSemester += totalPercentagesFromAssignmentsInCourse * [courseInstance.ects floatValue];
        totalEcts += [courseInstance.ects floatValue];
    }
    return (totalPercentagesFromAssignmentsInSemester / (totalEcts * 100.0f));
}

- (NSInteger)weeksLeft:(NSDate *)date
{
    NSDictionary *semesterRange = [self semesterRange];
    NSInteger totalTime = [semesterRange[@"ends"] timeIntervalSinceDate:date];
    return MAX(0, totalTime / (60 * 60 * 24 * 7));
}

- (NSDictionary *)semesterRange
{
    NSMutableDictionary *range = [[NSMutableDictionary alloc] init];
    NSMutableArray *events = [[NSMutableArray alloc] init];
    NSSet *courseInstances = self.hasCourseInstances;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"starts" ascending:YES]; // smallest date first
    for (CourseInstance *courseInstance in courseInstances) {
        NSArray *scheduleEvents = [courseInstance.hasScheduleEvents sortedArrayUsingDescriptors:@[sortDescriptor]];
        if (![scheduleEvents count]) {
            continue;
        } else if ([scheduleEvents count] == 1) {
            [events addObject:[scheduleEvents firstObject]];
        } else {
            [events addObject:[scheduleEvents firstObject]];
            [events addObject: [scheduleEvents lastObject]];
        }
    }
    NSArray *sortedEvents = [events sortedArrayUsingDescriptors:@[sortDescriptor]];
    NSDate *semesterStarts = ((ScheduleEvent *)[sortedEvents firstObject]).starts;
    NSDate *semesterEnds = ((ScheduleEvent *)[sortedEvents lastObject]).ends;
    if (semesterStarts != nil)
        [range setObject:semesterStarts forKey:@"starts"];
    if (semesterEnds != nil)
        [range setObject:semesterEnds forKey:@"ends"];
    return range;
}

@end






















