//
//  CourseInstance.h
//  Centris
//
//  Created by Kristinn Svansson on 28/10/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assignment, ScheduleEvent, User;

@interface CourseInstance : NSManagedObject

@property (nonatomic, retain) NSString * courseID;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * semester;
@property (nonatomic, retain) NSSet *hasAssignments;
@property (nonatomic, retain) NSSet *hasScheduleEvents;
@property (nonatomic, retain) User *hasUser;
@end

@interface CourseInstance (CoreDataGeneratedAccessors)

- (void)addHasAssignmentsObject:(Assignment *)value;
- (void)removeHasAssignmentsObject:(Assignment *)value;
- (void)addHasAssignments:(NSSet *)values;
- (void)removeHasAssignments:(NSSet *)values;

- (void)addHasScheduleEventsObject:(ScheduleEvent *)value;
- (void)removeHasScheduleEventsObject:(ScheduleEvent *)value;
- (void)addHasScheduleEvents:(NSSet *)values;
- (void)removeHasScheduleEvents:(NSSet *)values;

@end
