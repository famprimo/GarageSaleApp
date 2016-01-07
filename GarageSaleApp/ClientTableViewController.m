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
    
    // Add title and menu button
    [self updateTableTitle];
    
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
    
    // Create and setup the search controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
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
    _newClient.replied = @"Y";
    _newClient.last_msg_id = @"";
    _newClient.notes = @"";
    _newClient.agent_id = @"00001";
    
    [_clientMethods addNewClient:_newClient];
}

- (void)refreshTableGesture:(id)sender
{
    [_clientMethods syncCoreDataWithParse];
}

- (void)updateTableTitle
{
    NSString *tableTitle = [[NSString alloc] init];
    
    
    int numberofClients = _myDataClients.count;
    int numberofNewClients = [_clientMethods numberOfNewClients];
    
    if ((numberofClients == 0) || (numberofNewClients == 0))
    {
        tableTitle = @"Clientes";
    }
    else
    {
        tableTitle = [NSString stringWithFormat:@"Clientes (%i/%i)", numberofNewClients, numberofClients];
    }
    
    self.navigationItem.title = tableTitle;
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
    [self updateTableTitle];
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


#pragma mark UISearchController Delegate Methods

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString];
    [self.tableView reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText
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
    // Return the number of rows in the section
    if (self.searchController.active) {
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

    myCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (self.searchController.active) {
        myClient = _mySearchData[indexPath.row];;
    } else {
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
        zoneLabel.textColor = [UIColor lightGrayColor];
    }
    else
    {
        zoneLabel.text = [NSString stringWithFormat:@"Vive en %@", myClient.client_zone];
        zoneLabel.textColor = [UIColor blackColor];
    }
    
    if (myClient.phone1 == nil || [myClient.phone1 isEqualToString:@""])
    {
        phoneLabel.text = @"Sin telefono";
        phoneLabel.textColor = [UIColor lightGrayColor];
    }
    else
    {
        phoneLabel.text = myClient.phone1;
        phoneLabel.textColor = [UIColor blackColor];
    }
    
    if (myClient.codeGS == nil || [myClient.codeGS isEqualToString:@""])
    {
        codeGSLabel.text = @"Sin código GS";
        codeGSLabel.textColor = [UIColor lightGrayColor];
    }
    else
    {
        codeGSLabel.text = myClient.codeGS;
        codeGSLabel.textColor = [UIColor blackColor];
    }

    
    if ([myClient.status isEqualToString:@"N"])
    {
        nameLabel.textColor = [UIColor blueColor];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", myClient.name, myClient.last_name];
        verifiedImage.image = [UIImage imageNamed:@"Blank"];
    }
    else if ([myClient.status isEqualToString:@"U"])
    {
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", myClient.name, myClient.last_name];
        verifiedImage.image = [UIImage imageNamed:@"Blank"];
    }
    else if ([myClient.status isEqualToString:@"V"])
    {
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.text = [NSString stringWithFormat:@"    %@ %@", myClient.name, myClient.last_name];
        verifiedImage.image = [UIImage imageNamed:@"Verified"];
    }
    else
    {
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", myClient.name, myClient.last_name];
        verifiedImage.image = [UIImage imageNamed:@"Blank"];
    }

    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected cell to client
    if (self.searchController.active) {
        _selectedClient = _mySearchData[indexPath.row];
    } else {
        _selectedClient = _myDataClients[indexPath.row];
    }

    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedClient];
}


@end
