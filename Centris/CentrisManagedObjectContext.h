//
//  CentrisManagedObjectContext.h
//  Centris
//
//  Created by Kristinn Svansson on 9/25/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CentrisManagedObjectContext : NSManagedObjectContext
+ (NSManagedObjectContext *)sharedContext;
@end
