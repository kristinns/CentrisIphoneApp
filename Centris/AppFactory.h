//
//  AppFactory.h
//  Centris
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataFetcher.h"
#import "KeychainItemWrapper.h"

@interface AppFactory : NSObject

+ (id<DataFetcher>)fetcherFromConfiguration;
+ (KeychainItemWrapper *)keychainItemWrapper;
+ (NSManagedObjectContext *)managedObjectContext;
+ (NSUserDefaults *)sharedDefaults;
+ (UIStoryboard *)mainStoryboard;
@end
