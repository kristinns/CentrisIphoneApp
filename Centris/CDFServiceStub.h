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
+ (NSArray *)getAssignments;
+ (NSArray *)getAssignmentCourses;
+ (NSArray *)getCoursesForStudentWithSSN:(NSString *)SSN;
+ (NSDictionary *)getUser:(NSString *)bySSN;
+ (NSDictionary *)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password;
+ (NSArray *)getSchedule:(NSString *)bySSN from:(NSDate *)fromDate to:(NSDate *)toDate;
@end
