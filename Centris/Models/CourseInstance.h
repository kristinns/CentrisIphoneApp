//
//  CourseInstance.h
//  Centris
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ScheduleEvent, User;

@interface CourseInstance : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * courseID;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSSet *hasScheduleEvents;
@property (nonatomic, retain) User *hasUser;
@end

@interface CourseInstance (CoreDataGeneratedAccessors)

- (void)addHasScheduleEventsObject:(ScheduleEvent *)value;
- (void)removeHasScheduleEventsObject:(ScheduleEvent *)value;
- (void)addHasScheduleEvents:(NSSet *)values;
- (void)removeHasScheduleEvents:(NSSet *)values;

@end
