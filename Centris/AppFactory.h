//
//  AppFactory.h
//  Centris
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DataFetcher.h"

@interface AppFactory : NSObject

+ (id<DataFetcher>)getFetcherFromConfiguration;

@end
