//
//  CentrisDataFetcher.h
//  Centris
//
//  Created by Kristinn Svansson on 8/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CentrisDataFetcher : NSObject
+ (NSArray *)getAssignments;
+ (NSArray *)getAssignmentCourses;
@end
