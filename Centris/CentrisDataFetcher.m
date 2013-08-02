//
//  CentrisDataFetcher.m
//  Centris
//
//  Created by Kristinn Svansson on 8/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CentrisDataFetcher.h"

@implementation CentrisDataFetcher

+ (NSArray *)getAssignments
{
    /* Fake data */
    NSMutableArray *assignments = [[NSMutableArray alloc] init];
    for(NSInteger i=1; i< 10; i++) {
        NSString *title = [@"Assignment " stringByAppendingString:[NSString stringWithFormat: @"%d", i]];
        NSString *finished = i == 1 || i == 3 ? @"yes" : @"no";
        NSDictionary *assignment = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", @"24/3/2012", @"date", finished, @"finished", nil];
        [assignments addObject:assignment];
    }

    return assignments;
}

@end
