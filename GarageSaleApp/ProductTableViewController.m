//
//  ProductTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ProductTableViewController.h"
#import "SWRevealViewController.h"
#import "Settings.h"
#import "SettingsModel.h"
#import "NS-Extensions.h"
#import "NSDate+NVTimeAgo.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ProductTableViewController ()
{
    
    // Data for the table
    NSMutableArray *_myData;
    
    // Data for the search
    NSMutableArray *_mySearchData;
    
   // The product that is selected from the table
    Product *_selectedProduct;

    // Temp variables for user and page IDs
    Settings *_tmpSettings;
    
    // Objects Methods
    ProductModel *_productMethods;
    FacebookMethods *_facebookMethods;
    
    // For Filter
    NSString *_filterSelected;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *productsFilterPopover;

@end

@implementation ProductTableViewController 

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
    
    UIBarButtonItem *menuButtonSetup = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Filter"] makeThumbnailOfSize:CGSizeMake(20, 20)] style:UIBarButtonItemStylePlain target:self action:@selector(setupButtonClicked:)];
    menuButtonSetup.width = 40;
    self.navigationItem.rightBarButtonItem = menuButtonSetup;

    self.detailViewController = (ProductDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];
    self.detailViewController.delegate = self;
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Initialize objects methods
    _productMethods = [[ProductModel alloc] init];
    _productMethods.delegate = self;
    
    _facebookMethods = [[FacebookMethods alloc] init];
    _facebookMethods.delegate = self;
    
    // Get the data based on the filter
    _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];

    // Set filter and load data
    [self filterSet:@"Activos"];

    // Add title
    [self updateTableTitle];
    
    // Assign detail view with first item
    _selectedProduct = [_myData firstObject];
    
    [self.detailViewController setDetailItem:_selectedProduct];
    
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

- (void)updateTableTitle
{
    NSString *tableTitle = [[NSString alloc] init];
    
    int newObjects = [_productMethods numberOfActiveProducts];
    
    if (newObjects == 0)
    {
        tableTitle = @"Productos";
    }
    else
    {
        tableTitle = [NSString stringWithFormat:@"Productos (%i)", newObjects];
    }
    self.navigationItem.title = tableTitle;
}

- (void)menuButtonClicked:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

- (void)refreshTableGesture:(id)sender
{
    [_productMethods syncCoreDataWithParse];
}

- (void)setupButtonClicked:(id)sender
{
    ProductsFilterTableViewController *productsFilterController = [[ProductsFilterTableViewController alloc] initWithNibName:@"ProductsFilterTableViewController" bundle:nil];
    productsFilterController.delegate = self;
    
    self.productsFilterPopover = [[UIPopoverController alloc] initWithContentViewController:productsFilterController];
    self.productsFilterPopover.popoverContentSize = CGSizeMake(180.0, 120.0);
    [self.productsFilterPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)didReceiveMemoryWarning
{
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
    [self.productsFilterPopover dismissPopoverAnimated:NO];
    
    _filterSelected = selectedFilter;
    
    // Remove all objects from the filtered search array
    [_myData removeAllObjects];
    
    NSArray *tempArray = [_productMethods getProductArray];
    
    NSString *filterPredicate = @"";
    
    if ([_filterSelected isEqualToString:@"Activos"])
    {
        filterPredicate = @"status like[c] 'N' OR status like[c] 'U'";
    }
    else if ([_filterSelected isEqualToString:@"Nuevos"])
    {
        filterPredicate = @"status like[c] 'N'";
    }
    
    // Filter the array using the predicate
    if (![_filterSelected isEqualToString:@"Todos"])
    {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:filterPredicate];
        _myData = [NSMutableArray arrayWithArray:[tempArray filteredArrayUsingPredicate:resultPredicate]];
    }
    else
    {
        _myData = [NSMutableArray arrayWithArray:tempArray];
    }
    
    // Sort array to be sure new products are on top
    [_myData sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Product*)a last_inventory_time];
        NSDate *second = [(Product*)b last_inventory_time];
        return [second compare:first];
        //return [first compare:second];
    }];

    [self.tableView reloadData];
}


#pragma mark - ProductModel delegate methods

-(void)productsSyncedWithCoreData:(BOOL)succeed;
{
    if (succeed)
    {
        // Product synced so call FB methods
        
        [_facebookMethods initializeMethods];
        
        [_facebookMethods getFBPhotos];
    }
    else
    {
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        [self updateTableTitle];
    }
}

-(void)productAddedOrUpdated:(BOOL)succeed;
{
    if (succeed)
    {
        // Sort array to be sure new products are on top
        [_myData sortUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(Product*)a last_inventory_time];
            NSDate *second = [(Product*)b last_inventory_time];
            return [second compare:first];
        }];
        
        // Reload table with filters
        [self filterSet:_filterSelected];
    }
}


#pragma mark - Detail View Controller delegate methods

-(void)productUpdated;
{
    [self updateTableTitle];
    [self.tableView reloadData];
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
    
    // Filter the array using the search text
    if (![searchText isEqualToString:@""])
    {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(name contains[c] %@) OR (codeGS contains[c] %@)", searchText, searchText];
        _mySearchData = [NSMutableArray arrayWithArray:[_myData filteredArrayUsingPredicate:resultPredicate]];
    }
    else
    {
        _mySearchData = [NSMutableArray arrayWithArray:_myData];
    }
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
    if (self.searchController.active)
    {
        return _mySearchData.count;
    }
    else
    {
        return _myData.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell;
    Product *myProduct = [[Product alloc] init];
    
    myCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (self.searchController.active)
    {
        myProduct = _mySearchData[indexPath.row];;
    }
    else
    {
        myProduct = _myData[indexPath.row];
    }
    
    // Get references to images and labels of cell
    UIImageView *productImage = (UIImageView*)[myCell.contentView viewWithTag:2];
    UILabel *nameLabel = (UILabel*)[myCell.contentView viewWithTag:4];
    UILabel *priceLabel = (UILabel*)[myCell.contentView viewWithTag:5];
    UILabel *codeLabel = (UILabel*)[myCell.contentView viewWithTag:6];
    UILabel *dateLabel = (UILabel*)[myCell.contentView viewWithTag:7];
    
    // Set table cell labels to listing data
    // productImage.image = [UIImage imageWithData:myProduct.picture];
    productImage.image = [UIImage imageWithData:[_productMethods getProductPhotoFrom:myProduct]];
    nameLabel.text = myProduct.name;
    codeLabel.text = myProduct.codeGS;
    dateLabel.text = [myProduct.last_inventory_time formattedAsTimeAgo];
    if ([myProduct.type isEqualToString:@"S"])
    {
        priceLabel.text = [NSString stringWithFormat:@"%@%@", myProduct.currency, myProduct.price];
    }
    else // @"A"
    {
        priceLabel.text = @"Publicidad";
    }
    
    // Set mark and sold message depending on message status
    if ([myProduct.status isEqualToString:@"N"])
    {
        nameLabel.textColor = [UIColor blueColor];
    }
    else if ([myProduct.status isEqualToString:@"D"])
    {
        nameLabel.textColor = [UIColor redColor];
    }
    else
    {
        nameLabel.textColor = [UIColor blackColor];
    }
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected item to detail view
    if (self.searchController.active)
    {
        _selectedProduct = _mySearchData[indexPath.row];;
    }
    else
    {
        _selectedProduct = _myData[indexPath.row];
    }
    
    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedProduct];
}

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    if (self.searchController.active)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    }
    else
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return 80;
    }
    else
    {
        return 0;
    }
}
*/

#pragma mark - FacebookMethods delegate methods

-(void)finishedGettingFBPhotos:(BOOL)succeed;
{
    [self.refreshControl endRefreshing];

    if (succeed)
    {
        // Reload table with filters
        [self filterSet:_filterSelected];

        [self updateTableTitle];
    }
}

-(void)newMessageAddedFromFB:(Message*)messageAdded;
{
    // No need to implement
}

-(void)finishedGettingFBpageNotifications:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedGettingFBInbox:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedGettingFBPageMessages:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedInsertingNewClientsFound:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedGettingFBPhotoComments:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedSendingFBPageMessage:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedSendingFBPhotoMessage:(BOOL)succeed;
{
    // No need to implement
}

@end
