//
//  User+Centris.m
//  Centris
//
//  Created by Kristinn Svansson on 9/4/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "User+Centris.h"
#import "CentrisManagedObjectContext.h"

@implementation User (Centris)
// Get User from Dictionary and store in context if it's not already in it
+ (User *)userWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    // Create fetch request
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"ssn = %@", [centrisInfo[@"Person.SSN"] stringValue]];
    
    // Execute query on Core Data
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // Check results
    if (!matches) { // nil means fetch failed
        // Handle error
		NSLog(@"Error: %@", error);
    } else if (![matches count]) { // Noone found, let's create a User from CentrisInfo
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
	// Create fetch request
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    // Get only user with ssn
	request.predicate = [NSPredicate predicateWithFormat:@"ssn = %@", SSN];
	
	// Execute the fetch on context
	NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches) {
		// Handle error
		NSLog(@"Error: %@", [error userInfo]);
	} else if (![matches count]) { // Nothing found
		NSLog(@"Nothing found here");
	} else { // Found user, return him
		user = [matches lastObject];
	}
	return user;
}

+ (User *)userWithEmail:(NSString *)email inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"email = %@", email];
	return [self fetchFromDatabaseWithEntity:@"User" predicate:pred inManagedObjectContext:context];
}

+(User *)fetchFromDatabaseWithEntity:(NSString *)entity predicate:(NSPredicate *)predicate inManagedObjectContext:context
{
	// Create fetch request
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
	request.predicate = predicate;
	
	// Execute fetch
	NSError *error = nil;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches) {
		NSLog(@"Error: %@", [error userInfo]);
		return nil;
	} else {
		return [matches lastObject];
	}
}


@end
