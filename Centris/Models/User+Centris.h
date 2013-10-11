//
//  User+Centris.h
//  Centris
//
//  Created by Kristinn Svansson on 9/4/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "User.h"

@interface User (Centris)
+ (User *)userWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context;
+ (User *)userWith:(NSString *)SSN inManagedObjectContext:(NSManagedObjectContext *)context;
+ (User *)userWithEmail:(NSString *)email inManagedObjectContext:(NSManagedObjectContext *)context;
@end
