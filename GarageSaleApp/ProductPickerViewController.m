//
//  ProductPickerViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "ProductPickerViewController.h"
#import "Product.h"
#import "ProductModel.h"
#import "Client.h"
#import "ClientModel.h"
#import "NS-Extensions.h"


@interface ProductPickerViewController ()
{
    
    // Data for the table
    NSMutableArray *_productsArray;
    NSMutableArray *_myData;
    NSMutableArray *_mySearchData;
    NSMutableArray *_selectedProductsArray;
    
    // The client that is selected from the table
    Product *_selectedProduct;
    Client *_relatedClient;
    BOOL _multipleSelection;
}
@end


@implementation ProductPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ProductModel *productMethods = [[ProductModel alloc] init];
    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    // Remember to set ViewControler as the delegate and datasource
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    // Get and show client data

    CGRect imageClientFrame = self.imageClient.frame;
    imageClientFrame.origin.x = 5;
    imageClientFrame.origin.y = 8;
    imageClientFrame.size.width = 50;
    imageClientFrame.size.height = 50;
    self.imageClient.frame = imageClientFrame;
    
    self.imageClient.layer.cornerRadius = self.imageClient.frame.size.width / 2;
    self.imageClient.clipsToBounds = YES;

    NSString *clientID = [self.delegate getRelatedOwnerfromProductPicker];
    if ([clientID length] >0)
    {
        _relatedClient = [clientMethods getClientFromClientId:clientID];
        //self.imageClient.image = [UIImage imageWithData:_relatedClient.picture];
        self.imageClient.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:_relatedClient]];
        self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", _relatedClient.name, _relatedClient.last_name];
    }
    else
    {
        self.imageClient.image = [UIImage imageNamed:@"Blank"];
        self.labelClientName.text = @"";
    }

    // Multiple selection?
    _multipleSelection = [self.delegate allowMultipleSelectionfromProductPicker];
    self.myTable.allowsMultipleSelection = _multipleSelection;
    
    // Get the listing data
    _productsArray = productMethods.getProductArray;
    _selectedProductsArray = [[NSMutableArray alloc] init];
    
    // Sort array in alphabetic order
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [_productsArray sortUsingDescriptors:@[sort]];
    
    _myData = [NSMutableArray arrayWithArray:_productsArray];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)selectTab:(id)sender
{

    if (self.filterTabs.selectedSegmentIndex == 1) // Unsold
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(status == %@) OR (status ==%@)", @"N", @"U"];
        _myData = [NSMutableArray arrayWithArray:[_productsArray filteredArrayUsingPredicate:predicate]];
    }
    else if (self.filterTabs.selectedSegmentIndex == 2) // No owner
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"client_id = %@", @""];
        _myData = [NSMutableArray arrayWithArray:[_productsArray filteredArrayUsingPredicate:predicate]];
    }
    else if (self.filterTabs.selectedSegmentIndex == 3) // From client
    {
        if ([_relatedClient.client_id length] > 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"client_id = %@", _relatedClient.client_id];
            _myData = [NSMutableArray arrayWithArray:[_productsArray filteredArrayUsingPredicate:predicate]];
        }
        else
        {
            _myData = [[NSMutableArray alloc] init];
        }
    }
    /*
    else if (self.filterTabs.selectedSegmentIndex == 2) // Recent
    {
        NSDate *referenceDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*21];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updated_time > %@", referenceDate];
        _myData = [NSMutableArray arrayWithArray:[_productsArray filteredArrayUsingPredicate:predicate]];
    }
     */
    else // All
    {
        _myData = [NSMutableArray arrayWithArray:_productsArray];
    }
    
    _selectedProduct = [[Product alloc] init];
    _selectedProductsArray = [[NSMutableArray alloc] init];
    
    [self.myTable reloadData];
}


- (IBAction)selectProduct:(id)sender
{
    if (_selectedProductsArray.count > 0)
    {
        [self.delegate productSelectedfromProductPicker:_selectedProductsArray];
    }
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
    
    _mySearchData = [NSMutableArray arrayWithArray:tempArray];
    
    CGRect searchResultsTableViewFrame = self.searchDisplayController.searchResultsTableView.frame;
    searchResultsTableViewFrame.origin.x = 0;
    searchResultsTableViewFrame.origin.y = 130;
    searchResultsTableViewFrame.size.width = 500;
    searchResultsTableViewFrame.size.height = 370;
    self.searchDisplayController.searchResultsTableView.frame = searchResultsTableViewFrame;
        
}

-(void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Product *myProduct = [[Product alloc] init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        myProduct = _mySearchData[indexPath.row];;
    } else {
        myProduct = _myData[indexPath.row];
    }

    // Set table cell labels to product data
    cell.textLabel.text = myProduct.name;
    // cell.imageView.image = [[UIImage imageWithData:myProduct.picture] makeThumbnailOfSize:CGSizeMake(40, 40)];
    cell.imageView.image = [[UIImage imageWithData:[[[ProductModel alloc] init] getProductPhotoFrom:myProduct]] makeThumbnailOfSize:CGSizeMake(40, 40)];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected cell to client
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _selectedProduct = _mySearchData[indexPath.row];
    } else {
        _selectedProduct = _myData[indexPath.row];
    }

    [_selectedProductsArray insertObject:_selectedProduct atIndex:0];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected cell to client
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _selectedProduct = _mySearchData[indexPath.row];
    } else {
        _selectedProduct = _myData[indexPath.row];
    }

    Product *tmpProduct = [[Product alloc] init];
    
    // Review if selected item is already on the array
    for (int i=0; i<_selectedProductsArray.count; i=i+1)
    {
        tmpProduct = _selectedProductsArray[i];
        if ([tmpProduct.product_id isEqualToString:_selectedProduct.product_id])
        {
            [_selectedProductsArray removeObjectAtIndex:i];
            break;
        }
    }
}


@end
