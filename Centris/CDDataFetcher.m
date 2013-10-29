//
//  CDDataFetcher.m
//  Centris
//
//  Created by Bjarki Sörens on 29/10/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CDDataFetcher.h"

@implementation CDDataFetcher

+ (NSMutableArray*)fetchObjectsFromDBWithEntity:(NSString*)entityName forKey:(NSString*)keyName sortAscending:(BOOL)ascending withPredicate:(NSPredicate*)predicate inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyName ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
	
    if (predicate != nil)
        [request setPredicate:predicate];
	
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"%@", error);
    }
    return mutableFetchResults;
}

@end
