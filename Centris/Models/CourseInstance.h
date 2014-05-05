//
//  CourseInstance.h
//  Centris
//
//  Created by Kristinn Svansson on 11/01/14.
//  Copyright (c) 2014 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Announcement, Assignment, ScheduleEvent, Semester, User;

@interface CourseInstance : NSManagedObject

@property (nonatomic, retain) NSString * assessmentMethods;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * courseID;
@property (nonatomic, retain) NSNumber * ects;
@property (nonatomic, retain) NSNumber * finalGrade;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * learningOutcome;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * semester;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * syllabus;
@property (nonatomic, retain) NSString * teachingMethods;
@property (nonatomic, retain) NSSet *hasAnnouncements;
@property (nonatomic, retain) NSSet *hasAssignments;
@property (nonatomic, retain) NSSet *hasScheduleEvents;
@property (nonatomic, retain) User *hasUser;
@property (nonatomic, retain) Semester *isInSemester;
@end

@interface CourseInstance (CoreDataGeneratedAccessors)

- (void)addHasAnnouncementsObject:(Announcement *)value;
- (void)removeHasAnnouncementsObject:(Announcement *)value;
- (void)addHasAnnouncements:(NSSet *)values;
- (void)removeHasAnnouncements:(NSSet *)values;

- (void)addHasAssignmentsObject:(Assignment *)value;
- (void)removeHasAssignmentsObject:(Assignment *)value;
- (void)addHasAssignments:(NSSet *)values;
- (void)removeHasAssignments:(NSSet *)values;

- (void)addHasScheduleEventsObject:(ScheduleEvent *)value;
- (void)removeHasScheduleEventsObject:(ScheduleEvent *)value;
- (void)addHasScheduleEvents:(NSSet *)values;
- (void)removeHasScheduleEvents:(NSSet *)values;

@end
