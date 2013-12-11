//
//  CourseInstanceViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 11/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstanceViewController.h"

@interface CourseInstanceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *materialTableView;
@property (strong, nonatomic) NSArray *materialTable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialTableViewHeightConstraint;

@end

@implementation CourseInstanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setup];
}

- (void)setup
{
    self.materialTableView.delegate = self;
    self.materialTableView.dataSource = self;
    
    self.title = self.courseInstance.name;
    
    [self.materialTableView reloadData];
    self.materialTableViewHeightConstraint.constant = self.materialTableView.contentSize.height;
}

- (NSArray *)materialTable
{
    if (_materialTable == nil)
        _materialTable = @[
                          @{ @"title" : @"Kennsluáætlun", @"content" : @"..." },
                          @{ @"title" : @"Lýsing", @"content" : @"..." },
                          @{ @"title" : @"Námsmat", @"content" : @"..." },
                          @{ @"title" : @"Hæfniviðmið", @"content" : @"..." }
                          ];
    return _materialTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.materialTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"materialTableViewCell"];
    cell.textLabel.text = [[self.materialTable objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}

@end
