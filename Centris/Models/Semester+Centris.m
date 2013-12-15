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
                                         sortAscending:NO
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

- (float)averageGrade
{
    NSSet *courseInstances = self.hasCourseInstances;
    if (![courseInstances count])
        return 0.0;
    float average = 0.0f;
    NSInteger counter = 0;
    for (CourseInstance *courseInstance in courseInstances) {
        float weightedAverageFromCourseInstance = [courseInstance weightedAverageGrade];
        average = average + weightedAverageFromCourseInstance;
        if (weightedAverageFromCourseInstance)
            counter++;
    }
    return average / counter;
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

- (NSInteger)weeksLeft:(NSDate *)date
{
    NSDictionary *semesterRange = [self semesterRange];
    NSInteger totalTime = [semesterRange[@"ends"] timeIntervalSinceDate:date];
    return totalTime / (60 * 60 * 24 * 7);
}

- (NSDictionary *)semesterRange
{
    NSMutableDictionary *range = [[NSMutableDictionary alloc] init];
    NSMutableArray *events = [[NSMutableArray alloc] init];
    NSSet *courseInstances = self.hasCourseInstances;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"starts" ascending:YES]; // smallest date first
    for (CourseInstance *courseInstance in courseInstances) {
        NSArray *scheduleEvents = [courseInstance.hasScheduleEvents sortedArrayUsingDescriptors:@[sortDescriptor]];
        if ([scheduleEvents count] == 1) {
            [events addObject:[scheduleEvents firstObject]];
        } else {
            [events addObject:[scheduleEvents firstObject]];
            [events addObject: [scheduleEvents lastObject]];
        }
    }
    NSArray *sortedEvents = [events sortedArrayUsingDescriptors:@[sortDescriptor]];
    NSDate *semesterStarts = ((ScheduleEvent *)[sortedEvents firstObject]).starts;
    NSDate *semesterEnds = ((ScheduleEvent *)[sortedEvents lastObject]).ends;
    [range setObject:semesterStarts forKey:@"starts"];
    [range setObject:semesterEnds forKey:@"ends"];
    return range;
}

@end






















