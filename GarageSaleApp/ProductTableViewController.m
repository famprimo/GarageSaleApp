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
    [self makeFBRequestForPhotos];
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


#pragma mark - Contact with Facebook

- (void) makeFBRequestForPhotos;
{

    if (![_tmpSettings.fb_page_id isEqualToString:@""])
    {
        NSString *url = [NSString stringWithFormat:@"%@/photos/uploaded?fields=created_time,id,link,updated_time,picture,name&limit=100", _tmpSettings.fb_page_id];;
        
        [self getFBPhotos:url];
    }
    else
    {
        [self setFacebookPageID];
        
        _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
    }
}

- (void) getFBPhotos:(NSString*)url;
{
    // Make FB request
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url
                                                                   parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
    {
        if (!error) { // FB request was a success!
            
            if (result[@"data"]) {   // There is FB data!
                
                [self parseFBResultsRequestForPhotos:result];
                
                // Review is there is a next page
                // skip the beginning of the url https://graph.facebook.com/
                
                NSString *next = result[@"paging"][@"next"];
                if (next)
                {
                    [self getFBPhotos:[next substringFromIndex:32]];
                }
                else
                {
                    [self.refreshControl endRefreshing];
                }
                
            }
            else
            {
                [self.refreshControl endRefreshing];
            }
        }
        else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error getFBPhotos: %@", error.description);
            
            [self.refreshControl endRefreshing];
        }

    }];

}

- (void) parseFBResultsRequestForPhotos:(id)result
{
    NSArray *photosArray = result[@"data"];
    
    // Get details and create array
    for (int i=0; i<photosArray.count; i=i+1)
    {
        
        // Review each photo
        NSString *photoID = photosArray[i][@"id"];
        
        // Review if product exists
        NSString *productID = [_productMethods getProductIDfromFbPhotoId:photoID];
        
        if ([productID  isEqual: @"Not Found"] && !(photosArray[i][@"name"] == nil) && ![[_productMethods getTextThatFollows:@"GS" fromMessage:photosArray[i][@"name"]] isEqualToString:@"Not Found"])
        {
            // New product!
            productID = [_productMethods getNextProductID];
            
            Product *newProduct = [[Product alloc] init];
            
            newProduct.product_id = productID;
            newProduct.client_id = @"";
            newProduct.desc = photosArray[i][@"name"];
            newProduct.fb_photo_id = photoID;
            newProduct.fb_link = photosArray[i][@"link"];
            
            // Get name, currency, price, GS code and type from photo description
            
            newProduct.name = [_productMethods getProductNameFromFBPhotoDesc:newProduct.desc];
            
            NSString *tmpText;
            
            tmpText = [_productMethods getTextThatFollows:@"GSN" fromMessage:newProduct.desc];
            if (![tmpText isEqualToString:@"Not Found"])
            {
                newProduct.codeGS = [NSString stringWithFormat:@"GSN%@", tmpText];
                newProduct.type = @"A";
                
            }
            else
            {
                tmpText = [_productMethods getTextThatFollows:@"GS" fromMessage:newProduct.desc];
                if (![tmpText isEqualToString:@"Not Found"])
                {
                    newProduct.codeGS = [NSString stringWithFormat:@"GS%@", tmpText];
                    newProduct.type = @"S";
                }
                else
                {
                    newProduct.codeGS = @"None";
                    newProduct.type = @"A";
                }
            }
            
            tmpText = [_productMethods getTextThatFollows:@"s/. " fromMessage:newProduct.desc];
            if (![tmpText isEqualToString:@"Not Found"]) {
                tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
                newProduct.currency = @"S/.";
                newProduct.price = [NSNumber numberWithFloat:[tmpText integerValue]];
            }
            else
            {
                tmpText = [_productMethods getTextThatFollows:@"USD " fromMessage:newProduct.desc];
                if (![tmpText isEqualToString:@"Not Found"]) {
                    tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
                    newProduct.currency = @"USD";
                    newProduct.price = [NSNumber numberWithFloat:[tmpText integerValue]];
                }
                else {
                    newProduct.currency = @"S/.";
                    newProduct.price = 0;
                }
            }
            
            NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
            [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
            newProduct.created_time = [formatFBdates dateFromString:photosArray[i][@"created_time"]];
            newProduct.updated_time = [formatFBdates dateFromString:photosArray[i][@"updated_time"]];
            newProduct.fb_updated_time = [formatFBdates dateFromString:photosArray[i][@"updated_time"]];
            newProduct.solddisabled_time = [formatFBdates dateFromString:@"2000-01-01T01:01:01+0000"];
            newProduct.last_promotion_time = [formatFBdates dateFromString:@"2000-01-01T01:01:01+0000"];

            newProduct.picture_link = photosArray[i][@"picture"];
            newProduct.additional_pictures = @"";
            newProduct.status = @"N";
            newProduct.promotion_piority = @"2";
            newProduct.notes = @"";
            newProduct.agent_id = @"00001";
            
            // Status... Sold?
            tmpText = [_productMethods getTextThatFollows:@"VENDID" fromMessage:newProduct.desc];
            if (![tmpText isEqualToString:@"Not Found"])
            {
                newProduct.status = @"S";
            }

            // Add new product to DB
            [_productMethods addNewProduct:newProduct];
        }
    }
}

- (void)setFacebookPageID;
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSString *url = @"me?fields=id,name,accounts";
        
        // Prepare for FB request
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error) {  // FB request was a success!
                 
                 NSString *userID = result[@"id"];
                 NSString *userName = result[@"name"];
                 NSString *pageID = result[@"accounts"][@"data"][0][@"id"];
                 NSString *pageName = result[@"accounts"][@"data"][0][@"name"];
                 NSString *pageToken = result[@"accounts"][@"data"][0][@"access_token"];
                 
                 if (![[[SettingsModel alloc] init] updateSettingsUser:userName withUserID:userID andPageID:pageID andPageName:pageName andPageTokenID:pageToken]) {
                     NSLog(@"Error updating settings");
                 }
                 
             }
         }];
    }
}

@end
