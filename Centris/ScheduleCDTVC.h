//
//  ScheduleCDTVC.h
//  Centris
//
//  Created by Bjarki Sörens on 10/8/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface ScheduleCDTVC : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
