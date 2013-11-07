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


+ (NSString *)keychainFromConfiguration
{
	return [[self configuration] objectForKey:@"KeychainFile"];
}

@end
