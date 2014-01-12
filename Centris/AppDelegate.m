//
//  AppDelegate.m
//  Centris
//

#import "AppDelegate.h"
#import "AppFactory.h"
#import "User+Centris.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "TestFlight.h"

#define TAB_BAR_VIEW_CONTROLLER_IDENTIFIER @"TabBarViewController"
#define SELECTED_TAB 2
#define LOGIN_VIEW_CONTROLLER_IDENTIFIER @"LoginViewController"
#define TESTFLIGHT_APP_CODE @"42b8e02a-a292-4dd7-a5ab-012898ca6dbd"

@interface AppDelegate()
@property (nonatomic, strong) NSString *url;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register with TestFlight
    [TestFlight takeOff:TESTFLIGHT_APP_CODE];
    
    // Display LoginController if user is not logged in
	UIViewController *rootViewController = (UIViewController *)self.window.rootViewController;
	if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        NSString *username = [[AppFactory keychainItemWrapper] objectForKey:(__bridge id)(kSecAttrAccount)];
        User *user = [User userWithUsername:username inManagedObjectContext:[AppFactory managedObjectContext]];
        if (user == nil) { // Open LoginController if user is not logged in
            UITabBarController *tabBarController = [[AppFactory mainStoryboard] instantiateViewControllerWithIdentifier:LOGIN_VIEW_CONTROLLER_IDENTIFIER];
            [self.window setRootViewController:tabBarController];
        } else { // Else open tab for Veitan
            UITabBarController *tabBarController = (UITabBarController *)rootViewController;
            [tabBarController setSelectedIndex:SELECTED_TAB];
        }
	}
    
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
    [self checkForUpdate];
    return YES;
}

#pragma mark - App Beta update methods
- (void)checkForUpdate
{
    /* This method is only for TestFlight, this will be removed when app is finished */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://centris2.nfsu.is/api/v1/app_version/"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Version %@, %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [responseObject objectForKey:@"Version"]);
             if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue] < [[responseObject objectForKey:@"Version"] floatValue]) {
                 self.url = [responseObject objectForKey:@"URL"];
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Uppfærsla"
                                                                   message:@"Það er komin uppfærsla af appinu, endilega sæktu nýjasta með því að smella á uppfæra"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Uppfæra"
                                                         otherButtonTitles:@"Loka", nil];
                 [message show];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error version number");
         }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Uppfæra"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.url]];
    }
}

#pragma mark - Login Delegates
-(void)didFinishLoginWithValidUser
{
    [TestFlight passCheckpoint:@"User logged in successfully"];
    [self saveContext];
    UITabBarController *tabBarController = [[AppFactory mainStoryboard]  instantiateViewControllerWithIdentifier:TAB_BAR_VIEW_CONTROLLER_IDENTIFIER];
	[tabBarController setSelectedIndex:SELECTED_TAB]; // Veitan
	[self.window setRootViewController:tabBarController];
}

#pragma mark - Logout delegates
-(void)didLogOutUser
{
    [self saveContext];
    // Remove database file, not sure if this is the right way
    NSArray *entities = @[@"Assignment", @"ScheduleEvent", @"AssignmentFile", @"CourseInstance", @"ScheduleEventUnit", @"User", @"Announcement"];
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
    
    [TestFlight passCheckpoint:@"User logged out successfully"];

    // Destroy username from keychain
    [[AppFactory keychainItemWrapper] setObject:@"" forKey:(__bridge id)(kSecAttrAccount)];
    LoginViewController *loginViewController = [[AppFactory mainStoryboard] instantiateViewControllerWithIdentifier:LOGIN_VIEW_CONTROLLER_IDENTIFIER];
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
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self checkForUpdate];
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

