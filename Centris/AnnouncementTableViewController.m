//
//  AnnouncementTableViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 14/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AnnouncementTableViewController.h"
#import "AnnouncementTableViewCell.h"
#import "Announcement+Centris.h"
#import "DataFetcher.h"
#import "AppFactory.h"
#import "CourseInstance+Centris.h"
#import "NSDate+Helper.h"
#import "AnnouncementDetailViewController.h"

#define MAX_ANNOUNCEMENT_CONTENT_LENGTH 200
#define ANNOUNCEMENT_ROW_HEIGHT 95.0

@interface AnnouncementTableViewController ()
@property (nonatomic, strong) NSArray *announcements;
@end

@implementation AnnouncementTableViewController

#pragma mark - Properties
- (NSArray *)announcements
{
    if (_announcements == nil)
        [Announcement announcementsInManagedObjectContext:[AppFactory managedObjectContext]];
    return _announcements;
}

#pragma mark - UITableViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.refreshControl addTarget:self action:@selector(userDidRefresh) forControlEvents:UIControlEventValueChanged];
    self.clearsSelectionOnViewWillAppear = NO;
    [self fetchAnnouncementsFromCoreData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"announcementDetailSegue"]) {
        AnnouncementDetailViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.announcement = [self.announcements objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.announcements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnnouncementCell";
    AnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Announcement *announcement = [self.announcements objectAtIndex:indexPath.row];
    cell.titleLabel.text = announcement.title.length != 0 ? announcement.title : @"Enginn titill";
    cell.courseNameLabel.text = ((CourseInstance *)announcement.isInCourseInstance).name;
    cell.dateLabel.text = [announcement.dateInserted stringFromDateWithFormat:@"dd.MMM"];
    NSString *content = [announcement.content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    cell.contentLabel.text = [content substringToIndex:MIN(content.length, MAX_ANNOUNCEMENT_CONTENT_LENGTH)];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ANNOUNCEMENT_ROW_HEIGHT;
}

#pragma mark - Refresh Control
-(void)userDidRefresh
{
    [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:ANNOUNCEMENTS_LAST_UPDATED];
    [self fetchAnnouncementsFromAPI];
}

- (void )fetchAnnouncementsFromCoreData
{
    if ([self viewNeedsToBeUpdated]) {
        // update last updated
        [[AppFactory sharedDefaults] setObject:[NSDate date] forKey:ANNOUNCEMENTS_LAST_UPDATED];
        [self fetchAnnouncementsFromAPI];
    }
    self.announcements = [Announcement announcementsInManagedObjectContext:[AppFactory managedObjectContext]];
    [self.tableView reloadData];
}

- (void)fetchAnnouncementsFromAPI
{
    [self.refreshControl beginRefreshing];
    [[AppFactory dataFetcher] getAnnouncementWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got %d announcements", [responseObject count]);
        for (NSDictionary *announcementDict in responseObject) {
            [Announcement addAnnouncementWithCentrisInfo:announcementDict inManagedObjectContext:[AppFactory managedObjectContext]];
            
        }
        // call success block if any
        [self fetchAnnouncementsFromCoreData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting announcements");
        [self.refreshControl endRefreshing];
    }];
}

// Will compare current date to the saved date in NSUserDefaults. If that date is older than 2 hours it will return YES.
// If that date in NSUserDefaults does not exists, it will return YES. Otherwiese, NO.
- (BOOL)viewNeedsToBeUpdated
{
    NSDate *now = [NSDate date];
    NSDate *lastUpdated = [[AppFactory sharedDefaults] objectForKey:ANNOUNCEMENTS_LAST_UPDATED];
    if (!lastUpdated) { // does not exists, so the view should better update.
        return YES;
    } else if ([now timeIntervalSinceDate:lastUpdated] >= [[[AppFactory configuration] objectForKey:@"defaultUpdateTimeIntervalSeconds"] integerValue]) { // if the time since is more than 2 hours
        return YES;
    } else {
        return NO;
    }
}

@end
