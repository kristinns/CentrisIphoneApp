//
//  SideMenuViewController.m
//  Centris
//

#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"

@interface SideMenuViewController ()

@property (nonatomic, strong) NSMutableArray *menuItems;

@end

@implementation SideMenuViewController

// Get menuContainer ( MFSlideMenuContainer )
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.parentViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)menuItems
{
    // Lazy instantiation
    if (!_menuItems) {
        _menuItems = [[NSMutableArray alloc] init];
        
        [_menuItems addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Stundaskrá", @"title", @"ScheduleTableViewController", @"identifier", nil]];
        [_menuItems addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Verkefni", @"title", @"AssignmentsTableViewController", @"identifier", nil]];
        [_menuItems addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Próf", @"title", @"AssignmentsTableViewController", @"identifier", nil]];

    }
    return _menuItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Top margin, move table 20 px down
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Menu item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.textLabel.text = [[self.menuItems objectAtIndex:indexPath.item] valueForKey:@"title"]; // Title
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [[self.menuItems objectAtIndex:indexPath.item] valueForKey:@"identifier"];
    UIViewController *frontViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:frontViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
