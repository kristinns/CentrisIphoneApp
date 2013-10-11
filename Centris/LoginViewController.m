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
#import "KeychainItemWrapper.h"
#import "User+Centris.h"
#import "CentrisManagedObjectContext.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) id<DataFetcher> dataFetcher;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation LoginViewController

#pragma mark - Getters
- (id<DataFetcher>)dataFetcher
{
    if(!_dataFetcher)
        _dataFetcher = [AppFactory getFetcherFromConfiguration];
    return _dataFetcher;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if(!_managedObjectContext)
        _managedObjectContext = [[CentrisManagedObjectContext sharedInstance] managedObjectContext];
    
    return _managedObjectContext;
}

#pragma mark - Setup
// Not using any setup at this point.

#pragma mark - Handlers
- (IBAction)loginButtonPushed:(id)sender {
	NSString *email = self.emailInput.text;
	NSString *pass = self.passwordInput.text;
	// FETCH REQUEST SENDING.
	// TODO:
	//	   - CHECK IF PASSWORD IS CORRECT
	//     - DISPATCH THREAD
	//     - SHOW NETWORK INDICATOR
	//     - SHOW LOADING WHEEL
	NSDictionary *userInfo = [self.dataFetcher getUserByEmail:email]; // this really should be post to API to login
	
	if (userInfo) { // found a user with given email
		NSLog(@"user found from API");
		// store info in keychain
		KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"CentrisLogin" accessGroup:nil];
		[keychainItem setObject:email forKey:(__bridge id)(kSecAttrAccount)];
		[keychainItem setObject:pass forKey:(__bridge id)(kSecValueData)];
		
		// test to see if it was stored
//		NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
//		NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
//		NSLog(@"FROM KEYCHAIN: %@, %@", username, password);
		
		// store user in Core Data
//		[User userWithCentrisInfo:userInfo inManagedObjectContext:[self.managedObjectContext]];
		
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
