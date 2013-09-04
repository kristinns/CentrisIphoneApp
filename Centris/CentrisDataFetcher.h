//
//  CentrisDataFetcher.h
//  Centris
//

#import <Foundation/Foundation.h>

@interface CentrisDataFetcher : NSObject
+ (NSArray *)getAssignments;
+ (NSArray *)getAssignmentCourses;
+ (NSDictionary *)getUser:(NSString *)bySSN;
@end
