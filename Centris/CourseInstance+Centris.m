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
    
    request.predicate = [NSPredicate predicateWithFormat:@"id = %d", courseID];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) { // error
        NSLog(@"Error: %@", [error userInfo]);
    } else {
        instance = [matches lastObject];
    }
	
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

+ (NSArray *)courseInstancesInManagedObjectContext:(NSManagedObjectContext *)context;
{
    return [self fetchEventsFromDBWithEntity:@"CourseInstance"
                                      forKey:@"name"
                               withPredicate:nil
                      inManagedObjectContext:context];
}

#pragma mark - Helpers
+ (NSMutableArray*)fetchEventsFromDBWithEntity:(NSString*)entityName forKey:(NSString*)keyName withPredicate:(NSPredicate*)predicate inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyName ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
	
    if (predicate != nil)
        [request setPredicate:predicate];
	
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"%@", error);
    }
    return mutableFetchResults;
}

@end
