//
//  ScheduleViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 8/4/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleViewController.h"
#import "MFSideMenuContainerViewController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

// This is for MFSideMenuContainerViewController
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}

- (IBAction)showMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
