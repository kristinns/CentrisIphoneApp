//
//  SideMenuViewController.m
//  Centris
//

#import "SideMenuTableViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "BaseViewController.h"
#import "BaseTableViewController.h"

@interface SideMenuTableViewController ()

@property (nonatomic, strong) NSMutableArray *menuItems;

@end

@implementation SideMenuTableViewController

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
        
		[_menuItems addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"Veitan", @"title", @"FeedViewController", @"identifier", nil]];
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
    // set the background color
    self.tableView.backgroundColor = [CentrisTheme sideMenuBackgroundColor];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
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
    
    NSString *title = [[self.menuItems objectAtIndex:indexPath.item] valueForKey:@"title"];
    cell.textLabel.text = [title uppercaseString]; // Title
    cell.textLabel.textColor = [UIColor whiteColor];
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [CentrisTheme sideMenuSelectedRowColor]; //centris red
    cell.selectedBackgroundView = selectionColor;
    
    cell.backgroundColor = [CentrisTheme sideMenuBackgroundColor]; //centris navigation grey
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [[self.menuItems objectAtIndex:indexPath.item] valueForKey:@"identifier"];
    id frontViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    if ([frontViewController isKindOfClass:[BaseViewController class]]) {
        BaseViewController *baseVC = (BaseViewController *)frontViewController;
        baseVC.managedObjectContext = self.managedObjectContext;
    } else if ([frontViewController isKindOfClass:[BaseTableViewController class]]) {
        BaseTableViewController *baseTVC = (BaseTableViewController *)frontViewController;
        baseTVC.managedObjectContext = self.managedObjectContext;
    }
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:frontViewController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Centris";
}


@end
