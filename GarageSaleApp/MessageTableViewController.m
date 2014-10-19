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
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NSDate+NVTimeAgo.h"

@interface MessageTableViewController ()
{
    // Data for the table
    NSMutableArray *_myData;
    
    AppDelegate *mainDelegate;
    
    // The product that is selected from the table
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
    
    // For the reveal menu to work
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Add title and menu button
    self.navigationItem.title = @"Mensajes";
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ClientMenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshButtonClicked:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    self.detailViewController = (MessageDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];
    
    // To have access to shared arrays from AppDelegate
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Get the listing data
    _myData = mainDelegate.sharedArrayMessages;
    
    // Assign detail view with first item
    _selectedMessage = [_myData firstObject];
    [self.detailViewController setDetailItem:_selectedMessage];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;

}

- (void)menuButtonClicked:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

- (void)refreshButtonClicked:(id)sender
{
    [self makeFBRequestForNewNotifications];
    
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
    Message *myMessage = _myData[indexPath.row];
    
    // Get references to images and labels of cell
    UILabel *nameLabel = (UILabel*)[myCell.contentView viewWithTag:1];
    UILabel *messageLabel = (UILabel*)[myCell.contentView viewWithTag:2];
    UILabel *datetimeLabel = (UILabel*)[myCell.contentView viewWithTag:3];
    
    // Set table cell labels to listing data
    nameLabel.text = myMessage.fb_from_name;
    messageLabel.text = myMessage.message;
    datetimeLabel.text = [myMessage.datetime formattedAsTimeAgo];
        
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
                                          newProduct.GS_code = @"";
                                          newProduct.name = @"New Product";
                                          newProduct.desc = @"Tiene un sonidito casi imperceptible. Comprado en USA el año pasado. Solo ha sido usado durante 5 meses y muy poco. La Aurora - MIRAFLORES";
                                          newProduct.fb_photo_id = photoID;
                                          newProduct.currency = @"";
                                          newProduct.initial_price = 0;
                                          newProduct.published_price = 0;
                                          newProduct.publishing_date = [dateFormat dateFromString:@"20140301"];
                                          newProduct.picture_link = @"https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-prn1/t1.0-9/10341676_838515596177140_687032528327336304_n.jpg";
                                          //tempProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempProduct.picture_link]];
                                          newProduct.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Perfume.png"];
                                          newProduct.additional_pictures = @"";
                                          newProduct.status = @"N";
                                          newProduct.promotion_piority = 2;
                                          newProduct.notes = @"";
                                          newProduct.agent_id = @"00001";

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
