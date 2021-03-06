//
//  Assignment.h
//  Centris
//
//  Created by Kristinn Svansson on 20/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseInstance;

@interface Assignment : NSManagedObject

@property (nonatomic, retain) NSString * assignmentDescription;
@property (nonatomic, retain) NSNumber * courseInstanceID;
@property (nonatomic, retain) NSDate * dateClosed;
@property (nonatomic, retain) NSDate * datePublished;
@property (nonatomic, retain) NSString * fileExtensions;
@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) NSNumber * groupID;
@property (nonatomic, retain) NSDate * handInDate;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * maxGroupSize;
@property (nonatomic, retain) NSString * studentMemo;
@property (nonatomic, retain) NSString * teacherMemo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSSet *hasFiles;
@property (nonatomic, retain) CourseInstance *isInCourseInstance;
@end

@interface Assignment (CoreDataGeneratedAccessors)

- (void)addHasFilesObject:(NSManagedObject *)value;
- (void)removeHasFilesObject:(NSManagedObject *)value;
- (void)addHasFiles:(NSSet *)values;
- (void)removeHasFiles:(NSSet *)values;

@end
