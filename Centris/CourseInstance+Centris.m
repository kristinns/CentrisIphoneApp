//
//  CourseInstance+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 9/23/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstance+Centris.h"
#import "CDDataFetcher.h"

@implementation CourseInstance (Centris)

+(CourseInstance *)courseInstanceWithID:(NSInteger)courseID inManagedObjectContext:(NSManagedObjectContext *)context
{
	CourseInstance *instance = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %d", courseID];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"CourseInstance"
                                                            forKey:@"id"
                                                     sortAscending:NO
                                                     withPredicate:pred
                                            inManagedObjectContext:context];

    NSString *assertFailMessage = [NSString stringWithFormat:@"there should only be one courseinstance with cousreid: %d", courseID];
    NSAssert([matches count ] == 1, assertFailMessage);
    instance = [matches lastObject];
	
	return instance;
}

+ (CourseInstance *)courseInstanceWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    CourseInstance *courseInstance = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", centrisInfo[@"ID"]];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"CourseInstance"
                                                            forKey:@"id"
                                                     sortAscending:NO
                                                     withPredicate:pred
                                            inManagedObjectContext:context];
    
    if (![matches count]) { // no result, proceed with storing
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
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"CourseInstance"
                                                forKey:@"name"
                                         sortAscending:NO
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

@end
