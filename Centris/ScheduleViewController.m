//
//  ScheduleViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 10/7/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "ScheduleViewController.h"
#import "User+Centris.h"
#import "CentrisDataFetcher.h"
#import "ScheduleEvent+Centris.h"
#import "DatePickerView.h"

@interface ScheduleViewController ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet DatePickerView *datePickerView;

@end

@implementation ScheduleViewController

- (NSManagedObjectContext *)managedObjectContext
{
    if(!_managedObjectContext)
        _managedObjectContext = [[CentrisManagedObjectContext sharedInstance] managedObjectContext];
    
    return _managedObjectContext;
}

- (void)getScheduledEvents
{
	User *user = [User userWith:@"0805903269" inManagedObjectContext:self.managedObjectContext];
	if (user) {
		dispatch_queue_t fetchQ = dispatch_queue_create("Centris Fetch", NULL);
		dispatch_async(fetchQ, ^{
			NSDateComponents *comps = [[NSDateComponents alloc] init];
			[comps setYear:2012];
			[comps setDay:15];
			[comps setMonth:2];
			[comps setHour:8];
			NSDate *from = [[NSCalendar currentCalendar] dateFromComponents:comps];
			[comps setHour:18];
			NSDate *to = [[NSCalendar currentCalendar] dateFromComponents:comps];
            NSDictionary * schedule = [CentrisDataFetcher getSchedule:user.ssn from: from to: to];
            [self.managedObjectContext performBlock:^{
				for (NSDictionary *event in schedule) {
					[ScheduleEvent addScheduleEventWithCentrisInfo:event inManagedObjectContext:self.managedObjectContext];
				}
            }];
        });
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Stundaskrá";
}


@end
