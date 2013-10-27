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
#import <HTProgressHUD/HTProgressHUD.h>
#import "HTProgressHUDFadeZoomAnimation.h"
#import "HTProgressHUDIndicatorView.h"

@interface LoginViewController ()
@property (nonatomic, weak) IBOutlet UITextField *emailInput;
@property (nonatomic, weak) IBOutlet UITextField *passwordInput;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) HTProgressHUD *HUD;
@end

@implementation LoginViewController

#pragma mark - Getters
- (id<DataFetcher>)dataFetcher
{
    if(!_dataFetcher)
        _dataFetcher = [AppFactory fetcherFromConfiguration];
    return _dataFetcher;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if(!_managedObjectContext)
        _managedObjectContext = [[CentrisManagedObjectContext sharedInstance] managedObjectContext];
    
    return _managedObjectContext;
}

// Lazy instantiate
- (HTProgressHUD *)HUD
{
    if (!_HUD)
        _HUD = [[HTProgressHUD alloc] init];
    return _HUD;
}

#pragma mark - Setup
// Not using any setup at this point.

#pragma mark - UI Handlers
- (IBAction)loginButtonPushed:(id)sender {
	NSString *email = self.emailInput.text;
	NSString *pass = self.passwordInput.text;
	// FETCH REQUEST SENDING.
	// TODO:
	//	   - CHECK IF PASSWORD IS CORRECT
	//     - DISPATCH THREAD
	//     - SHOW NETWORK INDICATOR
	//     - SHOW LOADING WHEEL
    
    [self displayHUDWithText:@"Skrái þig inn"];
    dispatch_queue_t workQ = dispatch_queue_create("Centris fetch", NULL);
    dispatch_async(workQ, ^{
        NSDictionary *userInfo = [self.dataFetcher loginUserWithEmail:email andPassword:pass]; // this really should be post to API to login
        if (userInfo) { // found a user with given email
            // store info in keychain
            [self storeInKeychainEmail:email andPassword:pass];
            // store user in Core Data
            User *user = [User userWithCentrisInfo:userInfo inManagedObjectContext:self.managedObjectContext];
            if (user) {
                [self updateHUDWithText:@"Sæki notandaupplýsingar"];
                sleep(3);
                [self updateHUDWithText:@"Sæki áfanga"];
                sleep(3);
                dispatch_async(dispatch_get_main_queue(), ^{ // And finally
                    [self hideHUD];
                    // and finish by delegate that we want to go inside (TWSS)
                    [self delegateFinishedLoggingInWithValidUser];
                });
            } else { // ERROR, this really should not happen unless there is something wrong with core data.
                [self promptUserWithMessage:@"Vúps! Eitthvað fór úrskeiðis þannig ekki náðist að skrá þig inn. Vinsamlegast reyndu aftur."
                                      title:@"Innskráning mistókst"
                          cancelButtonTitle:@"OK"];
                [self hideHUD];
            }
        } else { // ERROR
            [self promptUserWithMessage:@"Netfang eða lykilorð er vitlaust. Vinsamlegast reyndu aftur."
                                  title:@"Notandi fannst ekki"
                      cancelButtonTitle:@"OK"];
            [self hideHUD];
        }
    });
}

#pragma mark - Data methods

#pragma mark - Helper methods

-(void)delegateFinishedLoggingInWithValidUser
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate didFinishLoginWithValidUser];
    });
}

- (void)displayHUDWithText:(NSString *)text
{
    self.HUD.text = text;
    [self.HUD showInView:self.view animated:YES];
}

- (void)updateHUDWithText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.HUD.text = text;
    });
}

- (void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD hideWithAnimation:YES];
    });
}

- (void)storeInKeychainEmail:(NSString *)email andPassword:(NSString *)password
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:[AppFactory keychainFromConfiguration] accessGroup:nil];
    [keychainItem setObject:email forKey:(__bridge id)(kSecAttrAccount)];
    [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
}

- (void)promptUserWithMessage:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];
        [alert show];
    });

}

@end
