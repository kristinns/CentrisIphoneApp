//
//  CentrisDataFetcher.m
//  Centris
//

#import "CentrisDataFetcher.h"

@implementation CentrisDataFetcher

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

@end
