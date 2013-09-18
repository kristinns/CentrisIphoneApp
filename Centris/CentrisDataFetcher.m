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
	NSLog(url);
	
    url = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    //NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    
    return results;
}

+ (NSArray *)getAssignments
{
    /* Fake data */
    NSMutableArray *assignments = [[NSMutableArray alloc] init];
    for(NSInteger i=1; i<= 10; i++) {
        NSString *title = [@"Verkefni " stringByAppendingString:[NSString stringWithFormat: @"%d", i]];
        NSString *finished = i == 1 || i == 3 ? @"yes" : @"no";
        NSDictionary *assignment;
        if (i == 1 || i == 3)
            assignment = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", @"Skilað 23. mars 22:32", @"date", finished, @"finished", nil];
        else
            assignment = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", @"Skilafrestur: 24. mars 23:59", @"date", finished, @"finished", nil];
        [assignments addObject:assignment];
    }

    return assignments;
}

+ (NSArray *)getAssignmentCourses
{
    /* Fake data */
    NSMutableArray *courses = [[NSMutableArray alloc] init];
    
    [courses addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Markaðsfræði", @"title", @"3", @"count", nil]];
    [courses addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Hagfræði", @"title", @"2", @"count", nil]];
    [courses addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Þjóðhagfræði", @"title", @"2", @"count", nil]];
    [courses addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Reikningshald", @"title", @"3", @"count", nil]];
    
    return courses;
}

+ (NSDictionary *)getUser:(NSString *)bySSN
{
    return [self executeFetch:[NSString stringWithFormat:@"%@%@", @"students/", bySSN]];
}

+(NSDictionary *)getSchedule:(NSString *)bySSN {
	return [self executeFetch:[NSString stringWithFormat:@"%@%@", @"schedule/", bySSN]];
}

@end
