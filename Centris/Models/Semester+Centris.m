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

- (float)averageGrade
{
    NSSet *courseInstances = self.hasCourseInstances;
    float average = 0.0f;
    
    for (CourseInstance *courseInstance in courseInstances) {
        average = average + [courseInstance averageGrade];
    }
    return average / ([courseInstances count]);
}

@end
