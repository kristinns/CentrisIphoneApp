//
//  CentrisDataFetcher.m
//  Centris
//

#import "CentrisDataFetcher.h"
#import <AFNetworking/AFNetworking.h>

#define CENTRIS_API_URL @"http://centris.dev.nem.ru.is/api2/api/v1/"

@implementation CentrisDataFetcher

#pragma mark - Helper
+ (NSDictionary *)executeFetch:(NSString *)query
{
	NSString *url = [NSString stringWithFormat:@"%@%@", CENTRIS_API_URL, query];
	
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    //NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    
    return results;
}

#pragma mark - Get methods
+ (NSArray *)getAssignmentsForCourseWithCourseID:(NSString *)courseID inSemester:(NSString *)semester
{
  	// TODO
    NSMutableArray *assignments = nil;
    return assignments;
}

+ (NSArray *)getCoursesForStudentWithSSN:(NSString *)SSN
{
    // TODO
    NSMutableArray *courses = nil;
	return courses;
}

+ (NSArray *)getScheduleBySSN:(NSString *)SSN
{
    // TODO
    NSMutableArray *schedule = nil;
    return schedule;
}

#pragma mark - Post methods
+ (NSDictionary *)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password
{
    // TODO
    NSDictionary *user = nil;
    return user;
}

@end
