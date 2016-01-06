//
//  OpportunityTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 21/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "OpportunityTableViewController.h"
#import "OpportunityDetailViewController.h"
#import "SWRevealViewController.h"
#import "Opportunity.h"
#import "Client.h"
#import "ClientModel.h"
#import "Product.h"
#import "ProductModel.h"
#import "NS-Extensions.h"
#import "NSDate+NVTimeAgo.h"


@interface OpportunityTableViewController ()
{
    // Data for the table
    NSMutableArray *_myData;
    
    // Data for the search and filter
    NSMutableArray *_mySearchData;
    
    // The product that is selected from the table
    Opportunity *_selectedOpportunity;
    
    // For Filter
    NSString *_filterSelected;
    
    // Objects Methods
    OpportunityModel *_opportunityMethods;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *opportunitiesFilterPopover;

@end

@implementation OpportunityTableViewController

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
    self.navigationItem.title = @"Oportunidades";
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIBarButtonItem *menuButtonSetup = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Filter"] makeThumbnailOfSize:CGSizeMake(20, 20)] style:UIBarButtonItemStylePlain target:self action:@selector(setupButtonClicked:)];
    menuButtonSetup.width = 40;
    self.navigationItem.rightBarButtonItem = menuButtonSetup;
    
    self.detailViewController = (OpportunityDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];
    self.detailViewController.delegate = self;
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Initialize objects methods
    _opportunityMethods = [[OpportunityModel alloc] init];
    _opportunityMethods.delegate = self;

    // Get the opportunities data
    _myData = [_opportunityMethods getOpportunitiesArray];
    
    // Sort array to be sure new opportunities are on top
    [_myData sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Opportunity*)a created_time];
        NSDate *second = [(Opportunity*)b created_time];
        return [second compare:first];
    }];

    _filterSelected = @"Activas";  // Default filter
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"status like[c] 'O' OR status like[c] 'S'"];
    NSArray *tempArray = [_myData filteredArrayUsingPredicate:resultPredicate];
    _mySearchData = [NSMutableArray arrayWithArray:tempArray];
   
    // Assign detail view with first item - From SearchData
    _selectedOpportunity = [_mySearchData firstObject];
    [self.detailViewController setDetailItem:_selectedOpportunity];
    
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

- (void)refreshTableGesture:(id)sender
{
    [_opportunityMethods syncCoreDataWithParse];
}

- (void)setupButtonClicked:(id)sender
{
    OpportunitiesFilterTableViewController *opportunitiesFilterController = [[OpportunitiesFilterTableViewController alloc] initWithNibName:@"OpportunitiesFilterTableViewController" bundle:nil];
    opportunitiesFilterController.delegate = self;
    
    self.opportunitiesFilterPopover = [[UIPopoverController alloc] initWithContentViewController:opportunitiesFilterController];
    self.opportunitiesFilterPopover.popoverContentSize = CGSizeMake(180.0, 160.0);
    [self.opportunitiesFilterPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Opportunities Filter delegate methods

-(NSString*)getCurrentFilter;
{
    return _filterSelected;
}

-(void)filterSet:(NSString*)selectedFilter;
{
    // Dismiss the popover view
    [self.opportunitiesFilterPopover dismissPopoverAnimated:NO];
    
    _filterSelected = selectedFilter;
    
    // Remove all objects from the filtered search array
    [_mySearchData removeAllObjects];
    
    NSArray *tempArray;
    
    NSString *filterPredicate = @"";
    
    if ([_filterSelected isEqualToString:@"Activas"])
    {
        filterPredicate = @"status like[c] 'O' OR status like[c] 'S'";
    }
    else if ([_filterSelected isEqualToString:@"Abiertas"])
    {
        filterPredicate = @"status like[c] 'O'";
    }
    else if ([_filterSelected isEqualToString:@"Vendidas"])
    {
        filterPredicate = @"status like[c] 'S'";
    }
    
    // Filter the array using the predicate
    if (![_filterSelected isEqualToString:@"Todas"])
    {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:filterPredicate];
        tempArray = [_myData filteredArrayUsingPredicate:resultPredicate];
    }
    else
    {
        tempArray = [NSArray arrayWithArray:_myData];
    }
    
    _mySearchData = [NSMutableArray arrayWithArray:tempArray];
    
    [self.tableView reloadData];
}


#pragma mark - Detail View Controller delegate methods

-(void)opportunityUpdated;
{
    [self.tableView reloadData];
}


#pragma mark - Opportunity Model delegate methods

-(void)opportunitiesSyncedWithCoreData:(BOOL)succeed;
{
    if (succeed)
    {
        [self.refreshControl endRefreshing];
        
        // Sort array to be sure new opportunities are on top
        [_myData sortUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(Opportunity*)a created_time];
            NSDate *second = [(Opportunity*)b created_time];
            return [second compare:first];
        }];
        
        [self.tableView reloadData];
    }
}

-(void)opportunityAddedOrUpdated:(BOOL)succeed;
{
    // Used when an opportunity is updated
}


#pragma mark Content Filtering & UISearchDisplayController Delegate Methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    ProductModel *productMethods = [[ProductModel alloc] init];
    NSArray *tempArray;
    
    if ([_filterSelected isEqualToString:@"Todas"])
    {
        tempArray = [NSArray arrayWithArray:_myData];
    }
    else
    {
        tempArray = [NSArray arrayWithArray:_mySearchData];
    }

    // Remove all objects from the filtered search array
    [_mySearchData removeAllObjects];

    // Search for opportunites that matches searchText
    Opportunity *tempOpportunity = [[Opportunity alloc] init];
    Product *tempProduct = [[Product alloc] init];
    
    for (int i=0; i<tempArray.count; i=i+1)
    {
        tempOpportunity = [tempArray objectAtIndex:i];
        tempProduct = [productMethods getProductFromProductId:tempOpportunity.product_id];
        
        if ([[tempProduct.name uppercaseString] containsString:[searchText uppercaseString]])
        {
            [_mySearchData addObject:tempOpportunity];
        }
     }
}

-(void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView || ![_filterSelected isEqualToString:@"Todas"])
    {
        return _mySearchData.count;
    } else
    {
        return _myData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell;
    Opportunity *myOpportunity = [[Opportunity alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView || ![_filterSelected isEqualToString:@"Todas"])
    {
        myCell = [self.tableView dequeueReusableCellWithIdentifier:@"CellOpp"];
        myOpportunity = _mySearchData[indexPath.row];;
    } else
    {
        myCell = [tableView dequeueReusableCellWithIdentifier:@"CellOpp"];
        myOpportunity = _myData[indexPath.row];
    }

    // Get references to images and labels of cell
    UILabel *productLabel = (UILabel*)[myCell.contentView viewWithTag:1];
    UILabel *opportunityDate = (UILabel*)[myCell.contentView viewWithTag:2];
    UILabel *clientName = (UILabel*)[myCell.contentView viewWithTag:3];
    UILabel *opportunityStatus = (UILabel*)[myCell.contentView viewWithTag:4];
    UIImageView *productImage = (UIImageView*)[myCell.contentView viewWithTag:5];
    UIImageView *clientImage = (UIImageView*)[myCell.contentView viewWithTag:7];
    UIImageView *clientStatus = (UIImageView*)[myCell.contentView viewWithTag:8];
    
    
    CGRect productImageFrame = productImage.frame;
    productImageFrame.origin.x = 8;
    productImageFrame.origin.y = 24;
    productImageFrame.size.width = 40;
    productImageFrame.size.height = 40;
    productImage.frame = productImageFrame;

    CGRect clientImageFrame = clientImage.frame;
    clientImageFrame.origin.x = 56;
    clientImageFrame.origin.y = 24;
    clientImageFrame.size.width = 40;
    clientImageFrame.size.height = 40;
    clientImage.frame = clientImageFrame;

    CGRect clientStatusFrame = clientStatus.frame;
    clientStatusFrame.origin.x = 104;
    clientStatusFrame.origin.y = 27;
    clientStatusFrame.size.width = 10;
    clientStatusFrame.size.height = 10;
    clientStatus.frame = clientStatusFrame;

    // Make client picture rounded
    clientImage.layer.cornerRadius = clientImage.frame.size.width / 2;
    clientImage.clipsToBounds = YES;
    
    Product *relatedProduct = [[[ProductModel alloc] init] getProductFromProductId:myOpportunity.product_id];
    Client *clientRelatedToOpportunity = [[[ClientModel alloc] init] getClientFromClientId:myOpportunity.client_id];

    // Set product data
    
    productLabel.text = relatedProduct.name;
    // productImage.image = [UIImage imageWithData:relatedProduct.picture];
    productImage.image = [UIImage imageWithData:[[[ProductModel alloc] init] getProductPhotoFrom:relatedProduct]];
    
    // Set client data
    //clientImage.image = [UIImage imageWithData:clientRelatedToOpportunity.picture];
    clientImage.image = [UIImage imageWithData:[[[ClientModel alloc] init] getClientPhotoFrom:clientRelatedToOpportunity]];
    if ([clientRelatedToOpportunity.status isEqualToString:@"V"])
    {
        clientName.text = [NSString stringWithFormat:@"    %@ %@", clientRelatedToOpportunity.name, clientRelatedToOpportunity.last_name];
        clientStatus.image = [UIImage imageNamed:@"Verified"];
    }
    else
    {
        clientName.text = [NSString stringWithFormat:@"%@ %@", clientRelatedToOpportunity.name, clientRelatedToOpportunity.last_name];
        clientStatus.image = [UIImage imageNamed:@"Blank"];
    }
    
    // Set opportunity status and dates
    
    opportunityDate.text = [myOpportunity.created_time formattedAsTimeAgo];
    
    if ([myOpportunity.status isEqualToString:@"O"])
    {
        opportunityStatus.text = @"Oportunidad abierta";
        productLabel.textColor = [UIColor blueColor];
    }
    else if ([myOpportunity.status isEqualToString:@"C"])
    {
        opportunityStatus.text = [NSString stringWithFormat:@"Oportunidad cerrada %@", [myOpportunity.closedsold_time formattedAsTimeAgo]];
        productLabel.textColor = [UIColor grayColor];
    }
    else if ([myOpportunity.status isEqualToString:@"S"])
    {
        opportunityStatus.text = [NSString stringWithFormat:@"Producto vendido %@, pero pendiente de pago", [myOpportunity.closedsold_time formattedAsTimeAgo]];
        productLabel.textColor = [UIColor blackColor];
    }
    else if ([myOpportunity.status isEqualToString:@"P"])
    {
        opportunityStatus.text = [NSString stringWithFormat:@"Producto vendido %@, y pagado %@", [myOpportunity.closedsold_time formattedAsTimeAgo], [myOpportunity.paid_time formattedAsTimeAgo]];
        productLabel.textColor = [UIColor blackColor];
    }

    
    return myCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected item to detail view
    if (tableView == self.searchDisplayController.searchResultsTableView || ![_filterSelected isEqualToString:@"Todas"])
    {
        _selectedOpportunity = _mySearchData[indexPath.row];;
    } else
    {
        _selectedOpportunity = _myData[indexPath.row];
    }
        
    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedOpportunity];
}

@end
