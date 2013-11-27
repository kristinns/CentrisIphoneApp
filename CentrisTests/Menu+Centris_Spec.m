//
//  Menu+Centris_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 27/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Kiwi.h"
#import "Menu+Centris.h"
#import "NSDate+Helper.h"

SPEC_BEGIN(MenuCentrisSpec)

describe(@"Menu Category ", ^{
    __block NSManagedObjectContext *context = nil;
    beforeAll(^{
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil]; // nil makes it retrieve our main bundle
        NSError *error;
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        if (![coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
            NSLog(@"Could not init coordinator in Unit Tests");
        }
        
        if (coordinator != nil) {
            context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [context setPersistentStoreCoordinator:coordinator];
        } else {
            NSLog(@"Could not set coordinator in Unit Tests");
        }
        
        // Create some menus in the past
        Menu *customMenu = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
        customMenu.date = [NSDate convertToDate:@"2013-11-13T12:00:00" withFormat:nil];
        customMenu.menu = @"Hakkabuff í pítusósu";
        Menu *customMenu2 = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
        customMenu2.date = [NSDate convertToDate:@"2013-11-14T12:00:00" withFormat:nil];
        customMenu2.menu = @"Ristaðbrauð með smjöri og sultu";
        
        // create some menus for the current week
        NSDictionary *range = [NSDate dateRangeForTheWholeDay:[NSDate date]];
        Menu *currentWeekMenu = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
        currentWeekMenu.date = range[@"from"];
        currentWeekMenu.menu = @"Súrsætir hrútspungar";
        Menu *currentWeekMenu2 = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
        currentWeekMenu2.date = [(NSDate *)range[@"from"] dateByAddingDays:1];
        currentWeekMenu2.menu = @"Mexíkóskt salsa með mexíkó osti";
    });
    
    it(@"should be able to retrieve the menu for a given day", ^{
        Menu *menu = [Menu getMenuForDay:[NSDate convertToDate:@"2013-11-13T00:00:00" withFormat:nil] inManagedObjectContext:context];
        [[menu shouldNot] beNil];
    });
    
    it(@"should be able to get the menu for given week", ^{
        NSArray *checkMenus = [Menu getMenuForCurrentWeekInManagedObjectContext:context];
        [[theValue([checkMenus count]) should] equal:theValue(2)];
    });
    
    it(@"should be able to add menu items to core data", ^{
        NSDictionary *range = [NSDate dateRangeForTheWholeDay:[NSDate date]];
        NSMutableDictionary *monday = [[NSMutableDictionary alloc] init];
        [monday setObject:[NSDate convertToString:[(NSDate* )range[@"from"] dateByAddingDays:2] withFormat:nil] forKey:@"Date"];
        [monday setObject:@"Kjötbollur" forKey:@"Menu"];
        NSMutableDictionary *tuesday = [[NSMutableDictionary alloc] init];
        [tuesday setObject:[NSDate convertToString:[(NSDate *)range[@"from"] dateByAddingDays:3] withFormat:nil] forKey:@"Date"];
        [tuesday setObject:@"Fiskur" forKey:@"Menu"];
        [Menu addMenuWithCentrisInfo:@[monday, tuesday] inManagedObjectContext:context];
        NSArray *menu = [Menu getMenuForCurrentWeekInManagedObjectContext:context];
        [[theValue([menu count]) should] equal:theValue(4)];
    });
});

SPEC_END
