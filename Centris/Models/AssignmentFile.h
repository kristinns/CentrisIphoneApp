//
//  AssignmentFile.h
//  Centris
//
//  Created by Bjarki Sörens on 18/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assignment;

@interface AssignmentFile : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Assignment *isInAssignment;

@end
