//
//  AppDelegate.m
//  Centris
//

#import "AppDelegate.h"
#import "CentrisManagedObjectContext.h"
#import "AppFactory.h"
#import "KeychainItemWrapper.h"
#import "User+Centris.h"
#import "CentrisManagedObjectContext.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//	UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
//	[tabController setSelectedIndex:2]; // Veitan
	UIViewController *rootViewController = (UIViewController *)self.window.rootViewController;
	if ([rootViewController isKindOfClass:[LoginViewController class]]) {
        KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:[AppFactory keychainFromConfiguration] accessGroup:nil];
        NSString *userEmail = [keyChain objectForKey:(__bridge id)(kSecAttrAccount)];
        User *user = [User userWithEmail:userEmail inManagedObjectContext:[[CentrisManagedObjectContext sharedInstance] managedObjectContext]];
        if (user)
            [self didFinishLoginWithValidUser];
        else {
            LoginViewController *loginController = (LoginViewController *)rootViewController;
            loginController.delegate = self;
        }
	}
    
    // Debug
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//	UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
//    [self.window setRootViewController:tabBarController];

	
    // White status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [CentrisTheme headingMediumFont]
                                                           }];
    [[UINavigationBar appearance] setBarTintColor:[CentrisTheme redColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    return YES;
}

-(void)didFinishLoginWithValidUser
{
    
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
	[tabBarController setSelectedIndex:2]; // Veitan
	[self.window setRootViewController:tabBarController];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error;
    id context = [[CentrisManagedObjectContext sharedInstance] managedObjectContext];
    
    if (context != nil) {
        if ([context hasChanges] && ![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark Core Data stack

@end

