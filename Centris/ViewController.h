//
//  ViewController.h
//  Centris
//
//  Created by Kristinn Svansson on 7/19/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
- (IBAction)showMenuPressed:(id)sender;
@end
