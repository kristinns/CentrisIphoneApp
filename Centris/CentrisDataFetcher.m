//
//  CentrisDataFetcher.m
//  Centris
//

#import "CentrisDataFetcher.h"

#define CENTRIS_API_URL @"http://centris.dev.nem.ru.is/api2/api/v1/"

@implementation CentrisDataFetcher

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

+ (NSArray *)getAssignments
{
  	// TODO
    NSMutableArray *assignments = nil;
    return assignments;
}

+ (NSArray *)getAssignmentCourses
{
    // TODO
    NSMutableArray *courses = nil;
	return courses;
}

+ (NSDictionary *)getUser:(NSString *)bySSN
{
    return [self executeFetch:[NSString stringWithFormat:@"%@%@", @"students/", bySSN]];
}

+ (NSArray *)getSchedule:(NSString *)bySSN from:(NSDate *)fromDate to:(NSDate *)toDate
{
	
//	NSCalendar *calendar = [NSCalendar currentCalendar];
//	NSDateComponents *components = [calendar components:(NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit fromDate:<#(NSDate *)#>];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
	
	NSString *fromDateString = [formatter stringFromDate:fromDate];
	NSString *toDateString = [formatter stringFromDate:toDate];
	
	
	// TODO: This should return list of dictionaries... or a single dictionary.
	// Might be buggy!
	return @[[self executeFetch:[NSString stringWithFormat:@"students/%@/schedule?range=%@,%@",bySSN, fromDateString, toDateString]]];
}

@end
