//
//  CentrisDataFetcher.h
//  Centris
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"

@interface CentrisDataFetcher : NSObject <DataFetcher>
+ (NSArray *)getAssignmentsForCourseWithCourseID:(NSString *)courseID inSemester:(NSString *)semester;
+ (NSArray *)getCoursesForStudentWithSSN:(NSString *)SSN;
+ (NSArray *)getScheduleBySSN:(NSString *)SSN;

+ (NSDictionary *)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password;
@end
