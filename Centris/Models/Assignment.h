//
//  Assignment.h
//  Centris
//
//  Created by Kristinn Svansson on 8/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"

@interface Assignment : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *deadline;
@property (strong, nonatomic) NSDate *submitted; // If not submitted, this should point to NULL
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) Course *course;

@end
