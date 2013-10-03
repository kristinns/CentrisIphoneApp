//
//  User+Centris.h
//  Centris
//
//  Created by Kristinn Svansson on 9/4/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "User.h"

@interface User (Centris)

+ (User *)userWithCentrisInfo:(NSDictionary *)centrisInfo;

+ (User *)userWith:(NSString *)SSN inManagedObjectContext:(NSManagedObjectContext *)context;
@end
