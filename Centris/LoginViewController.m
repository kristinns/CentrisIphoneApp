//
//  LoginViewController.m
//  Centris
//
//  Created by Bjarki Sörens on 10/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "LoginViewController.h"
#import "DataFetcher.h"
#import "AppFactory.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) id<DataFetcher> dataFetcher;

@end

@implementation LoginViewController

#pragma mark - Getters
- (id<DataFetcher>)dataFetcher
{
    if(!_dataFetcher)
        _dataFetcher = [AppFactory getFetcherFromConfiguration];
    return _dataFetcher;
}

#pragma mark - Setup
// Not using any setup at this point.

#pragma mark - Handlers
- (IBAction)loginButtonPushed:(id)sender {
	NSString *email = self.emailInput.text;
	NSString *pass = self.passwordInput.text;
	NSDictionary *user = [self.dataFetcher getUserByEmail:email];
	if (user) { // found a user with given email
		NSLog(@"user found");
		
	} else {
		NSString *title = @"Notandi fannst ekki";
		NSString *message = @"Netfang eða lykilorð er vitlaust. Vinsamlegast reyndu aftur.";
		NSString *cancelButton = @"OK";
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
														message:message
													   delegate:nil
											  cancelButtonTitle:cancelButton
											  otherButtonTitles:nil];
		[alert show];
	}
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	
}

@end
