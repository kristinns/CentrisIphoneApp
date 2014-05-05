//
//  Announcement.h
//  Centris
//
//  Created by Kristinn Svansson on 11/01/14.
//  Copyright (c) 2014 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseInstance;

@interface Announcement : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * dateInserted;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) CourseInstance *isInCourseInstance;

@end
