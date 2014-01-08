//
//  Assignment+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 10/22/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Assignment.h"

#define ASSIGNMENT_LAST_UPDATED @"AssignmentsLastUpdate"

@interface Assignment (Centris)
+ (Assignment *)assignmentWithID:(NSNumber *)ID inManagedObjectContext:(NSManagedObjectContext *)context;                           // tested

+ (NSArray *)assignmentsInManagedObjectContext:(NSManagedObjectContext *)context;                                                   // tested
+ (NSArray *)assignmentsNotHandedInForCurrentDateInManagedObjectContext:(NSManagedObjectContext *)context;                          // tested
+ (NSArray *)assignmentsWithDueDateThatExceeds:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;             // tested

+ (void)addAssignmentsWithCentrisInfo:(NSArray *)assignments inManagedObjectContext:(NSManagedObjectContext *)context;              // tested
+ (void)updateAssignmentWithCentrisInfo:(NSDictionary *)assignmentInfo inManagedObjectContext:(NSManagedObjectContext *)context;    // tested
@end
