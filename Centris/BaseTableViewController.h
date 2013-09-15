//
//  BaseTableViewController.h
//  Centris
//
//  Created by Kristinn Svansson on 9/15/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
- (IBAction)showMenuPressed:(id)sender;
@end
