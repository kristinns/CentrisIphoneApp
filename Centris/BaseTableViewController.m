//
//  BaseTableViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 9/15/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MFSideMenuContainerViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

// Get menuContainer ( MFSlideMenuContainer )
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
// Action when clicked on menu button
- (IBAction)showMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
@end
