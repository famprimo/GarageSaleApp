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
}
@end

@implementation ProductTableViewController 

@synthesize productSearchBar;

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
    
    // Get the data
    _myData = [_productMethods getProductArray];
    _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];

    // Add title
    [self updateTableTitle];

    // Sort array to be sure new products are on top
    [_myData sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Product*)a updated_time];
        NSDate *second = [(Product*)b updated_time];
        return [second compare:first];
        //return [first compare:second];
    }];
    
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
}

- (void)updateTableTitle
{
    NSString *tableTitle = [[NSString alloc] init];
    
    int newObjects = [_productMethods numberOfNewProducts];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            NSDate *first = [(Product*)a updated_time];
            NSDate *second = [(Product*)b updated_time];
            return [second compare:first];
        }];
        
        // Reload table
        [self.tableView reloadData];
        
        /*
         [UIView transitionWithView:self.tableView
         duration:0.5f
         options:UIViewAnimationOptionTransitionCrossDissolve
         animations:^(void) {
         [self.tableView reloadData];
         } completion:NULL];
         */
    }
}


#pragma mark - Detail View Controller delegate methods

-(void)productUpdated;
{
    [self updateTableTitle];
    [self.tableView reloadData];
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
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        tempArray = [_myData filteredArrayUsingPredicate:resultPredicate];
    }
    else
    {
        tempArray = [NSArray arrayWithArray:_myData];
    }
    
    // Further filter the array with the scope
    if ([scope isEqualToString:@"Nuevos"])
    {
        NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"status contains[c] %@",@"N"];
        tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
    }
    
    _mySearchData = [NSMutableArray arrayWithArray:tempArray];
    
}

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
    // Remove all objects from the filtered search array
    NSArray *tempArray;
    
    if (_mySearchData == nil)
    {
        tempArray = [NSMutableArray arrayWithArray:_myData];
    }
    else
    {
        tempArray = [NSMutableArray arrayWithArray:_mySearchData];
    }
    
    [_mySearchData removeAllObjects];

    // Remove all objects from the filtered search array
    
    // Further filter the array with the scope
    if (selectedScope == 1)
    {
        NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"status contains[c] %@",@"N"];
        tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
    }
    
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
        return _myData.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell;
    Product *myProduct = [[Product alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        myCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        myProduct = _mySearchData[indexPath.row];;
    } else {
        myCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        myProduct = _myData[indexPath.row];
    }
    
    // Get references to images and labels of cell
    UIImageView *markImage = (UIImageView*)[myCell.contentView viewWithTag:1];
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
    dateLabel.text = [myProduct.created_time formattedAsTimeAgo];
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
        markImage.image = [UIImage imageNamed:@"BlueDot"];
    }
    else if ([myProduct.status isEqualToString:@"D"])
    {
        markImage.image = [UIImage imageNamed:@"Denied"];
    }
    else
    {
        markImage.image = [UIImage imageNamed:@"Blank"];
    }
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected item to detail view
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _selectedProduct = _mySearchData[indexPath.row];;
    } else {
        _selectedProduct = _myData[indexPath.row];
    }
    
    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedProduct];
}


#pragma mark - FacebookMethods delegate methods

-(void)finishedGettingFBPhotos:(BOOL)succeed;
{
    [self.refreshControl endRefreshing];

    if (succeed)
    {
        // Reload table to make sure all products are included
        _myData = [_productMethods getProductArray];
                
        // Sort array to be sure new products are on top
        [_myData sortUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(Product*)a updated_time];
            NSDate *second = [(Product*)b updated_time];
            return [second compare:first];
            //return [first compare:second];
        }];
        
        // Reload table
        [UIView transitionWithView:self.tableView
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^(void) {
                            [self.tableView reloadData];
                        } completion:NULL];
        
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

@end
