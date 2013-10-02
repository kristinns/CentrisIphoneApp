//
//  CourseInstance+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 9/23/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstance+Centris.h"

@implementation CourseInstance (Centris)

+(CourseInstance *)courseInstanceWithID:(NSInteger)courseID inManagedObjectContext:(NSManagedObjectContext *)context
{
	CourseInstance *instance = nil;
	
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CourseInstance"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", courseID];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) { // error
        NSLog(@"%@", [error userInfo]);
    }
    
    instance = [matches lastObject];
	
	return instance;
}

@end
