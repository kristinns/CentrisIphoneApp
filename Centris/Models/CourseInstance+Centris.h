//
//  CourseInstance+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 9/23/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstance.h"

@interface CourseInstance (Centris)
+ (CourseInstance *)courseInstanceWithID:(NSInteger)courseID inManagedObjectContext:(NSManagedObjectContext *) context;                         // tested
+ (CourseInstance *)courseInstanceWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context;         // tested
+ (NSArray *)courseInstancesInManagedObjectContext:(NSManagedObjectContext *)context;                                                           // tested

+ (float)averageGradeInCourseInstance:(NSInteger)courseInstanceID inManagedObjectContext:(NSManagedObjectContext *)context;                     // tested
+ (float)totalPercentagesFromAssignmentsInCourseInstance:(NSInteger)courseInstanceID inManagedObjectContext:(NSManagedObjectContext *)context;  // tested
+ (float)weightedAverageGradeInCourseInstance:(NSInteger)courseInstanceID inManagedObjectContext:(NSManagedObjectContext *)context;             // tested
@end

