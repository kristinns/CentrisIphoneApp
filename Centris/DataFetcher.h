//
//  DataFetcher.h
//  Centris
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataFetcher <NSObject>

+ (NSArray *)getAssignments;
+ (NSArray *)getAssignmentCourses;
+ (NSDictionary *)getUser:(NSString *)bySSN;
+ (NSArray *)getSchedule:(NSString *)bySSN
						 from:(NSDate *)fromDate
						   to:(NSDate *)toDate;
@end