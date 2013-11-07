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
+ (User *)userWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"ssn = %@", [centrisInfo[@"Person.SSN"] stringValue]];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"User" forKey:@"name" sortAscending:NO withPredicate:pred inManagedObjectContext:context];
    
    if (![matches count]) { // Noone found, let's create a User from CentrisInfo
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.name = [[centrisInfo valueForKeyPath:USER_FULL_NAME] description];
        user.ssn = [[centrisInfo valueForKeyPath:USER_SSN] description];
        user.address = [[centrisInfo valueForKeyPath:USER_ADDRESS] description];
        user.email = [[centrisInfo valueForKeyPath:USER_EMAIL] description];
		
		user.finishedECTS = [centrisInfo valueForKeyPath:USER_ECTS_FINISHED];
		user.activeECTS = [centrisInfo valueForKeyPath:USER_ECTS_ACTIVE];
		user.averageGrade = [centrisInfo valueForKeyPath:USER_AVERAGE_GRADE];
		
		user.department = [centrisInfo valueForKeyPath:USER_DEPARTMENT_NAME];
		user.majorIS = [centrisInfo valueForKeyPath:USER_MAJOR_IS];
		user.majorEN = [centrisInfo valueForKeyPath:USER_MAJOR_EN];
		user.majorCredits = [centrisInfo valueForKeyPath:USER_MAJOR_CREDITS];
		
		user.type = [centrisInfo valueForKeyPath:USER_TYPE];
		
    } else { // Found
        // Just return that User
        user = [matches lastObject];
    }
    return user;
}

+ (User *)userWithEmail:(NSString *)email inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"email = %@", email];
    
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"User" forKey:@"name" sortAscending:YES withPredicate:pred inManagedObjectContext:context];
    //NSAssert([matches count] == 1, @"Should only return one user");
    return [matches lastObject];
}


@end
