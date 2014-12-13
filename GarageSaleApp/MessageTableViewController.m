//
//  MessageTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "MessageTableViewController.h"
#import "MessageDetailViewController.h"
#import "SWRevealViewController.h"
#import "Message.h"
#import "MessageModel.h"
#import "Client.h"
#import "ClientModel.h"
#import "Product.h"
#import "ProductModel.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NSDate+NVTimeAgo.h"

@interface MessageTableViewController ()
{
    // Data for the table
    NSMutableArray *_myData;
    
    // The message that is selected from the table
    Message *_selectedMessage;
    
}
@end

@implementation MessageTableViewController

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
    
    MessageModel *messagesMethods = [[MessageModel alloc] init];

    // For the reveal menu to work
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Add title and menu button
    self.navigationItem.title = [self updateTableTitle];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"EmptyFilter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonClicked:)];
    self.navigationItem.rightBarButtonItem = filterButton;
    
    self.detailViewController = (MessageDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Get the listing data
    _myData = messagesMethods.getMessagesArray;
    
    // Assign detail view with first item
    _selectedMessage = [_myData firstObject];
    [self.detailViewController setDetailItem:_selectedMessage];
    
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
    [self makeFBRequestForNewNotifications];
    
}

- (void)filterButtonClicked:(id)sender
{
    //
}

- (NSString*)updateTableTitle
{
    NSString *tableTitle = [[NSString alloc] init];

    MessageModel *messageMethods = [[MessageModel alloc] init];
    
    int numberOfMessagesToDisplay = [messageMethods numberOfMessagesNotReplied];
    
    if (numberOfMessagesToDisplay == 0)
    {
        tableTitle = @"Mensajes";
    }
    else
    {
        tableTitle = [NSString stringWithFormat:@"Mensajes (%i)", numberOfMessagesToDisplay];
    }
    return tableTitle;
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
    
    ProductModel *productMethods = [[ProductModel alloc] init];
    Product *productRelatedToMessage = [[Product alloc] init];
    
    ClientModel *clientMethods = [[ClientModel alloc] init];
    Client *clientRelatedToMessage = [[Client alloc] init];

    // Retrieve cell
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Get the listing to be shown
    Message *myMessage = _myData[indexPath.row];
    
    // Get references to images and labels of cell
    UILabel *nameLabel = (UILabel*)[myCell.contentView viewWithTag:1];
    UILabel *messageLabel = (UILabel*)[myCell.contentView viewWithTag:2];
    UILabel *datetimeLabel = (UILabel*)[myCell.contentView viewWithTag:3];
    UIImageView *markImage = (UIImageView*)[myCell.contentView viewWithTag:4];
    UIImageView *productImage = (UIImageView*)[myCell.contentView viewWithTag:5];
    UIImageView *soldImage = (UIImageView*)[myCell.contentView viewWithTag:6];
    UIImageView *verifiedImage = (UIImageView*)[myCell.contentView viewWithTag:7];
    
    // Set table cell labels to listing data
    
    // Client name and status
    clientRelatedToMessage = [clientMethods getClientFromClientId:myMessage.client_id];
    if ([clientRelatedToMessage.status isEqualToString:@"V"])
    {
        nameLabel.text = [NSString stringWithFormat:@"    %@ %@", clientRelatedToMessage.name, clientRelatedToMessage.last_name];
        verifiedImage.image = [UIImage imageNamed:@"Verified"];
    }
    else
    {
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", clientRelatedToMessage.name, clientRelatedToMessage.last_name];
        verifiedImage.image = [UIImage imageNamed:@"Blank"];
    }
    
    messageLabel.text = myMessage.message;
    //[messageLabel sizeToFit];
    
    datetimeLabel.text = [myMessage.datetime formattedAsTimeAgo];

    // Set mark depending on message status
    if ([myMessage.status isEqualToString:@"N"])
    {
        markImage.image = [UIImage imageNamed:@"BlueDot"];
    }
    else if ([myMessage.status isEqualToString:@"R"])
    {
        markImage.image = [UIImage imageNamed:@"Replied"];
    }
    else if ([myMessage.status isEqualToString:@"P"])
    {
        markImage.image = [UIImage imageNamed:@"Blank"];
    }

    soldImage.image = [UIImage imageNamed:@"Blank"];

    // Set image for product or message
    if ([myMessage.type isEqualToString:@"P"])
    {
        //productImage.image = [productMethods getImageFromProductId:myMessage.product_id];
        
        productRelatedToMessage = [productMethods getProductFromProductId:myMessage.product_id];
        productImage.image = [UIImage imageWithData:productRelatedToMessage.picture];
        
        // Set sold image if product is sold
        if ([productRelatedToMessage.status isEqualToString:@"S"])
        {
            soldImage.image = [UIImage imageNamed:@"Sold"];
        }

    }
    else if ([myMessage.type isEqualToString:@"I"])
    {
        productImage.image = [UIImage imageNamed:@"Message"];
    }
    else if ([myMessage.type isEqualToString:@"W"])
    {
        productImage.image = [UIImage imageNamed:@"Message"];
    }

    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected listing to var
    _selectedMessage = _myData[indexPath.row];
    
    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedMessage];
}


#pragma mark - Contact with Facebook

- (void) makeFBRequestForNewNotifications;
{
    [FBRequestConnection startWithGraphPath:@"me/notifications?fields=application,link&include_read=true"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error) {  // FB request was a success!
                                  
                                  if (result[@"data"]) {   // There is FB data!
                                      
                                      NSArray *jsonArray = result[@"data"];
                                      NSMutableArray *photosArray = [[NSMutableArray alloc] init];
                                      
                                      // Get photo IDs of all notifications
                                      photosArray = [self getPhotosIDs:jsonArray];
                                      
                                      if (photosArray.count >0) { // New notifications related to photos!
                                          
                                          // Get message details for those notifications
                                          [self makeFBRequestForPhotosDetails:photosArray];
                                      }
                                    
                                  }
                                  else
                                  {
                                      [self.refreshControl endRefreshing];
                                  }
                                
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
    
}

- (NSMutableArray*)getPhotosIDs:(NSArray*)arrayResultsData;
{
    // Method that takes the result of a call to FB and return an array with the IDs of the photos mentioned in the notifications
    
    NSMutableArray *photosArray = [[NSMutableArray alloc] init];
    
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    
    // Look for "Photos" notifications
    
    for (int i=0; i<arrayResultsData.count; i=i+1)
    {
        NSDictionary *newMessage = arrayResultsData[i];
        
        if ([newMessage[@"application"][@"name"] isEqual: @"Photos"]) {
            
            NSString *notificationLink = newMessage[@"link"];
            NSString *photoIDfromLink = [messagesMethods getPhotoID:notificationLink];
            
            // Add photo ID to array
            [photosArray addObject:photoIDfromLink];
                
            }
    }
    
    return photosArray;
}

- (void) makeFBRequestForPhotosDetails:(NSMutableArray*)photosArray;
{
    
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    ClientModel *clientMethods = [[ClientModel alloc] init];
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    NSMutableArray *newClientsArray = [[NSMutableArray alloc] init];
    
    
    // Create string for FB request
    NSMutableString *requestPhotosList = [[NSMutableString alloc] init];
    [requestPhotosList appendString:@"?ids="];
    
    for (int i=0; i<photosArray.count; i=i+1)
    {
        if (i>0) { [requestPhotosList appendString:@","]; }
        [requestPhotosList appendString:photosArray[i]];
    }
    
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
                                                  
                                                  Client *newClient = [[Client alloc] init];
                                                  
                                                  newClient.client_id = [clientMethods getNextClientID];
                                                  newClient.fb_client_id = tempMessage.fb_from_id;
                                                  newClient.type = @"F";
                                                  newClient.name = tempMessage.fb_from_name; // TEMPORAL
                                                  newClient.preference = @"F";
                                                  newClient.status = @"N";
                                                  newClient.created_time = [NSDate date];
                                                  newClient.last_interacted_time = tempMessage.datetime;
                                                  
                                                  [clientMethods addNewClient:newClient];
                                                  [newClientsArray addObject:newClient];

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
                                  
                                  // Get details for each new client found
                                  
                                  if (newClientsArray.count>0)
                                  {
                                      [self makeFBRequestForClientsDetails:newClientsArray];
                                  }
                                  
                                  // Disable refresh icon and update table title
                                  
                                  [self.refreshControl endRefreshing];
                                  self.navigationItem.title = [self updateTableTitle];
                                  
                              }
                              else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          } ];
    
}



- (void) makeFBRequestForClientsDetails:(NSMutableArray*)newClientsArray;
{

    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    // Create string for FB request
    NSMutableString *requestClientDetails = [[NSMutableString alloc] init];
    Client *newClient = [[Client alloc] init];

    for (int i=0; i<newClientsArray.count; i=i+1)
    {
        newClient = [[Client alloc] init];
        newClient = (Client *)newClientsArray[i];

        requestClientDetails = [[NSMutableString alloc] init];
        [requestClientDetails appendString:newClient.fb_client_id];
        [requestClientDetails appendString:@"?fields=first_name,last_name,gender,picture"];

        // Make FB request
        [FBRequestConnection startWithGraphPath:requestClientDetails
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error) { // FB request was a success!
                                  
                                  newClient.name = result[@"first_name"];
                                  newClient.last_name = result[@"last_name"];
                                  if ([result[@"gender"] isEqualToString:@"male"])
                                  {
                                      newClient.sex = @"M";
                                  }
                                  else
                                  {
                                      newClient.sex = @"F";
                                  }
                                  newClient.picture_link = result[@"picture"][@"data"][@"url"];
                                  newClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:newClient.picture_link]];
                                  
                                  [clientMethods updateClient:newClient];
                                
                              }
                              else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          } ];
    }
}


- (void) addNewMessage:(Message*)newMessage;
{
    // Insert message to table array
    [_myData insertObject:newMessage atIndex:0];
    
    // Sort array to be sure new messages are on top
    [_myData sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Message*)a datetime];
        NSDate *second = [(Message*)b datetime];
        return [second compare:first];
        //return [first compare:second];
    }];
    
    // Update database
    // [mainDelegate.sharedArrayMessages insertObject:newMessage atIndex:0]; // DEBE SER CON UN METODO DE MESSAGEMODEL!!
    
    // Reload table
    [UIView transitionWithView:self.tableView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.tableView reloadData];
                    } completion:NULL];
    
}

@end
