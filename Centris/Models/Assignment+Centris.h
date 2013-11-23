//
//  Assignment+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 10/22/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Assignment.h"

@interface Assignment (Centris)

+ (Assignment *)assignmentWithID:(NSNumber *)ID inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Assignment *)nextAssignmentForDay:(NSDate *)day inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)assignmentsWithDueDateThatExceeds:(NSDate *)date
                        inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)addAssignmentsWithCentrisInfo:(NSArray *)assignments
                       inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)updateAssignmentWithCentrisInfo:(NSDictionary *)assignmentInfo
               inManagedObjectContext:(NSManagedObjectContext *)context;


+ (NSArray *)assignmentsInManagedObjectContext:(NSManagedObjectContext *)context;
@end
