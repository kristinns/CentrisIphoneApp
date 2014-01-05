//
//  CourseInstance+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 9/23/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstance.h"

#define COURSE_INSTANCE_LAST_UPDATE @"CourseInstanceLastUpdate"

@interface CourseInstance (Centris)
+ (CourseInstance *)courseInstanceWithID:(NSInteger)courseID inManagedObjectContext:(NSManagedObjectContext *) context;                         // tested
+ (CourseInstance *)addCourseInstanceWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context;      // tested

+ (NSArray *)courseInstancesInManagedObjectContext:(NSManagedObjectContext *)context;                                                           // tested
- (NSArray *)gradedAssignmentsWithNonZeroWeight;                                                                                                // tested
- (float)averageGrade;                                                                                                                          // tested
- (NSArray *)averageGradeDevelopment;
- (float)weightedAverageGrade;
- (float)totalPercentagesFromAssignments;                                                                                                       // tested
- (float)acquiredGrade;                                                                                                                          // tested
- (BOOL)isPassed;
- (BOOL)isFailed;
- (BOOL)hasFinalResults;
@end

