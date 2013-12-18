//
//  Menu+Centris_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 27/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Menu+Centris.h"
#import "NSDate+Helper.h"

SPEC_BEGIN(MenuCentrisSpec)

describe(@"Menu Category ", ^{
    __block NSManagedObjectContext *context = nil;
    __block NSDateComponents *customComps = nil;
    __block NSCalendar *gregorian = nil;
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
        
        // Create some dates so the menus will always be on monday - friday
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *currComps = [[NSDate date] dateComponentForDateWithCalendar:gregorian];
        customComps = [[NSDateComponents alloc] init];
        [customComps setWeekday:4];
        [customComps setYear:[currComps year]];
        [customComps setWeek:[currComps week]];
        NSDate *wednesday = [gregorian dateFromComponents:customComps];
        [customComps setWeekday:5];
        NSDate *thursday = [gregorian dateFromComponents:customComps];
        
        // Create some menus in the past
        Menu *customMenu = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
        customMenu.date = [NSDate dateFromString:@"2013-11-13T12:00:00" withFormat:nil];
        customMenu.menu = @"Hakkabuff í pítusósu";
        Menu *customMenu2 = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
        customMenu2.date = [NSDate dateFromString:@"2013-11-14T12:00:00" withFormat:nil];
        customMenu2.menu = @"Ristaðbrauð með smjöri og sultu";
        
        // create some menus for the current week
        Menu *currentWeekMenu = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
        currentWeekMenu.date = wednesday;
        currentWeekMenu.menu = @"Súrsætir hrútspungar";
        Menu *currentWeekMenu2 = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
        currentWeekMenu2.date = thursday;
        currentWeekMenu2.menu = @"Mexíkóskt salsa með mexíkó osti";
    });
    
    it(@"should be able to retrieve the menu for a given day", ^{
        Menu *menu = [Menu getMenuForDay:[NSDate dateFromString:@"2013-11-13T00:00:00" withFormat:nil] inManagedObjectContext:context];
        [[menu shouldNot] beNil];
    });
    
    it(@"should be able to get the menu for given week", ^{
        NSArray *checkMenus = [Menu getMenuForCurrentWeekInManagedObjectContext:context];
        [[theValue([checkMenus count]) should] equal:theValue(2)];
    });
    
    it(@"should be able to add menu items to core data", ^{
        NSMutableDictionary *mondayDic = [[NSMutableDictionary alloc] init];
        [customComps setWeekday:2]; // monday
        NSDate *monday = [gregorian dateFromComponents:customComps];
        [mondayDic setObject:[monday stringFromDateWithFormat:nil] forKey:@"Date"];
        [mondayDic setObject:@"Kjötbollur" forKey:@"Menu"];
        
        NSMutableDictionary *tuesdayDic = [[NSMutableDictionary alloc] init];
        [customComps setWeekday:3]; // tuesday
        NSDate *tuesday = [gregorian dateFromComponents:customComps];
        [tuesdayDic setObject:[tuesday stringFromDateWithFormat:nil] forKey:@"Date"];
        [tuesdayDic setObject:@"Fiskur" forKey:@"Menu"];
        
        [Menu addMenuWithCentrisInfo:@[mondayDic, tuesdayDic] inManagedObjectContext:context];
        NSArray *menu = [Menu getMenuForCurrentWeekInManagedObjectContext:context];
        [[theValue([menu count]) should] equal:theValue(4)];
    });
    
    it(@"should not be able to duplicate menu item for the same day", ^{
        NSDictionary *range = [[NSDate date] dateRangeForTheWholeDay];
        NSMutableDictionary *customMenu = [[NSMutableDictionary alloc] init];
        [customMenu setObject:[range[@"from"] stringFromDateWithFormat:nil] forKey:@"Date"];
        [customMenu setObject:@"Leppalúða" forKey:@"Menu"];
        [Menu addMenuWithCentrisInfo:@[customMenu] inManagedObjectContext:context];
        NSArray *menu = [Menu getMenuForCurrentWeekInManagedObjectContext:context];
        [[theValue([menu count]) should] equal:theValue(4)];
    });
});

SPEC_END
