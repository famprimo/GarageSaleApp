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
#import "ClientModel.h"
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
    
}
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
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newClient:)];
    self.navigationItem.rightBarButtonItem = addButton;
  
    self.detailViewController = (ClientDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];

    // To have access to shared arrays from AppDelegate
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Get the data
    _myDataClients = [[[ClientModel alloc] init] getClientArray];

    // Sort client array to be ordered alphabetically
    [_myDataClients sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Client*)a name];
        NSString *second = [(Client*)b name];
        //return [second compare:first];
        return [first compare:second];
    }];

    
    // Assign detail view with first item
    _selectedClient = [_myDataClients firstObject];
    [self.detailViewController setDetailItem:_selectedClient];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
}

- (void)menuButtonClicked:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIImageView *pictureCell = (UIImageView*)[myCell.contentView viewWithTag:1];
    UILabel *nameLabel = (UILabel*)[myCell.contentView viewWithTag:2];
    UILabel *zoneLabel = (UILabel*)[myCell.contentView viewWithTag:3];
    UILabel *phoneLabel = (UILabel*)[myCell.contentView viewWithTag:4];
    
    // Make client picture rounded
    pictureCell.layer.cornerRadius = pictureCell.frame.size.width / 2;
    pictureCell.clipsToBounds = YES;
    
    // Set table cell labels to client data
    pictureCell.image = [UIImage imageWithData:myClient.picture];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@", myClient.name, myClient.last_name];
    zoneLabel.text = [NSString stringWithFormat:@"Vive en %@", myClient.client_zone];
    phoneLabel.text = myClient.phone1;
    
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
