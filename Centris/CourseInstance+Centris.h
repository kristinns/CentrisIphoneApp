//
//  CourseInstance+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 9/23/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstance.h"

@interface CourseInstance (Centris)
+(CourseInstance *)courseInstanceWithID:(NSInteger)courseID
				 inManagedObjectContext:(NSManagedObjectContext *) context;
@end
