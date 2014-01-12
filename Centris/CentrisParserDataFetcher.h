//
//  CentrisParserDataFetcher.h
//  Centris
//
//  Created by Kristinn Svansson on 03/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"

@interface CentrisParserDataFetcher : NSObject <DataFetcher>
// Get
+ (void)getAssignmentsInSemester:(NSString *)semester
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)getAssignmentById:(NSInteger)assignmentId courseId:(NSInteger)courseId
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)getAssignmentFileWithUrl:(NSString *)url 
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)getCoursesInSemester:(NSString *)semester
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)getCourseMaterialsForCourseID:(NSInteger)courseInstanceID success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
+ (void)getScheduleInSemester:(NSString *)semester
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)getAnnouncementWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
// Post
+ (void)loginUserWithUsername:(NSString *)email andPassword:(NSString *)password
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
