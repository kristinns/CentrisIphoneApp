//
//  AppFactory.m
//  Centris
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AppFactory.h"

@implementation AppFactory

static KeychainItemWrapper *sharedKeychainItemWrapper = nil;
static NSManagedObjectContext *sharedManagedObjectContext = nil;

+ (NSDictionary *)configuration
{
	return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
}

+ (id<DataFetcher>)fetcherFromConfiguration
{
	NSString *className = [[self configuration] objectForKey:@"DataFetcher"];
	return (id<DataFetcher>)[NSClassFromString(className) class];
}

+ (KeychainItemWrapper *)keychainItemWrapper {
    if (!sharedKeychainItemWrapper) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            sharedKeychainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[self keychainFromConfiguration] accessGroup:nil];
        });
    }
    return sharedKeychainItemWrapper;
}

+ (NSManagedObjectContext *)managedObjectContext {
    if (!sharedManagedObjectContext) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            // Get application document directory
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *applicationDocumentsDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
            NSURL *storeUrl = [NSURL fileURLWithPath: [applicationDocumentsDirectory stringByAppendingPathComponent: @"Database.sqlite"]];
            
            // Object model
            NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
            
            NSError *error;
            NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
            
            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                     [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
            
            if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
                // Handle the error.
            }

            if (coordinator != nil) {
                sharedManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
                [sharedManagedObjectContext setPersistentStoreCoordinator:coordinator];
            } else {
                // Handle error
            }
        });
    }
    return sharedManagedObjectContext;
}

+ (NSString *)keychainFromConfiguration
{
	return [[self configuration] objectForKey:@"KeychainFile"];
}

+ (NSUserDefaults *)sharedDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

+ (UIStoryboard *)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
}

@end
