//
//  ScheduleEventUnit.h
//  Centris
//
//  Created by Bjarki Sörens on 17/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ScheduleEvent;

@interface ScheduleEventUnit : NSManagedObject

@property (nonatomic, retain) NSDate * ends;
@property (nonatomic, retain) NSDate * starts;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) ScheduleEvent *isAUnitOf;

@end
