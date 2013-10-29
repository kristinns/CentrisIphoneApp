//
//  User+Centris.m
//  Centris
//
//  Created by Kristinn Svansson on 9/4/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "User+Centris.h"
#import "CentrisManagedObjectContext.h"
#import "CDDataFetcher.h"

@implementation User (Centris)

// Get User from Dictionary and store in context if it's not already in it
+ (User *)userWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"ssn = %@", [centrisInfo[@"Person.SSN"] stringValue]];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"User" forKey:@"name" sortAscending:NO withPredicate:pred inManagedObjectContext:context];
    
    if (![matches count]) { // Noone found, let's create a User from CentrisInfo
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.name = [[centrisInfo valueForKeyPath:@"Person.Name"] description];
        user.ssn = [[centrisInfo valueForKeyPath:@"Person.SSN"] description];
        user.address = [[centrisInfo valueForKeyPath:@"Person.Address"] description];
        user.email = [[centrisInfo valueForKeyPath:@"Person.Email"] description];
		
		user.finishedECTS = [centrisInfo valueForKeyPath:@"Registration.StudentRegistration.ECTSFinished"];
		user.activeECTS = [centrisInfo valueForKeyPath:@"Registration.StudentRegistration.ECTSActive"];
		user.averageGrade = [centrisInfo valueForKeyPath:@"Registration.StudentRegistration.AverageGrade"];
		
		user.department = [centrisInfo valueForKeyPath:@"Registration.DepartmentName"];
		user.majorIS = [centrisInfo valueForKeyPath:@"Registration.Major.Name"];
		user.majorEN = [centrisInfo valueForKeyPath:@"Registrationn.Major.NameEnglish"];
		user.majorCredits = [centrisInfo valueForKeyPath:@"Registration.Major.Credits"];
		
		user.type = [centrisInfo valueForKeyPath:@"Registraton.StudentTypeName"];
		
    } else { // Found
        // Just return that User
        user = [matches lastObject];
    }
    return user;
}

// Get User with ssn from context
+(User *)userWith:(NSString *)SSN inManagedObjectContext:(NSManagedObjectContext *)context
{
	User *user = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"ssn = %@", SSN];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"User" forKey:@"name" sortAscending:NO withPredicate:pred inManagedObjectContext:context];
    user = [matches lastObject];
    
	return user;
}

+ (User *)userWithEmail:(NSString *)email inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"email = %@", email];
    
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"User" forKey:@"name" sortAscending:YES withPredicate:pred inManagedObjectContext:context];
    NSAssert([matches count] == 1, @"Should only return one user");
    return [matches lastObject];
}


@end
