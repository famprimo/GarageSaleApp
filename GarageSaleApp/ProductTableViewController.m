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
    
    AppDelegate *mainDelegate;
    
    // The product that is selected from the table
    Product *_selectedProduct;

}
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

    // Add title and menu button
    self.navigationItem.title = @"Productos";
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;
     
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"EmptyFilter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonClicked:)];
    self.navigationItem.rightBarButtonItem = filterButton;
    
    self.detailViewController = (ProductDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];

    // To have access to shared arrays from AppDelegate
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Get the listing data
    _myData = mainDelegate.sharedArrayProducts;
    
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

- (void)filterButtonClicked:(id)sender
{
    //
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return _myData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve cell
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Get the listing to be shown
    Product *myProduct = _myData[indexPath.row];
    
    // Get references to images and labels of cell
    UIImageView *pictureCell = (UIImageView*)[myCell.contentView viewWithTag:1];
    UILabel *nameLabel = (UILabel*)[myCell.contentView viewWithTag:2];
    UILabel *codeLabel = (UILabel*)[myCell.contentView viewWithTag:3];
    UILabel *priceLabel = (UILabel*)[myCell.contentView viewWithTag:4];
    UIImageView *markImage = (UIImageView*)[myCell.contentView viewWithTag:5];
    UIImageView *soldImage = (UIImageView*)[myCell.contentView viewWithTag:6];
    
    // Set table cell labels to listing data
    pictureCell.image = [UIImage imageWithData:myProduct.picture];
    nameLabel.text = myProduct.name;
    codeLabel.text = myProduct.GS_code;
    priceLabel.text = [NSString stringWithFormat:@"%@%.f", myProduct.currency, myProduct.published_price];
    
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
    _selectedProduct = _myData[indexPath.row];
    
    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedProduct];

}


#pragma mark - Contact with Facebook

- (void) makeFBRequestForPhotos;
{
    [self.refreshControl endRefreshing];
    
    /*
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    // Create string for FB request
    NSMutableString *requestPhotosList = @"me/photos/uploaded";
    
    // Make FB request
    [FBRequestConnection startWithGraphPath:requestPhotosList
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error) { // FB request was a success!
                                  
                                  // Get details and create array
                                  for (int i=0; i<photosArray.count; i=i+1)
                                  {
                                      
                                      // Review each photo
                                      NSString *photoID = result[photosArray[i]][@"id"];
                                      
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
                                          newProduct.desc = result[photosArray[i]][@"name"];
                                          newProduct.fb_photo_id = photoID;
                                          
                                          // BUSCAR EN LA DESCRIPCION PARA TOMAR CURRENCY, PUBLISHED PRICE Y GS_CODE
                                          
                                          newProduct.GS_code = @"GS";
                                          newProduct.currency = @"S/.";
                                          newProduct.initial_price = 0;
                                          newProduct.published_price = 0;
                                          
                                          NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
                                          [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
                                          newProduct.publishing_date = [formatFBdates dateFromString:result[photosArray[i]][@"created_time"]];
                                          newProduct.last_update = [formatFBdates dateFromString:result[photosArray[i]][@"updated_time"]];
                                          
                                          newProduct.picture_link = result[photosArray[i]][@"picture"];
                                          newProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:newProduct.picture_link]];
                                          newProduct.additional_pictures = @"";
                                          newProduct.status = @"N";
                                          newProduct.promotion_piority = 2;
                                          newProduct.notes = @"";
                                          newProduct.agent_id = @"00001";
                                          
                                          
                                          [productMethods addNewProduct:newProduct];
                                          
                                      }
                                      
                                      // Review each comment
                                      NSArray *jsonArray = result[photosArray[i]][@"comments"][@"data"];
                                      
                                      for (int i=0; i<jsonArray.count; i=i+1)
                                      {
                                          NSDictionary *newMessage = jsonArray[i];
                                          
                                          // Validate if the comment/message exists
                                          if (![messagesMethods existMessage:newMessage[@"id"]])
                                          {
                                              // New message!
                                              Message *tempMessage = [[Message alloc] init];
                                              
                                              tempMessage.fb_msg_id = newMessage[@"id"];
                                              tempMessage.fb_from_id = newMessage[@"from"][@"id"];
                                              tempMessage.fb_from_name = newMessage[@"from"][@"name"];
                                              tempMessage.message = newMessage[@"message"];
                                              
                                              tempMessage.fb_created_time = newMessage[@"created_time"];
                                              NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
                                              [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
                                              tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time];
                                              
                                              tempMessage.fb_photo_id = photoID;
                                              tempMessage.product_id = productID;
                                              tempMessage.agent_id = @"00001";
                                              tempMessage.status = @"N";
                                              tempMessage.type = @"P";
                                              
                                              // Review if client exists
                                              NSString *fromClientID = [clientMethods getClientIDfromFbId:tempMessage.fb_from_id];
                                              
                                              if ([fromClientID  isEqual: @"Not Found"])
                                              {
                                                  // New client!
                                                  // AGREGAR A UN ARREGLO TODOS LOS NUEVOS CLIENTES Y AL FINAL LLAMAR A OTRO METODO
                                                  // QUE PARA CADA NUEVO CLIENTE, HAGA UN LLAMADA A FACEBOOK PARA CONSEGUIR LOS DATOS
                                                  // 10152717477283825?fields=first_name,last_name,gender,picture
                                                  // AL RECIBIR CADA RESPUESTA, LLAMA A UN METODO DE CLIENT QUE LO AGREGA
                                              }
                                              else
                                              {
                                                  tempMessage.client_id = fromClientID;
                                              }
                                              
                                              // Insert new message to array and add row to table
                                              [self addNewMessage:tempMessage];
                                              
                                          }
                                      }
                                      
                                  }
                                  
                              }
                              else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          } ];

    
     */
    
}

@end
