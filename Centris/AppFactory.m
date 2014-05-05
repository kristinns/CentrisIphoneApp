//
//  AppFactory.m
//  Centris
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AppFactory.h"

@implementation AppFactory

static KeychainItemWrapper *_sharedKeychainItemWrapper = nil;
static NSManagedObjectContext *_sharedManagedObjectContext = nil;
static id<DataFetcher> _sharedDataFetcher = nil;

+ (NSDictionary *)configuration
{
	return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
}

+ (id<DataFetcher>)dataFetcher
{
    if (!_sharedDataFetcher) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            NSString *className = [[self configuration] objectForKey:@"DataFetcher"];
            _sharedDataFetcher = (id<DataFetcher>)[NSClassFromString(className) class];
        });
    }
        return _sharedDataFetcher;
	
}

+ (KeychainItemWrapper *)keychainItemWrapper {
    if (!_sharedKeychainItemWrapper) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            _sharedKeychainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[self keychainFromConfiguration] accessGroup:nil];
        });
    }
    return _sharedKeychainItemWrapper;
}

+ (NSManagedObjectContext *)managedObjectContext {
    if (!_sharedManagedObjectContext) {
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
                _sharedManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
                [_sharedManagedObjectContext setPersistentStoreCoordinator:coordinator];
            } else {
                // Handle error
            }
        });
    }
    return _sharedManagedObjectContext;
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
