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

@implementation Semester (Centris)

+ (NSArray *)semestersInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"Semester"
                                                forKey:@"id_semester"
                                         sortAscending:NO
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

- (float)weightedAverageGrade
{
    NSSet *courseInstances = self.hasCourseInstances;
    float average = 0.0f;
    float totalPercentage = 0.0f;
    for (CourseInstance *courseInstance in courseInstances) {
        average = average + ([courseInstance totalPercentagesFromAssignments] / 100.0f * [courseInstance aquiredGrade]);
        totalPercentage = totalPercentage + [courseInstance totalPercentagesFromAssignments];
    }
    return average / totalPercentage;
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
    return 0.0;
}

@end
