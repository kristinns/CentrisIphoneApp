//
//  Menu+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 26/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Menu.h"

@interface Menu (Centris)
+ (void)addMenuWithCentrisInfo:(NSArray *)menuInfoWeek inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Menu *)getMenuForDay:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getMenuForCurrentWeekInManagedObjectContext:(NSManagedObjectContext *)context;
@end
