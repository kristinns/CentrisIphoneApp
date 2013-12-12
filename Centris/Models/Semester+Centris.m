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
    NSInteger totalTime = [semesterEnds timeIntervalSinceDate:semesterStarts];
    return totalTime == 0 ? 0.0 : [date timeIntervalSinceDate:semesterStarts] / totalTime;
}

@end
