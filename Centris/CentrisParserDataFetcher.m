//
//  CentrisDataFetcher.m
//  Centris
//

#import "CentrisParserDataFetcher.h"
#import <AFNetworking/AFNetworking.h>

#define CENTRIS_API_URL @"http://centris.nfsu.is"

@implementation CentrisParserDataFetcher : NSObject

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
+ (NSArray *)getAssignmentsForCourseWithCourseID:(NSString *)courseID inSemester:(NSString *)semester success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableArray *assignments = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://centris.nfsu.is/assignments" parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    return assignments;
}

+ (NSArray *)getCoursesForStudentWithSSN:(NSString *)SSN success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableArray *courses = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://centris.nfsu.is/courses" parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

	return courses;
}

+ (NSArray *)getScheduleBySSN:(NSString *)SSN success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableArray *schedule = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://centris.nfsu.is/schedules" parameters:nil success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return schedule;
}

#pragma mark - Post methods
+ (NSDictionary *)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password;
{
	NSMutableDictionary *info = nil;
	
	if ([@"kristinns11@ru.is" isEqualToString:email]) {
		info = [[NSMutableDictionary alloc] init];
		NSMutableDictionary * person = [[NSMutableDictionary alloc] init];
		[person setObject:@"Tröllhólum 12" forKey:@"Address"];
		[person setObject:@"kristinns11@ru.is" forKey:@"Email"];
		[person setObject:@"18748" forKey:@"ID"];
		[person setObject:@"8657231" forKey:@"MobilePhone"];
		[person setObject:@"Kristinn Svansson" forKey:@"Name"];
		[person setObject:@"800" forKey:@"Postal"];
		[person setObject:@"2402912319" forKey:@"SSN"];
		[info setObject:person forKey:@"Person"];
		
		NSMutableDictionary *registration = [[NSMutableDictionary  alloc] init];
		NSMutableDictionary *studentRegistration = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *major = [[NSMutableDictionary alloc] init];
		
		[registration setObject:@"Tölvunarfræðideild" forKey:@"DepartmentName"];
		[registration setObject:@"Staðarnám" forKey:@"StudentTypeName"];
		
		[studentRegistration setObject:[NSNumber numberWithInteger:18] forKey:@"ECTSActive"];
		[studentRegistration setObject:[NSNumber numberWithInteger:72] forKey:@"ECTSFinished"];
		[studentRegistration setObject:[NSNumber numberWithDouble:9] forKey:@"AverageGrade"];
		[registration setObject:studentRegistration forKey:@"StudentRegistration"];
		
		[major setObject:@"BSc í tölvunarfræði" forKey:@"Name"];
		[major setObject:@"BSc in Computer Science" forKey:@"NameEnglish"];
		[major setObject:[NSNumber numberWithInteger:180] forKey:@"Credits"];
		[registration setObject:major forKey:@"Major"];
		
		[info setObject:registration forKey:@"Registration"];
		
        
	} else if ([@"bjarkim11@ru.is" isEqualToString:email]) {
		info = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *person = [[NSMutableDictionary alloc] init];
		[person setObject:@"Ljósheimum 2" forKey:@"Address"];
		[person setObject:@"bjarkim11@ru.is" forKey:@"Email"];
		[person setObject:@"18703" forKey:@"ID"];
		[person setObject:@"8698649" forKey:@"MobilePhone"];
		[person setObject:@"Bjarki Sörens Madsen" forKey:@"Name"];
		[person setObject:@"104" forKey:@"Postal"];
		[person setObject:@"0805903269" forKey:@"SSN"];
		[info setObject:person forKey:@"Person"];
		
		NSMutableDictionary *registration = [[NSMutableDictionary  alloc] init];
		NSMutableDictionary *studentRegistration = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *major = [[NSMutableDictionary alloc] init];
		
		[registration setObject:@"Tölvunarfræðideild" forKey:@"DepartmentName"];
		[registration setObject:@"Staðarnám" forKey:@"StudentTypeName"];
		
		[studentRegistration setObject:[NSNumber numberWithInteger:24] forKey:@"ECTSActive"];
		[studentRegistration setObject:[NSNumber numberWithInteger:66] forKey:@"ECTSFinished"];
		[studentRegistration setObject:[NSNumber numberWithDouble:7.5] forKey:@"AverageGrade"];
		[registration setObject:studentRegistration forKey:@"StudentRegistration"];
		
		[major setObject:@"BSc í tölvunarfræði" forKey:@"Name"];
		[major setObject:@"BSc in Computer Science" forKey:@"NameEnglish"];
		[major setObject:[NSNumber numberWithInteger:180] forKey:@"Credits"];
		[registration setObject:major forKey:@"Major"];
		
		[info setObject:registration forKey:@"Registration"];
	}
	else {
		return nil;
	}
	
	return info;
}


@end