//
//  ScheduleEvent.h
//  Centris
//
//  Created by Bjarki Sörens on 17/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseInstance, ScheduleEventUnit;

@interface ScheduleEvent : NSManagedObject

@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSDate * ends;
@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) NSString * roomName;
@property (nonatomic, retain) NSDate * starts;
@property (nonatomic, retain) NSString * typeOfClass;
@property (nonatomic, retain) CourseInstance *hasCourseInstance;
@property (nonatomic, retain) NSSet *hasUnits;
@end

@interface ScheduleEvent (CoreDataGeneratedAccessors)

- (void)addHasUnitsObject:(ScheduleEventUnit *)value;
- (void)removeHasUnitsObject:(ScheduleEventUnit *)value;
- (void)addHasUnits:(NSSet *)values;
- (void)removeHasUnits:(NSSet *)values;

@end
