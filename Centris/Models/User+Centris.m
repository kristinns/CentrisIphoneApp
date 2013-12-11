//
//  User+Centris.m
//  Centris
//
//  Created by Kristinn Svansson on 9/4/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "User+Centris.h"
#import "CDDataFetcher.h"
#import "DataFetcher.h"

@implementation User (Centris)

// Get User from Dictionary and store in context if it's not already in it
+ (User *)addUserWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"ssn = %@", [centrisInfo[CENTRIS_USER_SSN] description]];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"User" forKey:@"name" sortAscending:NO withPredicate:pred inManagedObjectContext:context];
    
    if (![matches count]) { // Noone found, let's create a User from CentrisInfo
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.name = [[centrisInfo valueForKeyPath:CENTRIS_USER_FULL_NAME] description];
        user.ssn = [[centrisInfo valueForKeyPath:CENTRIS_USER_SSN] description];
        user.address = [[centrisInfo valueForKeyPath:CENTRIS_USER_ADDRESS] description];
        user.username = [[centrisInfo valueForKeyPath:CENTRIS_USER_USERNAME] description];
		
		user.finishedECTS = [centrisInfo valueForKeyPath:CENTRIS_USER_ECTS_FINISHED];
		user.activeECTS = [centrisInfo valueForKeyPath:CENTRIS_USER_ECTS_ACTIVE];
		user.averageGrade = [centrisInfo valueForKeyPath:CENTRIS_USER_AVERAGE_GRADE];
		
		user.department = [centrisInfo valueForKeyPath:CENTRIS_USER_DEPARTMENT_NAME];
		user.majorIS = [centrisInfo valueForKeyPath:CENTRIS_USER_MAJOR_IS];
		user.majorEN = [centrisInfo valueForKeyPath:CENTRIS_USER_MAJOR_EN];
		user.majorCredits = [centrisInfo valueForKeyPath:CENTRIS_USER_MAJOR_CREDITS];
		
		user.type = [centrisInfo valueForKeyPath:CENTRIS_USER_TYPE];
		
    } else { // Found
        // Just return that User
        user = [matches lastObject];
    }
    return user;
}

+ (User *)userWithUsername:(NSString *)username inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"username = %@", username];
    
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"User" forKey:@"name" sortAscending:YES withPredicate:pred inManagedObjectContext:context];
    //NSAssert([matches count] == 1, @"Should only return one user");
    return [matches lastObject];
}


@end
