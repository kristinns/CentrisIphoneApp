//
//  AppFactory.m
//  Centris
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AppFactory.h"

@interface AppFactory ()

@end

@implementation AppFactory

+ (NSDictionary *)configuration
{
	return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
}

+ (id<DataFetcher>)getFetcherFromConfiguration
{
	NSString *className = [[self configuration] objectForKey:@"DataFetcher"];
	return (id<DataFetcher>)[NSClassFromString(className) class];
}

@end