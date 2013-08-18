//
//  ScheduleEvent.h
//  Centris
//
//  Created by Kristinn Svansson on 8/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleEvent : NSObject

@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;

@end
