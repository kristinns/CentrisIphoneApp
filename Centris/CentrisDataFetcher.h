//
//  CentrisDataFetcher.h
//  Centris
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"

@interface CentrisDataFetcher : NSObject <DataFetcher>
+ (NSArray *)getAssignments;
+ (NSArray *)getAssignmentCourses;
+ (NSDictionary *)getUser:(NSString *)bySSN;
+ (NSArray *)getSchedule:(NSString *)bySSN
						 from:(NSDate *)fromDate
						   to:(NSDate *)toDate;
@end
