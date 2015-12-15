//
//  ClientTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ClientTableViewController.h"
#import "ClientDetailViewController.h"
#import "SWRevealViewController.h"
#import "Client.h"
#import "AppDelegate.h"

@interface ClientTableViewController ()
{
    // Data for the table
    NSMutableArray *_myDataClients;
    
    // Data for the search
    NSMutableArray *_mySearchData;

    AppDelegate *mainDelegate;
    
    // The product that is selected from the table
    Client *_selectedClient;
    Client *_newClient;
 
    // Objects Methods
    ClientModel *_clientMethods;
    
    UIBarButtonItem *_menuButtonNew;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *editClientPopover;

@end

@implementation ClientTableViewController

@synthesize clientSearchBar;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // For the reveal menu to work
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    // Add title and menu button
    self.navigationItem.title = @"Clientes";
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    _menuButtonNew = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newClient:)];
    self.navigationItem.rightBarButtonItem = _menuButtonNew;

    self.detailViewController = (ClientDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];
    self.detailViewController.delegate = self;

    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Initialize objects methods
    _clientMethods = [[ClientModel alloc] init];
    _clientMethods.delegate = self;

    // Get the data
    _myDataClients = [_clientMethods getClientArray];

    // Sort array in alphabetic order
    [_myDataClients sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Client*)a name];
        NSString *second = [(Client*)b name];
        return [first compare:second];
    }];
    
    // Assign detail view with first item
    _selectedClient = [_myDataClients firstObject];
    [self.detailViewController setDetailItem:_selectedClient];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refreshTableGesture:) forControlEvents:UIControlEventValueChanged];
}

- (void)menuButtonClicked:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

- (void)newClient:(id)sender
{
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000

    _newClient = [[Client alloc] init];
    
    _newClient.client_id = [_clientMethods getNextClientID];
    _newClient.fb_client_id = @"N/A";
    _newClient.fb_inbox_id = @"";
    _newClient.fb_page_message_id = @"";
    _newClient.type = @"O";
    _newClient.name = @"Nombre";
    _newClient.last_name = @"Apellido";
    _newClient.sex = @"F";
    _newClient.client_zone = @"Surco";
    _newClient.address = @"";
    _newClient.phone1 = @"";
    _newClient.phone2 = @"";
    _newClient.email = @"";
    _newClient.preference = @"F";
    _newClient.picture_link = @"";
    _newClient.status = @"N";
    _newClient.created_time = [NSDate date];
    _newClient.last_interacted_time = [formatFBdates dateFromString:@"2000-01-01T10:00:00+0000"];
    _newClient.last_inventory_time = [formatFBdates dateFromString:@"2000-01-01T10:00:00+0000"];
    _newClient.notes = @"";
    _newClient.agent_id = @"00001";
    
    [_clientMethods addNewClient:_newClient];
}

- (void)refreshTableGesture:(id)sender
{
    [_clientMethods syncCoreDataWithParse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Detail View Controller delegate methods

-(void)clientUpdated;
{
    [self.tableView reloadData];
}


#pragma mark - Client Model delegate methods

-(void)clientsSyncedWithCoreData:(BOOL)succeed;
{
    if (succeed)
    {
        [self.refreshControl endRefreshing];

        // Sort array in alphabetic order
        [_myDataClients sortUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(Client*)a name];
            NSString *second = [(Client*)b name];
            return [first compare:second];
        }];
        
        [self.tableView reloadData];
    }
}

-(void)clientAddedOrUpdated:(BOOL)succeed;
{
    // New client was added to the DB
    
    EditClientViewController *editClientController = [[EditClientViewController alloc] initWithNibName:@"EditClientViewController" bundle:nil];
    editClientController.delegate = self;
    
    
    self.editClientPopover = [[UIPopoverController alloc] initWithContentViewController:editClientController];
    self.editClientPopover.popoverContentSize = CGSizeMake(800, 300);
    [self.editClientPopover presentPopoverFromBarButtonItem:_menuButtonNew permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

#pragma mark - Delegate methods for EditClient

-(Client *)getClientforEdit;
{
    return _newClient;
}

-(void)clientEdited:(Client *)editedClient;
{
    // Dismiss the popover view
    [self.editClientPopover dismissPopoverAnimated:YES];
    
    // Reload the data
    _myDataClients = [[NSMutableArray alloc] init];
    _myDataClients = [_clientMethods getClientArray];
    
    // Sort array in alphabetic order
    [_myDataClients sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Client*)a name];
        NSString *second = [(Client*)b name];
        return [first compare:second];
    }];
    
    [self.tableView reloadData];

    // Assign detail view with first item
    _selectedClient = [_myDataClients firstObject];
    [self.detailViewController setDetailItem:_selectedClient];
}


#pragma mark Content Filtering & UISearchDisplayController Delegate Methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Remove all objects from the filtered search array
    [_mySearchData removeAllObjects];
    NSArray *tempArray;
    
    // Filter the array using the search text
    if (![searchText isEqualToString:@""])
    {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(name contains[c] %@) OR (last_name contains[c] %@)", searchText, searchText];
        tempArray = [_myDataClients filteredArrayUsingPredicate:resultPredicate];
    }
    else
    {
        tempArray = [NSArray arrayWithArray:_myDataClients];
    }
    
    _mySearchData = [NSMutableArray arrayWithArray:tempArray];
    
}

-(void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
    // Remove all objects from the filtered search array
    NSArray *tempArray;
    
    if (_mySearchData == nil)
    {
        tempArray = [NSMutableArray arrayWithArray:_myDataClients];
    }
    else
    {
        tempArray = [NSMutableArray arrayWithArray:_mySearchData];
    }
    
    [_mySearchData removeAllObjects];
    
    // Remove all objects from the filtered search array
    
    _mySearchData = [NSMutableArray arrayWithArray:tempArray];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _mySearchData.count;
        
    } else {
        return _myDataClients.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve cell
    UITableViewCell *myCell;
    Client *myClient = [[Client alloc] init];

    // Get the client to be shown
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        myCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        myClient = _mySearchData[indexPath.row];;
    } else {
        myCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        myClient = _myDataClients[indexPath.row];
    }
    
    // Get references to images and labels of cell
    UIImageView *clientImage = (UIImageView*)[myCell.contentView viewWithTag:1];
    UILabel *nameLabel = (UILabel*)[myCell.contentView viewWithTag:2];
    UILabel *zoneLabel = (UILabel*)[myCell.contentView viewWithTag:3];
    UILabel *phoneLabel = (UILabel*)[myCell.contentView viewWithTag:4];
    UIImageView *verifiedImage = (UIImageView*)[myCell.contentView viewWithTag:5];
    UILabel *codeGSLabel = (UILabel*)[myCell.contentView viewWithTag:6];
    
    // Position all images and message frames
    CGRect clientImageFrame = clientImage.frame;
    clientImageFrame.origin.x = 8;
    clientImageFrame.origin.y = 5;
    clientImageFrame.size.width = 70;
    clientImageFrame.size.height = 70;
    clientImage.frame = clientImageFrame;

    CGRect verifiedImageFrame = verifiedImage.frame;
    verifiedImageFrame.origin.x = 86;
    verifiedImageFrame.origin.y = 10;
    verifiedImageFrame.size.width = 10;
    verifiedImageFrame.size.height = 10;
    verifiedImage.frame = verifiedImageFrame;

    
    // Make client picture rounded
    clientImage.layer.cornerRadius = clientImage.frame.size.width / 2;
    clientImage.clipsToBounds = YES;
    
    // Set table cell labels to client data
    //pictureCell.image = [UIImage imageWithData:myClient.picture];
    clientImage.image = [UIImage imageWithData:[_clientMethods getClientPhotoFrom:myClient]];
    
    if (myClient.client_zone == nil || [myClient.client_zone isEqualToString:@""])
    {
        zoneLabel.text = @"Sin zona";
        zoneLabel.textColor = [UIColor grayColor];
    }
    else
    {
        zoneLabel.text = [NSString stringWithFormat:@"Vive en %@", myClient.client_zone];
        zoneLabel.textColor = [UIColor blackColor];
    }
    
    if (myClient.phone1 == nil || [myClient.phone1 isEqualToString:@""])
    {
        phoneLabel.text = @"Sin telefono";
        phoneLabel.textColor = [UIColor grayColor];
    }
    else
    {
        phoneLabel.text = myClient.phone1;
        phoneLabel.textColor = [UIColor blackColor];
    }
    
    if (myClient.codeGS == nil || [myClient.codeGS isEqualToString:@""])
    {
        codeGSLabel.text = @"Sin código GS";
        codeGSLabel.textColor = [UIColor grayColor];
    }
    else
    {
        codeGSLabel.text = myClient.codeGS;
        codeGSLabel.textColor = [UIColor blackColor];
    }

    
    if ([myClient.status isEqualToString:@"V"])
    {
        nameLabel.text = [NSString stringWithFormat:@"    %@ %@", myClient.name, myClient.last_name];
        verifiedImage.image = [UIImage imageNamed:@"Verified"];
    }
    else
    {
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", myClient.name, myClient.last_name];
        verifiedImage.image = [UIImage imageNamed:@"Blank"];
    }

    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected cell to client
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _selectedClient = _mySearchData[indexPath.row];
    } else {
        _selectedClient = _myDataClients[indexPath.row];
    }

    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedClient];
}


@end
