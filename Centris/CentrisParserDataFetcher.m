//
//  CentrisDataFetcher.m
//  Centris
//

#import "CentrisParserDataFetcher.h"
#import <AFNetworking/AFNetworking.h>
#import "AppFactory.h"

#define CENTRIS_API_URL @"http://centris.nfsu.is"

@interface CentrisParserDataFetcher()
@end

@implementation CentrisParserDataFetcher : NSObject

#pragma mark - Helper
+ (NSDictionary *)userCredentialsObject
{
    NSString *userEmail = [[AppFactory keychainItemWrapper] objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [[AppFactory keychainItemWrapper] objectForKey:(__bridge id)(kSecValueData)];
    NSDictionary *userCred = @{@"email":userEmail, @"password":password};
    return userCred;
}

#pragma mark - Get methods
+ (void)getAssignmentsInSemester:(NSString *)semester success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://centris.nfsu.is/assignments"
      parameters:[self userCredentialsObject]
         success:success
         failure:failure];
}

+ (void)getAssignmentById:(NSInteger)assignmentId courseId:(NSInteger)courseId
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://centris.nfsu.is/assignments/%d/%d", courseId, assignmentId]
      parameters:[self userCredentialsObject]
         success:success
         failure:failure];
}

+ (void)getAssignmentFileWithUrl:(NSString *)url
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url
      parameters:[self userCredentialsObject]
         success:success
         failure:failure];
}

+ (void)getCoursesInSemester:(NSString *)semester success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://centris.nfsu.is/courses"
      parameters:[self userCredentialsObject]
         success:success
         failure:failure];
}

+ (void)getScheduleInSemester:(NSString *)semester success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://centris.nfsu.is/schedules"
      parameters:[self userCredentialsObject]
         success:success
         failure:failure];
}

#pragma mark - Post methods
+ (void)loginUserWithUsername:(NSString *)email andPassword:(NSString *)password success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSDictionary *userCred = @{@"email":email, @"password":password};
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://centris.nfsu.is/user"
      parameters:userCred
         success:success
         failure:failure];
}

@end
