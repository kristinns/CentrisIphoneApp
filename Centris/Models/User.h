//
//  User.h
//  Centris
//
//  Created by Bjarki Sörens on 10/15/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseInstance;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * ssn;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * majorIS;
@property (nonatomic, retain) NSString * majorEN;
@property (nonatomic, retain) NSNumber * activeECTS;
@property (nonatomic, retain) NSNumber * finishedECTS;
@property (nonatomic, retain) NSNumber * averageGrade;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * majorCredits;
@property (nonatomic, retain) CourseInstance *isInCourseInstance;

@end
