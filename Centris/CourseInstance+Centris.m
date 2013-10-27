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
        NSLog(@"Error: %@", [error userInfo]);
    }
    
    instance = [matches lastObject];
	
	return instance;
}

+ (CourseInstance *)courseInstanceWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    CourseInstance *courseInstance = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CourseInstance"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", centrisInfo[@"ID"]];
    
    // Execute the fetch
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) { // error
		NSLog(@"Error: %@", [error userInfo]);
	} else if (![matches count]) { // no result, proceed with storing
        courseInstance = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance" inManagedObjectContext:context];
        courseInstance.id = centrisInfo[@"ID"];
        courseInstance.courseID = centrisInfo[@"CourseID"];
        courseInstance.name = centrisInfo[@"Name"];
        courseInstance.semester = centrisInfo[@"Semester"];
    } else {
        return [matches lastObject];
    }
    return courseInstance;
}

@end
