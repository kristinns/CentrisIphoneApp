//
//  User+Centris.m
//  Centris
//
//  Created by Kristinn Svansson on 9/4/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "User+Centris.h"

@implementation User (Centris)

+ (User *)userWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    // Check to see if user does exist
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
															  ascending:YES
															   selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"ssn = %@", [centrisInfo[@"Person.SSN"] description]];
    
    //execute the fetch
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    //check what happened to the fetch
    
    if (!matches || ([matches count] > 1 )) { //nil means fetch failed; count > 1 means more than one
        // handle error
		NSLog(@"Error from userWithCentrisInfo");
    } else if (![matches count]) {// noone found, let's create a User from CentrisInfo
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.name = [[centrisInfo valueForKeyPath:@"Person.Name"] description];
        user.ssn = [[centrisInfo valueForKeyPath:@"Person.SSN"] description];
        user.address = [[centrisInfo valueForKeyPath:@"Person.Address"] description];
        user.email = [[centrisInfo valueForKeyPath:@"Person.Email"] description];
    } else {
        // just return that User
        user = [matches lastObject];
    }
    return user;
}

+(User *)userWith:(NSString *)SSN inManagedObjectContext:(NSManagedObjectContext *)context
{
	User *user = nil;
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
															  ascending:YES
															   selector:@selector(localizedCaseInsensitiveCompare:)]];
	request.predicate = [NSPredicate predicateWithFormat:@"ssn = %@", SSN];
	
	// execute the fetch
	NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches) {
		//handle error
		NSLog(@"Error from userWith");
		NSLog(@"%@", [error userInfo]);
	} else if (![matches count]){ // nothing found
		NSLog(@"Nothing found");
	} else {
		user = [matches lastObject];
	}
	return user;
}

@end
