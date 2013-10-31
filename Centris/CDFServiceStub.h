//
//  CDFServiceStub.h
//  Centris
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"

@interface CDFServiceStub : NSObject <DataFetcher>
+ (NSArray *)getAssignmentsForCourseWithCourseID:(NSString *)courseID inSemester:(NSString *)semester;
+ (NSArray *)getCoursesForStudentWithSSN:(NSString *)SSN;
+ (NSArray *)getScheduleBySSN:(NSString *)SSN;

+ (NSDictionary *)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password;
@end
