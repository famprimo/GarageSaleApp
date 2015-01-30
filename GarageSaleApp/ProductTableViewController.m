//
//  ProductTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ProductTableViewController.h"
#import "ProductDetailViewController.h"
#import "SWRevealViewController.h"
#import "Product.h"
#import "ProductModel.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NSDate+NVTimeAgo.h"

@interface ProductTableViewController ()
{
    
    // Data for the table
    NSMutableArray *_myData;
    
    // Data for the search
    NSMutableArray *_mySearchData;
    
    AppDelegate *mainDelegate;
    
    // The product that is selected from the table
    Product *_selectedProduct;

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

    // Add title and menu button
    self.navigationItem.title = @"Productos";
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.detailViewController = (ProductDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];

    // To have access to shared arrays from AppDelegate
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Get the listing data
    _myData = mainDelegate.sharedArrayProducts;
    
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

- (void)menuButtonClicked:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

- (void)refreshTableGesture:(id)sender
{
    [self makeFBRequestForPhotos];
    
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
    UIImageView *soldImage = (UIImageView*)[myCell.contentView viewWithTag:3];
    UILabel *nameLabel = (UILabel*)[myCell.contentView viewWithTag:4];
    UILabel *priceLabel = (UILabel*)[myCell.contentView viewWithTag:5];
    UILabel *codeLabel = (UILabel*)[myCell.contentView viewWithTag:6];
    UILabel *typeLabel = (UILabel*)[myCell.contentView viewWithTag:7];
    UILabel *dateLabel = (UILabel*)[myCell.contentView viewWithTag:8];
    
    // Set table cell labels to listing data
    productImage.image = [UIImage imageWithData:myProduct.picture];
    nameLabel.text = myProduct.name;
    codeLabel.text = myProduct.GS_code;
    priceLabel.text = [NSString stringWithFormat:@"%@%.f", myProduct.currency, myProduct.published_price];
    dateLabel.text = [myProduct.created_time formattedAsTimeAgo];
    if ([myProduct.type isEqualToString:@"S"])
    {
        typeLabel.text = @"Venta";
    }
    else // @"A"
    {
        typeLabel.text = @"Publicidad";
    }
    
    // Set mark and sold message depending on message status
    if ([myProduct.status isEqualToString:@"N"])
    {
        markImage.image = [UIImage imageNamed:@"BlueDot"];
        soldImage.image = [UIImage imageNamed:@"Blank"];
    }
    else if ([myProduct.status isEqualToString:@"S"])
    {
        markImage.image = [UIImage imageNamed:@"Blank"];
        soldImage.image = [UIImage imageNamed:@"Sold"];
    }
    else if ([myProduct.status isEqualToString:@"D"])
    {
        markImage.image = [UIImage imageNamed:@"Denied"];
        soldImage.image = [UIImage imageNamed:@"Blank"];
    }
    else
    {
        markImage.image = [UIImage imageNamed:@"Blank"];
        soldImage.image = [UIImage imageNamed:@"Blank"];
    }
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row selected at row %li", (long)indexPath.row);
    
    // Set selected listing to var
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _selectedProduct = _mySearchData[indexPath.row];;
    } else {
        _selectedProduct = _myData[indexPath.row];
    }
    
    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedProduct];

}


#pragma mark - Contact with Facebook

- (void) makeFBRequestForPhotos;
{
    
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    // Create string for FB request
    NSString *requestPhotosList = @"me/photos/uploaded?fields=created_time,id,link,updated_time,picture,name";
    
    // Make FB request
    [FBRequestConnection startWithGraphPath:requestPhotosList
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error) { // FB request was a success!
                                  
                                  if (result[@"data"]) {   // There is FB data!
                                      
                                      NSArray *photosArray = result[@"data"];
                                      
                                      // Get details and create array
                                      for (int i=0; i<photosArray.count; i=i+1)
                                      {
                                          
                                          // Review each photo
                                          NSString *photoID = photosArray[i][@"id"];
                                          
                                          // Review if product exists
                                          NSString *productID = [productMethods getProductIDfromFbPhotoId:photoID];
                                          
                                          if ([productID  isEqual: @"Not Found"])
                                          {
                                              // New product!
                                              productID = [productMethods getNextProductID];
                                              
                                              Product *newProduct = [[Product alloc] init];
                                              
                                              newProduct.product_id = productID;
                                              newProduct.client_id = @"";
                                              newProduct.name = @"New Product";
                                              newProduct.desc = photosArray[i][@"name"];
                                              newProduct.fb_photo_id = photoID;
                                              
                                              // BUSCAR EN LA DESCRIPCION PARA TOMAR CURRENCY, PUBLISHED PRICE Y GS_CODE
                                              
                                              newProduct.GS_code = @"GS";
                                              newProduct.currency = @"S/.";
                                              newProduct.initial_price = 0;
                                              newProduct.published_price = 0;
                                              newProduct.type = @"S";
                                              
                                              NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
                                              [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
                                              newProduct.created_time = [formatFBdates dateFromString:photosArray[i][@"created_time"]];
                                              newProduct.updated_time = [formatFBdates dateFromString:photosArray[i][@"updated_time"]];
                                              newProduct.fb_updated_time = [formatFBdates dateFromString:photosArray[i][@"updated_time"]];
                                              
                                              newProduct.picture_link = photosArray[i][@"picture"];
                                              newProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:newProduct.picture_link]];
                                              newProduct.additional_pictures = @"";
                                              newProduct.status = @"N";
                                              newProduct.promotion_piority = 2;
                                              newProduct.notes = @"";
                                              newProduct.agent_id = @"00001";
                                              
                                              
                                              // Insert new product to array and add row to table
                                              [self addNewProduct:newProduct];

                                          }
                                          
                                      }
                                      [self.refreshControl endRefreshing];

                                  }
                                  else
                                  {
                                      [self.refreshControl endRefreshing];
                                  }
                        
                                  
                              }
                              else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          } ];

    
}

- (void) addNewProduct:(Product*)newProduct;
{
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    // Insert message to table array
    [_myData insertObject:newProduct atIndex:0];
    
    // Sort array to be sure new products are on top
    [_myData sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Product*)a updated_time];
        NSDate *second = [(Product*)b updated_time];
        return [second compare:first];
        //return [first compare:second];
    }];
    
    // Update database
    //[productMethods addNewProduct:newProduct];
    
    // Reload table
    [UIView transitionWithView:self.tableView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.tableView reloadData];
                    } completion:NULL];
    
}

@end
