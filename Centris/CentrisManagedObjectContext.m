//
//  CentrisManagedObjectContext.m
//  Centris
//
//  Created by Kristinn Svansson on 9/25/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CentrisManagedObjectContext.h"

@interface CentrisManagedObjectContext()
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSString *applicationDocumentsDirectory;
@end

@implementation CentrisManagedObjectContext

static CentrisManagedObjectContext *sharedInstance = nil;

+ (CentrisManagedObjectContext *)sharedInstance {
    if (!sharedInstance) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            sharedInstance = [[CentrisManagedObjectContext alloc] init];
        });
    }

    return sharedInstance;
}

- (NSManagedObjectContext *) managedObjectContext {
	
    if (!_managedObjectContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator: coordinator];
        }
    }
	
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	
    if (!_managedObjectModel)
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (!_persistentStoreCoordinator) {
        NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Database.sqlite"]];
        
        NSError *error;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
            // Handle the error.
        }
    }
	
    
	
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
