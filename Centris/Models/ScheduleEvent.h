//
//  ScheduleEvent.h
//  Centris
//
//  Created by Kristinn Svansson on 8/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"

@interface ScheduleEvent : NSObject

@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
@property (strong, nonatomic) Course *course;

@end
