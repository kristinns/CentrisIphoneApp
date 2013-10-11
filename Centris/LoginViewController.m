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
@property (nonatomic, weak) IBOutlet UITextField *emailInput;
@property (nonatomic, weak) IBOutlet UITextField *passwordInput;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

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
		User *user = [User userWithCentrisInfo:userInfo inManagedObjectContext:self.managedObjectContext];
		if (user) {
			// do segue
			NSLog(@"doing the segue");
			[self performSegueWithIdentifier:@"userLogin" sender:self];
		} else {
			[self promptUserWithMessage:@"Æj! Eitthvað fór úrskeiðis þannig ekki náðist að skrá þig inn. Vinsamlegast reyndu aftur."
								  title:@"Innskráning mistókst"
					  cancelButtonTitle:@"OK"];
		}
		
	} else {
		[self promptUserWithMessage:@"Netfang eða lykilorð er vitlaust. Vinsamlegast reyndu aftur."
							  title:@"Notandi fannst ekki"
				  cancelButtonTitle:@"OK"];
	}
}

- (void)promptUserWithMessage:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle:cancelButtonTitle
										  otherButtonTitles:nil];
	[alert show];

}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"userLogin"]) {
//		if ([segue.destinationViewController respondsToSelector:@selector(userLogin)]) {
//			[segue.destinationViewController performSelector@selector(userLogin)];
//		}
		if ([segue.destinationViewController respondsToSelector:@selector(userLogin)]) {
			[segue.destinationViewController performSelector:@selector(userLogin) withObject:nil];
		}
	}
}

@end
