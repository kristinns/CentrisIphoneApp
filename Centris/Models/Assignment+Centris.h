//
//  Assignment+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 10/22/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Assignment.h"

@interface Assignment (Centris)
+ (Assignment *)addAssignmentWithCentrisInfo:(NSDictionary *)assignmentInfo
					  inManagedObjectContext:(NSManagedObjectContext *)context;
@end
