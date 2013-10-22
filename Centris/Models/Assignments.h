//
//  Assignments.h
//  Centris
//
//  Created by Bjarki Sörens on 10/22/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseInstance;

@interface Assignments : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * assignmentDescription;
@property (nonatomic, retain) NSString * fileExtensions;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * maxGroupSize;
@property (nonatomic, retain) NSDate * datePublished;
@property (nonatomic, retain) NSDate * dateClosed;
@property (nonatomic, retain) CourseInstance *isInCourseInstance;

@end
