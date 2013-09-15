//
//  ViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 7/19/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ViewController.h"
#import "MFSideMenuContainerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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
