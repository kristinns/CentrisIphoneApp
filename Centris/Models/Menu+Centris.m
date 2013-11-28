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
    NSDictionary *range = [NSDate dateRangeForTheWholeDay:date];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@", range[@"from"], range[@"to"]];
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
        
        Menu *menu = [self getMenuForDay:[NSDate convertToDate:menuDay[@"Date"] withFormat:nil] inManagedObjectContext:context];
        if (!menu) { // doesn't exist, create one
            menu = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
            menu.menu = menuDay[@"Menu"];
            menu.date = [NSDate convertToDate:menuDay[@"Date"] withFormat:nil];
        } else { // update it's Menu
            menu.menu = menuDay[@"Menu"];
        }
    }
}

+ (NSArray *)getMenuForCurrentWeekInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currComps = [NSDate dateComponentForDate:[NSDate date] withCalendar:gregorian];
    NSDateComponents *customComps = [[NSDateComponents alloc] init];
    [customComps setWeekday:1];
    [customComps setYear:[currComps year]];
    [customComps setWeek:[currComps week]];
    NSDate *dateFrom = [gregorian dateFromComponents:customComps];
    [customComps setWeekday:7];
    [customComps setHour:23];
    [customComps setMinute:59];
    [customComps setSecond:59];
    NSDate *dateTo = [gregorian dateFromComponents:customComps];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@", dateFrom, dateTo];
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"Menu" forKey:@"date" sortAscending:NO withPredicate:pred inManagedObjectContext:context];
}
@end
