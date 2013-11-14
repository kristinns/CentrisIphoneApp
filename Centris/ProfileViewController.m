//
//  ProfileViewController.m
//  Centris
//
//  Created by Bjarki Sörens on 14/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

@end

@implementation ProfileViewController

#pragma mark - Setup

-(void)viewDidLoad
{
    [super viewDidLoad];
    // BUG IN IOS 7, TEMP FIX
    UIView *fixItView = [[UIView alloc] init];
    fixItView.frame = CGRectMake(0, 0, 320, 20);
    fixItView.backgroundColor = [CentrisTheme redColor]; //change this to match your navigation bar
    [self.view addSubview:fixItView];
    self.navBar.translucent = NO;
}

#pragma mark - Action sheet delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        id<ProfileViewControllerDelegate> appDelegate = (id<ProfileViewControllerDelegate>)[[UIApplication sharedApplication] delegate];
        [appDelegate didLogOutUser];
    }
}

#pragma mark - Outlet actions

- (IBAction)userDidDismissModalView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)userDidPressLogout:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Ertu viss um að þú viljir skrá þig út?"
                                                       delegate:self cancelButtonTitle:@"Hætta við"
                                         destructiveButtonTitle:@"Útskrá"
                                              otherButtonTitles:nil];
    [sheet showInView:self.view];
    
}

@end
