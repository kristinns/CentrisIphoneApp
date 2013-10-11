//
//  AppDelegate.h
//  Centris
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LoginViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, LoginViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@end
