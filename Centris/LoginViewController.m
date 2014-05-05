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
#import "Announcement+Centris.h"
#import "Assignment+Centris.h"
#import <HTProgressHUD/HTProgressHUD.h>
#import "HTProgressHUDFadeZoomAnimation.h"
#import "HTProgressHUDIndicatorView.h"
#import "TestFlight.h"

@interface LoginViewController ()
@property (nonatomic, weak) IBOutlet UITextField *emailInput;
@property (nonatomic, weak) IBOutlet UITextField *passwordInput;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) HTProgressHUD *HUD;
@property (nonatomic) NSInteger threadCounter;
@end


@implementation LoginViewController

#pragma mark - Getters

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
    // Add left padding to email and password input
    self.emailInput.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.emailInput.leftView.frame.size.height)];
    self.emailInput.leftViewMode = UITextFieldViewModeAlways;
    self.passwordInput.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.passwordInput.leftView.frame.size.height)];
    self.passwordInput.leftViewMode = UITextFieldViewModeAlways;
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
    id context = [AppFactory managedObjectContext];
    [self.view endEditing:YES];
	NSString *username = self.emailInput.text;
	NSString *password = self.passwordInput.text;
    
    [self displayHUDWithText:@"Skrái þig inn"];
    [self updateHUDWithText:@"Sæki notandaupplýsingar" addProgress:0.2];
    [[AppFactory dataFetcher] loginUserWithUsername:username andPassword:password success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [User addUserWithCentrisInfo:responseObject inManagedObjectContext:context];
        [self storeInKeychainUsername:username andPassword:password];
        
        [self updateHUDWithText:@"Sæki áfanga" addProgress:0.2];
        [[AppFactory dataFetcher] getCoursesInSemester:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            TFLog(@"Got %d courses", [responseObject count]);
            for (NSDictionary *courseInst in responseObject) {
                [CourseInstance addCourseInstanceWithCentrisInfo:courseInst inManagedObjectContext:context];
            }
            
            // Get scheduleEvents
            [self updateHUDWithText:@"Sæki stundatöflu" addProgress:0.2];
            [[AppFactory dataFetcher] getScheduleInSemester:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                TFLog(@"Got %d scheduleEvents", [responseObject count]);
                [ScheduleEvent addScheduleEventsWithCentrisInfo:responseObject inManagedObjectContext:context];
                [self delegateFinishedLoggingInWithValidUser];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                TFLog(@"Error getting Schedule Events");
                [self hideHUD];
                [self promptUserWithMessage:@"Villa kom upp við að sækja stundaskrá :(. Endilega reyndu aftur" title:@"Villa" cancelButtonTitle:@"Ókei"];
            }];
            
            // Get assignments
            [[AppFactory dataFetcher] getAssignmentsInSemester:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                TFLog(@"Got %d assignments", [responseObject count]);
                [Assignment addAssignmentsWithCentrisInfo:responseObject inManagedObjectContext:context];
                [self delegateFinishedLoggingInWithValidUser];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                TFLog(@"Error getting assignments");
                [self hideHUD];
                [self promptUserWithMessage:@"Villa kom upp við að sækja áfanga :(. Endilega reyndu aftur" title:@"Villa" cancelButtonTitle:@"Ókei"];
            }];
            
            // Get announcements
            [[AppFactory dataFetcher] getAnnouncementWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Got %d announcements", [responseObject count]);
                for (NSDictionary *announcementDict in responseObject) {
                    [Announcement addAnnouncementWithCentrisInfo:announcementDict inManagedObjectContext:[AppFactory managedObjectContext]];
                }
                [self delegateFinishedLoggingInWithValidUser];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error getting announcements");
            }];

            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            TFLog(@"Error getting Courses");
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self promptUserWithMessage:@"Netfang eða lykilorð er vitlaust. Vinsamlegast reyndu aftur."
                              title:@"Notandi fannst ekki"
                  cancelButtonTitle:@"OK"];
        [self hideHUD];
        TFLog(@"Error in login");
    }];
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

#pragma mark - Delegators

- (void)delegateFinishedLoggingInWithValidUser
{
    if (self.threadCounter < 2)
        self.threadCounter++;
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
            id<LoginViewControllerDelegate> appDelegate = (id<LoginViewControllerDelegate>)[[UIApplication sharedApplication] delegate];
            [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:COURSE_INSTANCE_LAST_UPDATE];
            [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:ASSIGNMENT_LAST_UPDATED];
            [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:SCHEDULE_LAST_UPDATED];
            [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:ANNOUNCEMENTS_LAST_UPDATED];
            [appDelegate didFinishLoginWithValidUser];
        });
    }
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

- (void)storeInKeychainUsername:(NSString *)username andPassword:(NSString *)password
{
    [[AppFactory keychainItemWrapper] setObject:username forKey:(__bridge id)(kSecAttrAccount)];
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
