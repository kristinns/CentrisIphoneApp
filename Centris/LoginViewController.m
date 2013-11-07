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
#import "User+Centris.h"
#import "CourseInstance+Centris.h"
#import "ScheduleEvent+Centris.h"
#import "Assignment+Centris.h"
#import <HTProgressHUD/HTProgressHUD.h>
#import "HTProgressHUDFadeZoomAnimation.h"
#import "HTProgressHUDIndicatorView.h"

@interface LoginViewController ()
@property (nonatomic, weak) IBOutlet UITextField *emailInput;
@property (nonatomic, weak) IBOutlet UITextField *passwordInput;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) id<DataFetcher> dataFetcher;
@property (nonatomic, strong) HTProgressHUD *HUD;
@property (nonatomic) NSInteger threadCounter;
@end


@implementation LoginViewController

#pragma mark - Getters
- (id<DataFetcher>)dataFetcher
{
    if(!_dataFetcher)
        _dataFetcher = [AppFactory fetcherFromConfiguration];
    return _dataFetcher;
}

// Lazy instantiate
- (HTProgressHUD *)HUD
{
    if (!_HUD) {
        _HUD = [[HTProgressHUD alloc] init];
        _HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeRing];
        _HUD.animation = [HTProgressHUDFadeZoomAnimation animation];
    }
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
    [self.view endEditing:YES];
	NSString *email = self.emailInput.text;
	NSString *pass = self.passwordInput.text;
    
    [self displayHUDWithText:@"Skrái þig inn"];
    [self updateHUDWithText:@"Sæki notandaupplýsingar" addProgress:0.2];
    User *user = [self doUserLoginWithEmail:email andPassword:pass];
    if (user) {
        [self updateHUDWithText:@"Sæki áfanga" addProgress:0.2];
        [self.dataFetcher getCoursesForStudentWithSSN:user.ssn success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Got %d courses", [responseObject count]);
            for (NSDictionary *courseInst in responseObject) {
                [CourseInstance courseInstanceWithCentrisInfo:courseInst inManagedObjectContext:[AppFactory managedObjectContext]];
            }
            
            // Get scheduleEvents
            [self updateHUDWithText:@"Sæki stundatöflu" addProgress:0.2];
            [self.dataFetcher getScheduleBySSN:user.ssn success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Got %d scheduleEvents", [responseObject count]);
                for (NSDictionary *event in responseObject) {
                    [ScheduleEvent addScheduleEventWithCentrisInfo:event inManagedObjectContext:[AppFactory managedObjectContext]];
                }
                // Call delegateFinishedLoggingInWithValidUser if assignments is finished fetching
                if (self.threadCounter < 1)
                    self.threadCounter++;
                else
                    [self delegateFinishedLoggingInWithValidUser];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error getting Schedule Events");
            }];
            
            // Get assignments
            [self.dataFetcher getAssignmentsForCourseWithCourseID:@"" inSemester:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Got %d assignments", [responseObject count]);
                for (NSDictionary *assignment in responseObject) {
                    [Assignment addAssignmentWithCentrisInfo:assignment withCourseInstanceID:[assignment[@"CourseInstanceID"] integerValue] inManagedObjectContext:[AppFactory managedObjectContext]];
                }
                // Call delegateFinishedLoggingInWithValidUser if scheduleEvents is finished fetching
                if (self.threadCounter < 1)
                    self.threadCounter++;
                else
                    [self delegateFinishedLoggingInWithValidUser];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error getting assignments");
            }];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error getting Courses");
        }];
    } else {
        [self promptUserWithMessage:@"Netfang eða lykilorð er vitlaust. Vinsamlegast reyndu aftur."
                          title:@"Notandi fannst ekki"
              cancelButtonTitle:@"OK"];
        [self hideHUD];
    }

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

// Authenticates user to API and stores him in Core Data. Returns user
- (User *)doUserLoginWithEmail:(NSString *)email andPassword:(NSString *)password
{
    User *user = nil;
    NSDictionary *userInfo = [self.dataFetcher loginUserWithEmail:email andPassword:password];
    if (userInfo) {
        [self storeInKeychainEmail:email andPassword:password];
        user = [User userWithCentrisInfo:userInfo inManagedObjectContext:[AppFactory managedObjectContext]];
    }
    return user;
}

#pragma mark - Delegators

- (void)delegateFinishedLoggingInWithValidUser
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
        [self.delegate didFinishLoginWithValidUser];
    });
}

#pragma mark - Helper methods

- (void)displayHUDWithText:(NSString *)text
{
    self.HUD.text = text;
    [self.HUD showInView:self.view animated:YES];
}

- (void)updateHUDWithText:(NSString *)text addProgress:(CGFloat)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.HUD.progress += progress;
        self.HUD.text = text;
    });
}

- (void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD hideWithAnimation:YES];
        self.HUD = nil;
    });
}

- (void)storeInKeychainEmail:(NSString *)email andPassword:(NSString *)password
{
    [[AppFactory keychainItemWrapper] setObject:email forKey:(__bridge id)(kSecAttrAccount)];
    [[AppFactory keychainItemWrapper] setObject:password forKey:(__bridge id)(kSecValueData)];
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
