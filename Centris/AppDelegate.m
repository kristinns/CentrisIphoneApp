//
//  AppDelegate.m
//  Centris
//

#import "AppDelegate.h"
#import "AppFactory.h"
#import "User+Centris.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "TestFlight.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *user = [[AppFactory keychainItemWrapper] objectForKey:(__bridge id)(kSecAttrAccount)];
    [TestFlight addCustomEnvironmentInformation:user forKey:@"user"];
    [TestFlight takeOff:@"42b8e02a-a292-4dd7-a5ab-012898ca6dbd"];
//	UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
//	[tabController setSelectedIndex:2]; // Veitan
	UIViewController *rootViewController = (UIViewController *)self.window.rootViewController;
	if ([rootViewController isKindOfClass:[LoginViewController class]]) {
        NSString *username = [[AppFactory keychainItemWrapper] objectForKey:(__bridge id)(kSecAttrAccount)];
        User *user = [User userWithUsername:username inManagedObjectContext:[AppFactory managedObjectContext]];
        if (user)
            [self didFinishLoginWithValidUser];
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
    
    // AFNetworking NetworkAcitvityIndicator
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    return YES;
}

#pragma mark - Login Delegates
-(void)didFinishLoginWithValidUser
{
    [TestFlight passCheckpoint:@"Got to the HomeFeed"];
    [self saveContext];
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
	[tabBarController setSelectedIndex:2]; // Veitan
	[self.window setRootViewController:tabBarController];
}

#pragma mark - Logout delegates
-(void)didLogOutUser
{
    [self saveContext];
    // Remove database file, not sure if this is the right way
    NSArray *entities = @[@"Assignment", @"ScheduleEvent", @"AssignmentFile", @"CourseInstance", @"ScheduleEventUnit", @"User"];
    for (NSString *entityDescription in entities) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[AppFactory managedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *items = [[AppFactory managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        
        for (NSManagedObject *managedObject in items) {
            [[AppFactory managedObjectContext] deleteObject:managedObject];
            //NSLog(@"%@ object deleted",entityDescription);
        }
        if (![[AppFactory managedObjectContext] save:&error]) {
            NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
        }

    }

    // Destroy username from keychain
    [[AppFactory keychainItemWrapper] setObject:@"" forKey:(__bridge id)(kSecAttrAccount)];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.window setRootViewController:loginViewController];
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
    id context = [AppFactory managedObjectContext];
    
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

