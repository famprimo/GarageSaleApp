//
//  MessagesTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 06/02/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "MessagesDetailViewController.h"
#import "SWRevealViewController.h"
#import "Message.h"
#import "MessageModel.h"
#import "Client.h"
#import "ClientModel.h"
#import "Product.h"
#import "ProductModel.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NSDate+NVTimeAgo.h"
#import "NS-Extensions.h"

@interface MessagesTableViewController ()
{
    // Data for the table
    NSMutableArray *_myDataClients;
    
    // The message that is selected from the table
    Client *_selectedClientBox;
 
    NSDate *_messagesSinceDate;
}
// For Popover
@property (nonatomic, strong) UIPopoverController *messagesSincePopover;

@end


@implementation MessagesTableViewController

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
    self.navigationItem.title = [self updateTableTitle];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;

    UIBarButtonItem *menuButtonSetup = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Setup"] makeThumbnailOfSize:CGSizeMake(20, 20)] style:UIBarButtonItemStylePlain target:self action:@selector(setupButtonClicked:)];
    menuButtonSetup.width = 40;
    self.navigationItem.rightBarButtonItem = menuButtonSetup;

    self.detailViewController = (MessagesDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Get the data
    _myDataClients = [[[ClientModel alloc] init] getClientArray];
    
    // Define the Since date for a week ago
    _messagesSinceDate = [NSDate dateWithTimeInterval:-60*60*24*1 sinceDate:[NSDate date]];
    
    // Sort array to be sure new messages are on top
    [_myDataClients sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Client*)a last_interacted_time];
        NSDate *second = [(Client*)b last_interacted_time];
        return [second compare:first];
    }];
    
    // Assign detail view with first item
    _selectedClientBox = [_myDataClients firstObject];
    [self.detailViewController setDetailItem:_selectedClientBox];
    
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

- (void)setupButtonClicked:(id)sender
{
    MessagesSinceTableViewController *messagesSinceController = [[MessagesSinceTableViewController alloc] initWithNibName:@"MessagesSinceTableViewController" bundle:nil];
    messagesSinceController.delegate = self;
    
    
    self.messagesSincePopover = [[UIPopoverController alloc] initWithContentViewController:messagesSinceController];
    self.messagesSincePopover.popoverContentSize = CGSizeMake(180.0, 160.0);
    [self.messagesSincePopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


-(NSDate*)getCurrentSinceDate;
{
    return _messagesSinceDate;
}

-(void)sinceDateSelected:(NSDate *)selectedSinceDate;
{
    // Dismiss the popover view
    [self.messagesSincePopover dismissPopoverAnimated:NO];

    _messagesSinceDate = selectedSinceDate;
}

- (void)refreshTableGesture:(id)sender
{
    
    [self makeFBRequestForNewNotifications];
    
    [self makeFBRequestForNewInbox];
    
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
    return _myDataClients.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ProductModel *productMethods = [[ProductModel alloc] init];
    Product *productRelatedToMessage = [[Product alloc] init];
    
    MessageModel *messageMethods = [[MessageModel alloc] init];
    Message *lastMessageFromClient = [[Message alloc] init];
    
    // Retrieve cell
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Get the listing to be shown
    Client *myClient = _myDataClients[indexPath.row];
    
    // Get references to images and labels of cell
    UIImageView *clientImage = (UIImageView*)[myCell.contentView viewWithTag:1];
    UIImageView *verifiedImage = (UIImageView*)[myCell.contentView viewWithTag:2];
    UILabel *nameLabel = (UILabel*)[myCell.contentView viewWithTag:3];
    UILabel *datetimeLabel = (UILabel*)[myCell.contentView viewWithTag:4];
    UIImageView *productImage = (UIImageView*)[myCell.contentView viewWithTag:5];
    UILabel *messageLabel = (UILabel*)[myCell.contentView viewWithTag:6];
    UIImageView *repliedImage = (UIImageView*)[myCell.contentView viewWithTag:7];
    
    // Position all images and message frames
    CGRect clientImageFrame = clientImage.frame;
    clientImageFrame.origin.x = 5;
    clientImageFrame.origin.y = 8;
    clientImageFrame.size.width = 50;
    clientImageFrame.size.height = 50;
    clientImage.frame = clientImageFrame;
    
    CGRect verifiedImageFrame = verifiedImage.frame;
    verifiedImageFrame.origin.x = 63;
    verifiedImageFrame.origin.y = 14;
    verifiedImageFrame.size.width = 10;
    verifiedImageFrame.size.height = 10;
    verifiedImage.frame = verifiedImageFrame;

    CGRect productImageFrame = productImage.frame;
    productImageFrame.origin.x = 63;
    productImageFrame.origin.y = 36;
    productImageFrame.size.width = 30;
    productImageFrame.size.height = 30;
    productImage.frame = productImageFrame;

    CGRect repliedImageFrame = repliedImage.frame;
    repliedImageFrame.origin.x = 40;
    repliedImageFrame.origin.y = 60;
    repliedImageFrame.size.width = 15;
    repliedImageFrame.size.height = 15;
    repliedImage.frame = repliedImageFrame;
    
    CGRect messageLabelFrame = messageLabel.frame;
    messageLabelFrame.origin.x = 63;
    messageLabelFrame.size.width = 245;
    messageLabel.frame = messageLabelFrame;

    
    // Client image, name and status
    clientImage.image = [UIImage imageWithData:myClient.picture];
    clientImage.layer.cornerRadius = clientImage.frame.size.width / 2;
    clientImage.clipsToBounds = YES;

    if ([myClient.status isEqualToString:@"V"])
    {
        nameLabel.text = [NSString stringWithFormat:@"    %@ %@", myClient.name, myClient.last_name];
        verifiedImage.image = [UIImage imageNamed:@"Verified"];
    }
    else
    {
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", myClient.name, myClient.last_name];
        verifiedImage.image = [UIImage imageNamed:@"Blank"];
    }
    
    // Message info
    lastMessageFromClient = [messageMethods getLastMessageFromClient:myClient.client_id];
    
    if (lastMessageFromClient == nil)
    {
        productImage.hidden = YES;
        messageLabel.frame = messageLabelFrame;
        messageLabel.text = @"No hay mensajes";
        datetimeLabel.text = [myClient.last_interacted_time formattedAsTimeAgo];
        repliedImage.image = [UIImage imageNamed:@"Blank"];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:12];
    }
    else
    {
        CGRect messageLabelFrame = messageLabel.frame;
        if ([lastMessageFromClient.status isEqualToString:@"D"]) {
            repliedImage.image = [UIImage imageNamed:@"Replied"];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.font = [UIFont systemFontOfSize:12];
        }
        else if ([lastMessageFromClient.status isEqualToString:@"N"])
        {
            repliedImage.image = [UIImage imageNamed:@"Blank"];
            nameLabel.textColor = [UIColor blueColor];
            nameLabel.font = [UIFont boldSystemFontOfSize:12];
        }
        else
        {
            repliedImage.image = [UIImage imageNamed:@"Blank"];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.font = [UIFont systemFontOfSize:12];
        }
        
        if ([lastMessageFromClient.type isEqualToString:@"P"])
        {
            productImage.hidden = NO;
            productRelatedToMessage = [productMethods getProductFromProductId:lastMessageFromClient.product_id];
            productImage.image = [UIImage imageWithData:productRelatedToMessage.picture];
            messageLabelFrame.origin.x = 96;
            messageLabelFrame.size.width = 212;
            messageLabel.frame = messageLabelFrame;
        }
        else  // @"I"
        {
            productImage.hidden = YES;
        }
        
        if ([lastMessageFromClient.recipient isEqualToString:@"G"])
        {
            messageLabel.text = lastMessageFromClient.message;
        }
        else
        {
            messageLabel.text = [NSString stringWithFormat:@"Garage Sale: %@", lastMessageFromClient.message];
        }
        datetimeLabel.text = [lastMessageFromClient.datetime formattedAsTimeAgo];

    }
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected listing to var
    _selectedClientBox = _myDataClients[indexPath.row];
    
    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedClientBox];
}


#pragma mark - Contact with Facebook



- (void) makeFBRequestForNewNotifications;
{
    // Create string for FB request
    NSString *url = [NSString stringWithFormat:@"me/notifications?fields=application,link&include_read=true&since=%ld", (long)[_messagesSinceDate timeIntervalSince1970]];;
    [self getFBNotifications:url];
}

- (void) getFBNotifications:(NSString*)url;
{
    [FBRequestConnection startWithGraphPath:url completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
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
                                      
                                      // Review is there is a next page
                                      NSString *next = result[@"paging"][@"next"];
                                      if (next)
                                      {
                                          [self getFBNotifications:[next substringFromIndex:32]];
                                      }
                                  }
                                  else
                                  {
                                      [self.refreshControl endRefreshing];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error getFBNotifications: %@", error.description);
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
                                      
                                      if ([productID isEqual: @"Not Found"])
                                      {
                                          // New product!
                                          productID = [productMethods getNextProductID];
                                          
                                          Product *newProduct = [[Product alloc] init];
                                          
                                          newProduct.product_id = productID;
                                          newProduct.client_id = @"";
                                          newProduct.desc = result[photosArray[i]][@"name"];
                                          newProduct.fb_photo_id = photoID;
                                          newProduct.fb_link = result[photosArray[i]][@"link"];
                                          
                                          // Get name, currency, price, GS code and type from photo description
                                          
                                          newProduct.name = [productMethods getProductNameFromFBPhotoDesc:newProduct.desc];
                                          
                                          NSString *tmpText;
                                          
                                          tmpText = [productMethods getTextThatFollows:@"GSN" fromMessage:newProduct.desc];
                                          if (![tmpText isEqualToString:@"Not Found"])
                                          {
                                              newProduct.GS_code = [NSString stringWithFormat:@"GSN%@", tmpText];
                                              newProduct.type = @"A";
                                              
                                          }
                                          else
                                          {
                                              tmpText = [productMethods getTextThatFollows:@"GS" fromMessage:newProduct.desc];
                                              if (![tmpText isEqualToString:@"Not Found"])
                                              {
                                                  newProduct.GS_code = [NSString stringWithFormat:@"GS%@", tmpText];
                                                  newProduct.type = @"S";
                                              }
                                              else
                                              {
                                                  newProduct.GS_code = @"None";
                                                  newProduct.type = @"A";
                                              }
                                          }
                                          
                                          tmpText = [productMethods getTextThatFollows:@"s/. " fromMessage:newProduct.desc];
                                          if (![tmpText isEqualToString:@"Not Found"]) {
                                              tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
                                              newProduct.currency = @"S/.";
                                              newProduct.price = [tmpText integerValue];
                                          }
                                          else
                                          {
                                              tmpText = [productMethods getTextThatFollows:@"USD " fromMessage:newProduct.desc];
                                              if (![tmpText isEqualToString:@"Not Found"]) {
                                                  tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
                                                  newProduct.currency = @"USD";
                                                  newProduct.price = [tmpText integerValue];
                                              }
                                              else {
                                                  newProduct.currency = @"S/.";
                                                  newProduct.price = 0;
                                              }
                                          }
                                          
                                          NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
                                          [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
                                          newProduct.created_time = [formatFBdates dateFromString:result[photosArray[i]][@"created_time"]];
                                          newProduct.updated_time = [formatFBdates dateFromString:result[photosArray[i]][@"updated_time"]];
                                          newProduct.fb_updated_time = [formatFBdates dateFromString:result[photosArray[i]][@"updated_time"]];
                                          
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
                                      NSMutableArray *commentsIDArray = [[NSMutableArray alloc] init];
                                      Message *tempMessage;
                                      Client *tempClient;
                                      
                                      for (int j=0; j<jsonArray.count; j=j+1)
                                      {
                                          NSDictionary *newMessage = jsonArray[j];
                                          [commentsIDArray addObject:newMessage[@"id"]];
                                          
                                          // Validate if the comment/message exists
                                          if (![messagesMethods existMessage:newMessage[@"id"]])
                                          {
                                              // New message!
                                              tempMessage = [[Message alloc] init];
                                              
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
                                              tempMessage.type = @"P";
                                              
                                              if ([tempMessage.fb_from_name hasPrefix:@"Garage"])
                                              {
                                                  tempMessage.recipient = @"C";
                                                  tempMessage.status = @"D";
                                              }
                                              else
                                              {
                                                  tempMessage.recipient = @"G";
                                                  tempMessage.status = @"N";
                                              }
                                              
                                              // Review if client exists
                                              NSString *fromClientID = [clientMethods getClientIDfromFbId:tempMessage.fb_from_id];
                                              
                                              if ([fromClientID  isEqual: @"Not Found"])
                                              {
                                                  // New client!
                                                  
                                                  tempMessage.client_id = [clientMethods getNextClientID];;
                                                  
                                                  Client *newClient = [[Client alloc] init];
                                                  
                                                  newClient.client_id = tempMessage.client_id;
                                                  newClient.fb_client_id = tempMessage.fb_from_id;
                                                  newClient.fb_inbox_id = newClient.fb_client_id;
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
                                                  tempClient = [clientMethods getClientFromClientId:fromClientID];
                                                  tempMessage.fb_inbox_id = tempClient.fb_inbox_id;
                                              }
                                              
                                              // Insert new message to array and add row to table
                                              [self addNewMessage:tempMessage];
                                              
                                          }
                                      }
                                      
                                      // Call method for getting sub comments
                                      [self makeFBRequestForSubComments:commentsIDArray];
                                      
                                  }
                                  
                                  // Get details for each new client found
                                  
                                  if (newClientsArray.count>0)
                                  {
                                      [self makeFBRequestForClientsDetails:newClientsArray];
                                  }
                                  
                                  // Disable refresh icon and update table title
                                  
                                  //[self.refreshControl endRefreshing];
                                  self.navigationItem.title = [self updateTableTitle];
                                  
                              }
                              else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error makeFBRequestForPhotosDetails: %@", error.description);
                              }
                          } ];
    
}



- (void) makeFBRequestForSubComments:(NSMutableArray*)commentsIDArray;
{
    NSMutableString *requestCommentsDetails = [[NSMutableString alloc] init];
    
    // Request detail information for each picture
    
    for (int i=0; i<commentsIDArray.count; i=i+1)
    {
        requestCommentsDetails = [[NSMutableString alloc] init];
        
        [requestCommentsDetails appendString:commentsIDArray[i]];
        [requestCommentsDetails appendString:@"?fields=id,from,created_time,comments"];
        [requestCommentsDetails appendString:[NSString stringWithFormat:@"&since=%ld", (long)[_messagesSinceDate timeIntervalSince1970]]];
        
        [self getFBPhotoSubComments:requestCommentsDetails];

    }
}

- (void) getFBPhotoSubComments:(NSString*)url;
{

    // Make FB request
        [FBRequestConnection startWithGraphPath:url completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
         {
             if (!error) { // FB request was a success!
                 
                 [self parseFBPhotoSubComments:result];

                 // Review is there is a next page
                 // skip the beginning of the url https://graph.facebook.com/
                 
                 NSString *next = result[@"paging"][@"next"];
                 if (next)
                 {
                     [self getFBPhotoSubComments:[next substringFromIndex:32]];
                 }

             }
             else {
                 // An error occurred, we need to handle the error
                 // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                 NSLog(@"error getFBPhotoComments: %@", error.description);
             }
         } ];
    
}


- (void) parseFBPhotoSubComments:(id)result;
{
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    ClientModel *clientMethods = [[ClientModel alloc] init];
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    NSMutableArray *newClientsArray = [[NSMutableArray alloc] init];

    // Get client ID to use
    NSString *tmpFbFromId = result[@"from"][@"id"];
    NSString *fromClientID = [clientMethods getClientIDfromFbId:tmpFbFromId];
    
    // Obtaining photoID from message ID
    NSString *tmpMessageID = result[@"id"];
    NSRange match = [tmpMessageID rangeOfString:@"_"];
    NSString *photoID = [tmpMessageID substringToIndex:match.location];
    
    // Review if product exists
    NSString *productID = [productMethods getProductIDfromFbPhotoId:photoID];
    
    // Review each comment
    NSArray *jsonArray = result[@"comments"][@"data"];
    
    for (int j=0; j<jsonArray.count; j=j+1)
    {
        NSDictionary *newMessage = jsonArray[j];
        
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
            tempMessage.type = @"P";
            
            if ([tempMessage.fb_from_name hasPrefix:@"Garage"])
            {
                tempMessage.recipient = @"C";
                tempMessage.client_id = fromClientID;
                tempMessage.fb_inbox_id = fromClientID;
                tempMessage.status = @"D";
            }
            else
            {
                tempMessage.recipient = @"G";
                tempMessage.status = @"N";
                
                // Review if client exists
                fromClientID = [clientMethods getClientIDfromFbId:tempMessage.fb_from_id];
                
                if ([fromClientID  isEqual: @"Not Found"])
                {
                    // New client!
                    
                    tempMessage.client_id = [clientMethods getNextClientID];;
                    
                    Client *newClient = [[Client alloc] init];
                    
                    newClient.client_id = tempMessage.client_id;
                    newClient.fb_client_id = tempMessage.fb_from_id;
                    newClient.fb_inbox_id = tempMessage.fb_from_id;
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
                    Client *tempClient = [clientMethods getClientFromClientId:fromClientID];
                    tempMessage.fb_inbox_id = tempClient.fb_inbox_id;
                }
            }
            
            // Insert new message to array and add row to table
            [self addNewMessage:tempMessage];
        }
    }
    
    // Get details for each new client found
    
    if (newClientsArray.count>0)
    {
        [self makeFBRequestForClientsDetails:newClientsArray];
    }
    
    // Disable refresh icon and update table title
    
    //[self.refreshControl endRefreshing];
    self.navigationItem.title = [self updateTableTitle];
    
}

- (void) makeFBRequestForNewInbox;
{
    
    NSString *url = [NSString stringWithFormat:@"me/inbox?fields=id,to,updated_time,comments&limit=50&since=%ld", (long)[_messagesSinceDate timeIntervalSince1970]];

    [self getFBInbox:url];

    // me/inbox?fields=id,to,updated_time&limit=50&since=1427587200
    // NSString *url = [NSString stringWithFormat:@"me/inbox?fields=id,to,updated_time&limit=50&since=%ld", (long)[_messagesSinceDate timeIntervalSince1970]];
    // Bajar los chats y comparar con la fecha de ultima interaccion de cada cliente -- El cliente lo toma de "to"... el primero que no sea "Garage"
    // si es mayor, hacer el pedido de los comentarios de esos clientes solamente
    // 1426957567601945/comments?limit=50&since=1427587200  -- El codigo es el del chat, no del cliente
    // NSString *url = [NSString stringWithFormat:@"%@/comments?limit=50&since=%ld", fbInboxID, (long)[_messagesSinceDate timeIntervalSince1970]];
    // El pedido tiene que ser uno por uno para poder explorar los comentarios hasta la fecha maxima
    // actualizar el cliente con la informacion de update time del chat
    // MAS ADELANTE: en configuracion tener un switch para indicar si toma o no la fecha de ultima interaccion para entrar a ver los mensajes
    
    // REVISAR: hacer el pedido inicial que incluye comments, revisar los comments y si son mas de 25 y hay next, hacer un pedido adicional por los comentarios

}

- (void) getFBInbox:(NSString*)url;
{

    [FBRequestConnection startWithGraphPath:url completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
    {
        if (!error) {  // FB request was a success!
    
            if (result[@"data"]) {   // There is FB data!
                
                [self parseFBInbox:result];
                
                // Review is there is a next page
                // skip the beginning of the url https://graph.facebook.com/
                
                NSString *next = result[@"paging"][@"next"];
                if (next)
                {
                    [self getFBInbox:[next substringFromIndex:32]];
                }
                else
                {
                    self.navigationItem.title = [self updateTableTitle];
                    [self.refreshControl endRefreshing];
                }
            }
            else
            {
                self.navigationItem.title = [self updateTableTitle];
                [self.refreshControl endRefreshing];
            }
            
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error getFBInbox: %@", error.description);
        }
    }];
    
}

- (void) parseFBInbox:(id)result;
{
    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    NSMutableArray *newClientsArray = [[NSMutableArray alloc] init];
    
    NSString *fbIDfromInbox;
    NSString *fbNamefromInbox;
    NSString *fbInboxID;

    // Review each chat

    NSArray *jsonArray = result[@"data"];

    
    for (int i=0; i<jsonArray.count; i=i+1)
    {
        fbInboxID = jsonArray[i][@"id"];
        fbNamefromInbox = jsonArray[i][@"to"][@"data"][1][@"name"];
        fbIDfromInbox = jsonArray[i][@"to"][@"data"][1][@"id"];
        
        if ([fbNamefromInbox hasPrefix:@"Garage"])
        {
            fbNamefromInbox = jsonArray[i][@"to"][@"data"][0][@"name"];
            fbIDfromInbox = jsonArray[i][@"to"][@"data"][0][@"id"];
        }
        
        // Review if client exists
        NSString *fromClientID = [clientMethods getClientIDfromFbId:fbIDfromInbox];
        
        if ([fromClientID  isEqual: @"Not Found"])
        {
            // New client!
            
            Client *newClient = [[Client alloc] init];
            
            fromClientID = [clientMethods getNextClientID];
            newClient.client_id = fromClientID;
            newClient.fb_client_id = fbIDfromInbox;
            newClient.fb_inbox_id = fbInboxID;
            newClient.type = @"F";
            newClient.name = fbNamefromInbox; // TEMPORAL
            newClient.preference = @"F";
            newClient.status = @"N";
            newClient.created_time = [NSDate date];
            
            NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
            [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
            newClient.last_interacted_time = [formatFBdates dateFromString:jsonArray[i][@"updated_time"]];;
            
            [clientMethods addNewClient:newClient];
            [newClientsArray addObject:newClient];
        }
        
        NSArray *jsonMessagesArray = jsonArray[i][@"comments"][@"data"];

        [self parseFBInboxComments:jsonMessagesArray withClientID:fromClientID];
        
        /*
        // Review if there are more comments from this chat
        
        NSString *next = jsonArray[i][@"comments"][@"paging"][@"next"];
        
        if (next && jsonMessagesArray.count>=25)
        {
            [self getFBInboxComments:[next substringFromIndex:32] withClientID:fromClientID];
        }
        */
    }
    
    // Get details for each new client found
    
    if (newClientsArray.count>0)
    {
        [self makeFBRequestForClientsDetails:newClientsArray];
    }

}


- (void) getFBInboxComments:(NSString *)url withClientID:(NSString *)fromClientID;
{
    [FBRequestConnection startWithGraphPath:url completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {  // FB request was a success!
             
             if (result[@"data"]) {   // There is FB data!
                 
                 NSArray *jsonMessagesArray = result[@"data"];
                 
                 [self parseFBInboxComments:jsonMessagesArray withClientID:fromClientID];
                 
                 // Review if there are more comments from this chat
                 
                 // EVALUAR SI TODOS LOS MENSAJES YA ESTAN REGISTRADOS PARA NO SEGUIR...!!!!
                 
                 NSString *next = result[@"paging"][@"next"];
                 
                 if (next && jsonMessagesArray.count>=25)
                 {
                     [self getFBInboxComments:[next substringFromIndex:32] withClientID:fromClientID];
                 }
             }
             
         } else {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error getFBInboxComments: %@", error.description);
         }
     }];
    
}

- (void) parseFBInboxComments:(NSArray *)jsonMessagesArray withClientID:(NSString *)fromClientID;
{
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    Client *tmpClient = [clientMethods getClientFromClientId:fromClientID];
    NSString *fbInboxID = tmpClient.fb_inbox_id;
    NSString *fbIDfromInbox = tmpClient.fb_client_id;
    NSString *fbNamefromInbox = [NSString stringWithFormat:@"%@ %@", tmpClient.name, tmpClient.last_name];

    // Add all messages from this conversation
    
    for (int i=0; i<jsonMessagesArray.count; i=i+1)
    {
        NSDictionary *newMessage = jsonMessagesArray[i];
        
        // Validate if the comment/message exists
        if (![messagesMethods existMessage:newMessage[@"id"]])
        {
            // New message!
            Message *tempMessage = [[Message alloc] init];
            
            tempMessage.fb_inbox_id = fbInboxID;
            tempMessage.fb_msg_id = newMessage[@"id"];
            tempMessage.fb_from_id = newMessage[@"from"][@"id"];
            tempMessage.fb_from_name = newMessage[@"from"][@"name"];
            tempMessage.client_id = fromClientID;
            tempMessage.message = newMessage[@"message"];
            
            tempMessage.fb_created_time = newMessage[@"created_time"];
            NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
            [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
            tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time];
            
            tempMessage.fb_photo_id = nil;
            tempMessage.product_id = nil;
            tempMessage.agent_id = @"00001";
            tempMessage.status = @"N";
            tempMessage.type = @"I";
            
            if ([tempMessage.fb_from_name hasPrefix:@"Garage"])
            {
                tempMessage.recipient = @"C";
                tempMessage.fb_from_id = fbIDfromInbox;
                tempMessage.fb_from_name = fbNamefromInbox;
            }
            else
            { tempMessage.recipient = @"G";}
            
            tempMessage.client_id = fromClientID;
            
            // Insert new message to array and add row to table
            [self addNewMessage:tempMessage];
            
        }
    }

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
        
        NSLog(@"%@ - %@: %@", newClient.fb_client_id, newClient.name, requestClientDetails);
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
                                      NSLog(@"error makeFBRequestForClientsDetails: %@", error.description);
                                  }
                              } ];
    }
}


- (void) addNewMessage:(Message*)newMessage;
{
    MessageModel *messageMethods = [[MessageModel alloc] init];
    ClientModel *clientMethods = [[ClientModel alloc] init];
    Client *tempClient = [[Client alloc] init];
    
    // Review if client has already added to table (as a chat)

    BOOL clientFound = NO;
    
    for (int i=0; i<_myDataClients.count; i=i+1)
    {
        tempClient = _myDataClients[i];
        
        if ([tempClient.client_id isEqualToString:newMessage.client_id] )
        {
            clientFound = YES;
            // Update last interaction time if so
            if (tempClient.last_interacted_time < newMessage.datetime)
            {
                tempClient.last_interacted_time = newMessage.datetime;
                [clientMethods updateClient:tempClient];
            }
            
            break;
        }
    }
    
    // Insert message to table array if the recipient is not already on the table
    if (!clientFound)
    {
        tempClient = [clientMethods getClientFromClientId:newMessage.client_id];
        [_myDataClients insertObject:tempClient atIndex:0];
    }
    
    // Update database
    [messageMethods addNewMessage:newMessage];
    
    // Sort array to be sure new messages are on top
    [_myDataClients sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Client*)a last_interacted_time];
        NSDate *second = [(Client*)b last_interacted_time];
        return [second compare:first];
    }];

    // Reload table
    [UIView transitionWithView:self.tableView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.tableView reloadData];
                    } completion:NULL];
    
}

@end
