//
//  ScheduleEvent.h
//  Centris
//
//  Created by Bjarki Sörens on 9/23/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseInstance;

@interface ScheduleEvent : NSManagedObject

@property (nonatomic, retain) NSNumber * ends;
@property (nonatomic, retain) NSString * roomName;
@property (nonatomic, retain) NSDate * starts;
@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) NSString * typeOfClass;
@property (nonatomic, retain) CourseInstance *hasCourseInstance;

@end
