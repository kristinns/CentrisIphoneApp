//
//  BaseViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 9/15/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "BaseViewController.h"
#import "MFSideMenuContainerViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

// Get menuContainer ( MFSlideMenuContainer )
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
// Action when clicked on menu button
- (IBAction)showMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end