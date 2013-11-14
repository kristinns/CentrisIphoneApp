//
//  AppDelegate.h
//  Centris
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LoginViewController.h"
#import "ProfileViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, LoginViewControllerDelegate, ProfileViewControllerDelegate>

@property (nonatomic, strong) UIWindow *window;
@end
