//
//  CentrisManagedObjectContext.h
//  Centris
//
//  Created by Kristinn Svansson on 9/25/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CentrisManagedObjectContext : NSObject
- (NSManagedObjectContext *) managedObjectContext;
+ (id)sharedInstance;
@end