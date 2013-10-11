//
//  HomeFeedViewController.m
//  Centris
//
//  Created by Bjarki Sörens on 8/26/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//


#pragma mark - Imports

#import "HomeFeedViewController.h"
#import "CentrisDataFetcher.h"
#import "User+Centris.h"
#import "CentrisManagedObjectContext.h"
#import "KeychainItemWrapper.h"
#import "AppFactory.h"

#pragma mark - Properties

@interface HomeFeedViewController ()
@property (nonatomic, weak) IBOutlet UILabel *dayOfWeekLabel;
@property (nonatomic, weak) IBOutlet UILabel *dayOfMonthLabel;
@property (nonatomic, weak) IBOutlet UILabel *greetingLabel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation HomeFeedViewController

#pragma mark - Setup

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.navigationController.navigationBar.translucent = NO;
	
	[self setTimeLabels];
    [self getUserFromDatabase];
    self.title = @"Veitan";
    
	//[self greet:@"0805903269"];
}

#pragma mark - Getters

- (NSManagedObjectContext *)managedObjectContext
{
	if (!_managedObjectContext) _managedObjectContext = [[CentrisManagedObjectContext sharedInstance] managedObjectContext];
	return _managedObjectContext;
}

#pragma mark - Methods
- (void)getUserFromDatabase
{
	KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:[AppFactory keychainFromConfiguration] accessGroup:nil];
	NSString *userEmail = [keyChain objectForKey:(__bridge id)(kSecAttrAccount)];
	User *user = [User userWithEmail:userEmail inManagedObjectContext:self.managedObjectContext];
	if(user) {
		NSLog(@"User found, no need to fetch");
        self.greetingLabel.text = [user.name description];
	}
    else {
		// If there is no user available then something in
		// login controller went wrong. TODO: handle that error
		NSLog(@"Something went horribly wrong");
//        // Get user from centris
//        dispatch_queue_t fetchQ = dispatch_queue_create("Centris Fetch", NULL);
//        dispatch_async(fetchQ, ^{
//            NSDictionary * user = [CentrisDataFetcher getUser:ssn];
//            [self.managedObjectContext performBlock:^{
//                User *newUser = [User userWithCentrisInfo:user inManagedObjectContext:self.managedObjectContext];
//                self.greetingLabel.text = newUser.name;
//            }];
//        });
    }
	
}

// Gets the current date and sets it to the date labels
-(void)setTimeLabels
{
	// get the date of today
	NSDate *date = [NSDate date];
	
	//format for the name of the day
	NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEEE"
															 options:0
															  locale:[NSLocale currentLocale]];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatString];
	
	NSString *formattedDayOfWeekString = [dateFormatter stringFromDate:date];
	formattedDayOfWeekString = [formattedDayOfWeekString stringByReplacingCharactersInRange:NSMakeRange(0,1)
																				 withString:[[formattedDayOfWeekString substringToIndex:1]uppercaseString]];
	//set the label
	self.dayOfWeekLabel.text = [NSString stringWithFormat:@"%@,",formattedDayOfWeekString];
	
	//format for the day of the month
	formatString = [NSDateFormatter dateFormatFromTemplate:@"dMMMMYYYY" options:0 locale:[NSLocale currentLocale]];
	[dateFormatter setDateFormat:formatString];
	NSString *formattedDayOfNumberString = [dateFormatter stringFromDate:date];
	//set the label
	self.dayOfMonthLabel.text = formattedDayOfNumberString;
}

@end
