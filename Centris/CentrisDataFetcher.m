//
//  CentrisDataFetcher.m
//  Centris
//

#import "CentrisDataFetcher.h"
#import <AFNetworking/AFNetworking.h>

#define CENTRIS_API_URL @"http://centris.dev.nem.ru.is/api2/api/v1/"

@implementation CentrisDataFetcher

#pragma mark - Get methods
+ (void)getAssignmentsInSemester:(NSString *)semester success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
  	// TODO
}

+ (void)getCoursesInSemester:(NSString *)semester success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    // TODO
}

+ (void)getScheduleInSemester:(NSString *)semester success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    // TODO
}

#pragma mark - Post methods
+ (void)loginUserWithUsername:(NSString *)email andPassword:(NSString *)password success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    // TODO
}

+ (void)getAssignmentById:(NSInteger)assignmentId courseId:(NSInteger)courseId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    // TODO
}

@end
