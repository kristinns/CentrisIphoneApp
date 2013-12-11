//
//  CourseInstance+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 9/23/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstance+Centris.h"
#import "Assignment+Centris.h"
#import "CDDataFetcher.h"
#import "DataFetcher.h"

@implementation CourseInstance (Centris)

+(CourseInstance *)courseInstanceWithID:(NSInteger)courseID inManagedObjectContext:(NSManagedObjectContext *)context
{
	CourseInstance *instance = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %d", courseID];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"CourseInstance"
                                                            forKey:@"id"
                                                     sortAscending:NO
                                                     withPredicate:pred
                                            inManagedObjectContext:context];

    NSString *assertFailMessage = [NSString stringWithFormat:@"there should only be one courseinstance with cousreid: %d", courseID];
    NSAssert([matches count ] == 1, assertFailMessage);
    instance = [matches lastObject];
	
	return instance;
}

+ (CourseInstance *)courseInstanceWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    CourseInstance *courseInstance = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", centrisInfo[@"ID"]];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"CourseInstance"
                                                            forKey:@"id"
                                                     sortAscending:NO
                                                     withPredicate:pred
                                            inManagedObjectContext:context];
    
    if (![matches count]) { // no result, proceed with storing
        courseInstance = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance" inManagedObjectContext:context];
        courseInstance.id = centrisInfo[COURSE_INSTANCE_ID];
        courseInstance.courseID = centrisInfo[COURSE_ID];
        courseInstance.name = centrisInfo[COURSE_NAME];
        courseInstance.semester = centrisInfo[COURSE_SEMESTER];
    } else {
        return [matches lastObject];
    }
    return courseInstance;
}

+ (NSArray *)courseInstancesInManagedObjectContext:(NSManagedObjectContext *)context;
{
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"CourseInstance"
                                                forKey:@"name"
                                         sortAscending:NO
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

- (float)averageGrade
{
    float average = 0.0;
    
    // get instance
    NSSet *assignments = self.hasAssignments;
    
    for (Assignment *assignment in assignments) {
        if (assignment.grade != nil) {
            average = average + [assignment.grade floatValue];
        }
    }
    return average / ([assignments count]);
}

- (float)totalPercentagesFromAssignments
{
    float percentages = 0.0;
    NSSet *assignments = self.hasAssignments;
    for (Assignment *assignment in assignments) {
        if (assignment.grade != nil) {
            percentages = percentages + [assignment.weight floatValue];
        }
    }
    return percentages;
}

- (float)weightedAverageGrade
{
    float weightedAverage = 0.0;
    for (Assignment *assignment  in self.hasAssignments) {
        weightedAverage = weightedAverage + (([assignment.weight floatValue] / 100.0) * [assignment.grade floatValue]);
    }
    return weightedAverage;
}

@end























