//
//  Menu+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 26/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Menu+Centris.h"
#import "CDDataFetcher.h"
#import "NSDate+Helper.h"
#import "DataFetcher.h"

@implementation Menu (Centris)
+ (Menu *)getMenuForDay:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date = %@", date];
    return [[CDDataFetcher fetchObjectsFromDBWithEntity:@"Menu"
                                                forKey:@"date"
                                         sortAscending:NO
                                         withPredicate:pred
                                inManagedObjectContext:context] lastObject];
}

+ (void)addMenuWithCentrisInfo:(NSArray *)menuInfoWeek inManagedObjectContext:(NSManagedObjectContext *)context;
{
    for (NSDictionary *menuDay in menuInfoWeek)
    {
        Menu *menu;
        // todo, check if menu for that day exists.
        menu = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
        menu.menu = menuDay[@"Menu"];
        menu.date = [NSDate convertToDate:menuDay[@"Date"] withFormat:nil];
    }
}
@end
