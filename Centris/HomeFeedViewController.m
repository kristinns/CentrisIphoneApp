//
//  HomeFeedViewController.m
//  Centris
//
//  Created by Bjarki Sörens on 8/26/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "CentrisDataFetcher.h"
#import "User+Centris.h"

@interface HomeFeedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dayOfWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayOfMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;

@end

@implementation HomeFeedViewController

// Get menuContainer ( MFSlideMenuContainer )
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
// Action when clicked on menu button
- (IBAction)showMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

// Whenever the view is about to appear, if we have not yet opened/created a demo document, do so.

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

// Either creates, opens or just uses the demo document
//   (actually, it will never "just use" it since it just creates the UIManagedDocument instance here;
//    the "just uses" case is just shown that if someone hands you a UIManagedDocument, it might already
//    be open and so you can just use it if it's documentState is UIDocumentStateNormal).
//
// Creating and opening are asynchronous, so in the completion handler we set our Model (managedObjectContext).

- (void)getUser
{
	NSLog(@"getUser");
	// put User in Core Data
	dispatch_queue_t fetchQ = dispatch_queue_create("Centris Fetch", NULL);
	dispatch_async(fetchQ, ^{
		 NSDictionary * user = [CentrisDataFetcher getUser:@"0805903269"];
		[self.managedObjectContext performBlock:^{
            NSLog(@"Thread started");
			[User userWithCentrisInfo:user inManagedObjectContext:self.managedObjectContext];
			[self greet:[user valueForKeyPath:@"Person.SSN"]];
            NSLog(@"%@", user);
		}];
	});

//	NSLog([user description]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//	// Do any additional setup after loading the view.
	
    //NSLog(@"test");
	[self setTimeLabels];
    [self getUser];
    
	//[self greet:@"0805903269"];
}

-(void)greet:(NSString *)SSN {
	NSLog(@"greet");
	id context = self.managedObjectContext;
	User *user = [User userWith:SSN inManagedObjectContext:context];
	NSLog(@"%@", user);
	self.greetingLabel.text = [user.name description];
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
	
//	NSLog(@"formattedDateString: %@", formattedDayOfWeekString);

}

@end
