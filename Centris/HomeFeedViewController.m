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

@interface HomeFeedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dayOfWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayOfMonthLabel;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
//	// Do any additional setup after loading the view.
	NSLog([[CentrisDataFetcher getUser:@"2402912319"] valueForKeyPath:@"Person.Address"]);
    //NSLog(@"test");
	[self setTimeLabels];

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
