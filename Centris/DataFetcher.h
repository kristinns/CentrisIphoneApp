//
//  DataFetcher.h
//  Centris
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataFetcher <NSObject>
+ (NSArray *)getAssignmentsForUserWithSSN:(NSString *)SSN;
+ (NSArray *)getAssignmentCourses;
+ (NSArray *)getCoursesForStudentWithSSN:(NSString *)SSN;
+ (NSDictionary *)getUser:(NSString *)bySSN;
+ (NSDictionary *)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password;
+ (NSArray *)getScheduleBySSN:(NSString *)SSN;
@end
