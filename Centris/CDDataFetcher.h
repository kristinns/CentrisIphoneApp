//
//  CDDataFetcher.h
//  Centris
//
//  Created by Bjarki Sörens on 29/10/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDDataFetcher : NSObject
+ (NSMutableArray*)fetchObjectsFromDBWithEntity:(NSString*)entityName forKey:(NSString*)keyName withPredicate:(NSPredicate*)predicate inManagedObjectContext:(NSManagedObjectContext *)context;
@end
