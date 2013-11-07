//
//  CentrisDataFetcher.h
//  Centris
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"

@interface CentrisDataFetcher : NSObject <DataFetcher>
// Get
+ (void)getAssignmentsInSemester:(NSString *)semester
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)getCoursesInSemester:(NSString *)semester
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)getScheduleInSemester:(NSString *)semester
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
// Post
+ (void)loginUserWithUsername:(NSString *)email andPassword:(NSString *)password
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
