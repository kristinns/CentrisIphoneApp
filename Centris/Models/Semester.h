//
//  Semester.h
//  Centris
//
//  Created by Bjarki Sörens on 12/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseInstance;

@interface Semester : NSManagedObject

@property (nonatomic, retain) NSString * id_semester;
@property (nonatomic, retain) NSSet *hasCourseInstances;
@end

@interface Semester (CoreDataGeneratedAccessors)

- (void)addHasCourseInstancesObject:(CourseInstance *)value;
- (void)removeHasCourseInstancesObject:(CourseInstance *)value;
- (void)addHasCourseInstances:(NSSet *)values;
- (void)removeHasCourseInstances:(NSSet *)values;

@end
