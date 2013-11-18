//
//  AssignmentFile+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 18/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentFile.h"

@interface AssignmentFile (Centris)
+ (void)addAssignmentsFileForAssignment:(Assignment *)assignment withAssignmentFiles:(NSArray *)assignmentsFileInfo inManagedObjectContext:(NSManagedObjectContext *)context;
@end
