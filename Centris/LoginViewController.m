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
#import "CourseInstance+Centris.h"
#import "ScheduleEvent+Centris.h"
#import "Assignment+Centris.h"
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
- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - UI Handlers
- (IBAction)loginButtonPushed:(id)sender {
	NSString *email = self.emailInput.text;
	NSString *pass = self.passwordInput.text;
    
    [self displayHUDWithText:@"Skrái þig inn"];
    dispatch_queue_t workQ = dispatch_queue_create("Centris fetch", NULL);
    dispatch_async(workQ, ^{
        [self updateHUDWithText:@"Sæki notandaupplýsingar"];
        sleep(3);
        User *user = [self doUserLoginWithEmail:email andPassword:pass];
        if (user) {
            [self updateHUDWithText:@"Sæki áfanga"];
            sleep(3);
            [self fetchCourseInstancesForUserWithSSN:user.ssn];
            
            [self updateHUDWithText:@"Sæki stundatöflu"];
            sleep(3);
            [self fetchScheduleForUserWithSSN:user.ssn];
            
            [self updateHUDWithText:@"Sæki verkefni"];
            sleep(3);
            [self fetchAssignmentsForUserWithSSN:user.ssn];
            
            dispatch_async(dispatch_get_main_queue(), ^{ // And finally
                [self hideHUD];
                // and finish by delegate that we want to go inside (TWSS)
                [self delegateFinishedLoggingInWithValidUser];
            });
        } else {
            [self promptUserWithMessage:@"Netfang eða lykilorð er vitlaust. Vinsamlegast reyndu aftur."
                                  title:@"Notandi fannst ekki"
                      cancelButtonTitle:@"OK"];
            [self hideHUD];
        }
    });
}

#pragma mark - Selectors & Delegates

-(void)keyboardWillShow:(NSNotification *)notification {
    // Get the size of the keyboard
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES byAmount:keyboardSize];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO byAmount:keyboardSize];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES byAmount:keyboardSize];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO byAmount:keyboardSize];
    }
}

#pragma mark - Keyboard tweaks

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp byAmount:(CGSize)sizeOfKeyboard
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= (sizeOfKeyboard.height / 2);
        rect.size.height += (sizeOfKeyboard.height / 2);
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += (sizeOfKeyboard.height / 2);
        rect.size.height -= (sizeOfKeyboard.height / 2);
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

#pragma mark - Data methods

// Authenticates user to API and stores him in Core Data. Returns a
- (User *)doUserLoginWithEmail:(NSString *)email andPassword:(NSString *)password
{
    User *user = nil;
    NSDictionary *userInfo = [self.dataFetcher loginUserWithEmail:email andPassword:password];
    if (userInfo) {
        [self storeInKeychainEmail:email andPassword:password];
        user = [User userWithCentrisInfo:userInfo inManagedObjectContext:self.managedObjectContext];
    }
    return user;
}

// Will make a fetch request to the API for a given SSN and store the results (if any)
// in Core Data
- (void)fetchCourseInstancesForUserWithSSN:(NSString *)SSN
{
    NSArray *courseInstances = [self.dataFetcher getCoursesForStudentWithSSN:SSN];
    for (NSDictionary *courseInst in courseInstances) {
        [CourseInstance courseInstanceWithCentrisInfo:courseInst inManagedObjectContext:self.managedObjectContext];
    }
}

- (void)fetchScheduleForUserWithSSN:(NSString *)SSN
{
    NSArray *schedule = [self.dataFetcher getScheduleBySSN:SSN];
    for (NSDictionary *event in schedule) {
        [ScheduleEvent addScheduleEventWithCentrisInfo:event inManagedObjectContext:self.managedObjectContext];
    }
}

- (void)fetchAssignmentsForUserWithSSN:(NSString *)SSN
{
    // Get all courseInstances from Core Data
    NSArray *courseInstances = [CourseInstance courseInstancesInManagedObjectContext:self.managedObjectContext];
    for (CourseInstance *inst in courseInstances) {
        NSArray *assignments = [self.dataFetcher getAssignmentsForCourseWithCourseID:inst.courseID inSemester:inst.semester];
        for (NSDictionary *assignment in assignments) {
            [Assignment addAssignmentWithCentrisInfo:assignment withCourseInstanceID:[inst.id intValue] inManagedObjectContext:self.managedObjectContext];
        }

    }
}

#pragma mark - Helper methods

- (void)delegateFinishedLoggingInWithValidUser
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
