//
//  Announcement.h
//  Centris
//
//  Created by Kristinn Svansson on 14/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseInstance;

@interface Announcement : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * dateInserted;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) CourseInstance *isInCourseInstance;

@end
