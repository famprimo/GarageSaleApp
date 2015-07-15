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
#import "Settings.h"
#import "SettingsModel.h"
#import "Message.h"
#import "MessageModel.h"
#import "Client.h"
#import "ClientModel.h"
#import "Product.h"
#import "ProductModel.h"
#import "Attachment.h"
#import "AttachmentModel.h"
#import "NSDate+NVTimeAgo.h"
#import "NS-Extensions.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MessagesTableViewController ()
{
    // Data for the table
    NSMutableArray *_myDataClients;
    
    // Data for the search
    NSMutableArray *_mySearchData;
    
    // The message that is selected from the table
    Client *_selectedClientBox;
 
    NSDate *_messagesSinceDate;
    
    // Temp variables for user and page IDs
    Settings *_tmpSettings;
}
// For Popover
@property (nonatomic, strong) UIPopoverController *messagesSincePopover;

@end


@implementation MessagesTableViewController

@synthesize clientSearchBar;


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
    _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
    
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
    // Make all Facebook requests
    
    [self makeFBrequests];
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


#pragma mark Content Filtering & UISearchDisplayController Delegate Methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Remove all objects from the filtered search array
    [_mySearchData removeAllObjects];
    NSArray *tempArray;
    
    // Filter the array using the search text
    if (![searchText isEqualToString:@""])
    {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(name contains[c] %@) OR (last_name contains[c] %@)", searchText, searchText];
        tempArray = [_myDataClients filteredArrayUsingPredicate:resultPredicate];
    }
    else
    {
        tempArray = [NSArray arrayWithArray:_myDataClients];
    }
    
    _mySearchData = [NSMutableArray arrayWithArray:tempArray];
    
}

-(void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
    // Remove all objects from the filtered search array
    NSArray *tempArray;
    
    if (_mySearchData == nil)
    {
        tempArray = [NSMutableArray arrayWithArray:_myDataClients];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _mySearchData.count;
        
    } else {
        return _myDataClients.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ProductModel *productMethods = [[ProductModel alloc] init];
    Product *productRelatedToMessage = [[Product alloc] init];
    
    MessageModel *messageMethods = [[MessageModel alloc] init];
    Message *lastMessageFromClient = [[Message alloc] init];
    
    // Retrieve cell
    UITableViewCell *myCell;
    Client *myClient = [[Client alloc] init];
    
    // Get the client to be shown
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        myCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        myClient = _mySearchData[indexPath.row];;
    } else {
        myCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        myClient = _myDataClients[indexPath.row];
    }
    
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
            if ([lastMessageFromClient.fb_from_id isEqualToString:_tmpSettings.fb_user_id])
            {
                // Message from GarageSale user
                messageLabel.text = [NSString stringWithFormat:@"%@: %@", _tmpSettings.fb_user_name, lastMessageFromClient.message];
            }
            else
            {
                // Message from GarageSale page
                messageLabel.text = [NSString stringWithFormat:@"%@: %@", _tmpSettings.fb_page_name, lastMessageFromClient.message];
            }
        }
        datetimeLabel.text = [lastMessageFromClient.datetime formattedAsTimeAgo];

    }
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected listing to var
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _selectedClientBox = _mySearchData[indexPath.row];
    } else {
        _selectedClientBox = _myDataClients[indexPath.row];
    }

    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedClientBox];
}


#pragma mark - Contact with Facebook

- (void) makeFBrequests;
{
    [self makeFBRequestForNewNotifications];
    
    [self makeFBRequestForNewInbox];
    
    [self makeFBRequestForPageMessages];
}

- (void) makeFBRequestForNewNotifications;
{
    // Create string for FB request - Notifications for the Page
    
    if (![_tmpSettings.fb_page_id isEqualToString:@""])
    {
        NSString *url = [NSString stringWithFormat:@"%@/notifications?fields=application,link,object&include_read=true&since=%ld", _tmpSettings.fb_page_id, (long)[_messagesSinceDate timeIntervalSince1970]];;
        
        [self getFBNotifications:url];
    }
    else
    {
        [self setFacebookPageID];
        
        _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
    }
}

- (void) getFBNotifications:(NSString*)url;
{
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"manage_pages"])
    {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil tokenString:_tmpSettings.fb_page_token version:@"v2.0" HTTPMethod:@"GET"];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             
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
            // Optional: take from [@"object"][@"id"]
            
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
    if ([FBSDKAccessToken currentAccessToken])
    {
        // Prepare for FB request
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:requestPhotosList parameters:nil];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
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
                             newProduct.codeGS = [NSString stringWithFormat:@"GSN%@", tmpText];
                             newProduct.type = @"A";
                             
                         }
                         else
                         {
                             tmpText = [productMethods getTextThatFollows:@"GS" fromMessage:newProduct.desc];
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
                         
                         tmpText = [productMethods getTextThatFollows:@"s/. " fromMessage:newProduct.desc];
                         if (![tmpText isEqualToString:@"Not Found"]) {
                             tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
                             newProduct.currency = @"S/.";
                             newProduct.price = [NSNumber numberWithFloat:[tmpText integerValue]];
                         }
                         else
                         {
                             tmpText = [productMethods getTextThatFollows:@"USD " fromMessage:newProduct.desc];
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
                         newProduct.created_time = [formatFBdates dateFromString:result[photosArray[i]][@"created_time"]];
                         newProduct.updated_time = [formatFBdates dateFromString:result[photosArray[i]][@"updated_time"]];
                         newProduct.fb_updated_time = [formatFBdates dateFromString:result[photosArray[i]][@"updated_time"]];
                         
                         newProduct.picture_link = result[photosArray[i]][@"picture"];
                         newProduct.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:newProduct.picture_link]];
                         newProduct.additional_pictures = @"";
                         newProduct.status = @"N";
                         newProduct.promotion_piority = @"2";
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
                             tempMessage.attachments = @"N";
                             tempMessage.agent_id = @"00001";
                             tempMessage.type = @"P";
                             
                             NSLog(@"%@ : %@", tempMessage.fb_from_name, [FBSDKProfile currentProfile].name);
                             
                             if ([tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_user_id] || [tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_page_id])
                             {
                                 // Is a message from GarageSale!
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
                                 newClient.fb_inbox_id = @"";
                                 newClient.fb_page_message_id = @"";
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
             
         }];
    }
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
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url
                                                                   parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
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
    }];
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
            tempMessage.attachments = @"N";
            tempMessage.agent_id = @"00001";
            tempMessage.type = @"P";
            
            NSLog(@"%@ : %@", tempMessage.fb_from_name, [FBSDKProfile currentProfile].name);

            if ([tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_user_id] || [tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_page_id])
            {
                // Is a message from GarageSale
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
                    newClient.fb_inbox_id = @"";
                    newClient.fb_page_message_id = @"";
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

}

- (void) getFBInbox:(NSString*)url;
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url
                                                                   parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
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
    Client *tmpClient;
    
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
        
        NSLog(@"%@ : %@", fbNamefromInbox, [FBSDKProfile currentProfile].name);

        // Make sure it takes the ID and name of the client, not of GarageSale
        if ([fbIDfromInbox isEqualToString:_tmpSettings.fb_user_id] || [fbIDfromInbox isEqualToString:_tmpSettings.fb_page_id])
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
            newClient.fb_page_message_id =  @"";
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
        
        // Review if inboxID is updated
        tmpClient = [[Client alloc] init];
        tmpClient = [clientMethods getClientFromClientId:fromClientID];
        
        if (![tmpClient.fb_inbox_id isEqualToString:fbInboxID])
        {
            // InboxID is differente... update with the actual
            tmpClient.fb_inbox_id = fbInboxID;
            [clientMethods updateClient:tmpClient];
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
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url
                                                                   parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
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
            tempMessage.attachments = @"N";
            tempMessage.agent_id = @"00001";
            tempMessage.status = @"N";
            tempMessage.type = @"I";
            
            NSLog(@"%@ : %@", tempMessage.fb_from_name, [FBSDKProfile currentProfile].name);
            
            if ([tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_user_id] || [tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_page_id])
            {
                // Message from GarageSale
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

- (void) makeFBRequestForPageMessages;
{
    if (![_tmpSettings.fb_page_id isEqualToString:@""])
    {
        NSString *url = [NSString stringWithFormat:@"%@/conversations?fields=id,participants,updated_time,messages&since=%ld", _tmpSettings.fb_page_id, (long)[_messagesSinceDate timeIntervalSince1970]];;
        
        [self getFBPageMessages:url];
    }
    else
    {
        [self setFacebookPageID];
        
        _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
    }
}

- (void) getFBPageMessages:(NSString*)url;
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"manage_pages"])
    {
        // Prepare for FB request
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil tokenString:_tmpSettings.fb_page_token version:@"v2.0" HTTPMethod:@"GET"];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error) {  // FB request was a success!
                 
                 if (result[@"data"]) {   // There is FB data!
                     
                     [self parseFBPageMessages:result];
                     
                     // Review is there is a next page
                     // skip the beginning of the url https://graph.facebook.com/
                     
                     NSString *next = result[@"paging"][@"next"];
                     if (next)
                     {
                         [self getFBPageMessages:[next substringFromIndex:32]];
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
                 NSLog(@"error getFBPageMessages: %@", error.description);
             }
         }];
    }
}

- (void) parseFBPageMessages:(id)result;
{
    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    Client *tmpClient;
    
    NSMutableArray *newClientsArray = [[NSMutableArray alloc] init];
    
    NSString *fbIDfromInbox;
    NSString *fbNamefromInbox;
    NSString *fbPageMessageID;
    
    // Review each chat
    
    NSArray *jsonArray = result[@"data"];
    
    
    for (int i=0; i<jsonArray.count; i=i+1)
    {
        fbPageMessageID = jsonArray[i][@"id"];
        fbNamefromInbox = jsonArray[i][@"participants"][@"data"][0][@"name"];
        fbIDfromInbox = jsonArray[i][@"participants"][@"data"][0][@"id"];
        
        // Make sure it takes the ID and name of the client, not of GarageSale
        if ([fbIDfromInbox isEqualToString:_tmpSettings.fb_user_id] || [fbIDfromInbox isEqualToString:_tmpSettings.fb_page_id])
        {
            fbNamefromInbox = jsonArray[i][@"participants"][@"data"][1][@"name"];
            fbIDfromInbox = jsonArray[i][@"participants"][@"data"][1][@"id"];
        }
        
        NSLog(@"%@ : %@", fbNamefromInbox, [FBSDKProfile currentProfile].name);

        // Review if client exists
        NSString *fromClientID = [clientMethods getClientIDfromFbId:fbIDfromInbox];
        
        if ([fromClientID  isEqual: @"Not Found"])
        {
            // New client!
            
            Client *newClient = [[Client alloc] init];
            
            fromClientID = [clientMethods getNextClientID];
            newClient.client_id = fromClientID;
            newClient.fb_client_id = fbIDfromInbox;
            newClient.fb_inbox_id = @"";
            newClient.fb_page_message_id = fbPageMessageID;
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
        
        // Review if pageMessageID is updated
        tmpClient = [[Client alloc] init];
        tmpClient = [clientMethods getClientFromClientId:fromClientID];
        
        if (![tmpClient.fb_page_message_id isEqualToString:fbPageMessageID])
        {
            // InboxID is differente... update with the actual
            tmpClient.fb_page_message_id = fbPageMessageID;
            [clientMethods updateClient:tmpClient];
        }

        
        NSArray *jsonMessagesArray = jsonArray[i][@"messages"][@"data"];
        
        [self parseFBPageMessagesComments:jsonMessagesArray withClientID:fromClientID];
        
        /*
         // Review if there are more comments from this chat
         
         NSString *next = jsonArray[i][@"messages"][@"paging"][@"next"];
         
         if (next && jsonMessagesArray.count>=25)
         {
         [self getFBPageMessagesComments:[next substringFromIndex:32] withClientID:fromClientID];
         }
         */
    }
    
    // Get details for each new client found
    
    if (newClientsArray.count>0)
    {
        [self makeFBRequestForClientsDetails:newClientsArray];
    }
    
}

- (void) getFBPageMessagesComments:(NSString *)url withClientID:(NSString *)fromClientID;
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil tokenString:_tmpSettings.fb_page_token version:@"v2.0" HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {  // FB request was a success!
             
             if (result[@"data"]) {   // There is FB data!
                 
                 NSArray *jsonMessagesArray = result[@"data"];
                 
                 [self parseFBPageMessagesComments:jsonMessagesArray withClientID:fromClientID];
                 
                 // Review if there are more comments from this chat
                 
                 // EVALUAR SI TODOS LOS MENSAJES YA ESTAN REGISTRADOS PARA NO SEGUIR...!!!!
                 
                 NSString *next = result[@"paging"][@"next"];
                 
                 if (next && jsonMessagesArray.count>=25)
                 {
                     [self getFBPageMessagesComments:[next substringFromIndex:32] withClientID:fromClientID];
                 }
             }
             
         } else {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error getFBPageMessagesComments: %@", error.description);
         }
     }];
}

- (void) parseFBPageMessagesComments:(NSArray *)jsonMessagesArray withClientID:(NSString *)fromClientID;
{
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    Client *tmpClient = [clientMethods getClientFromClientId:fromClientID];
    NSString *fbInboxID = tmpClient.fb_inbox_id;
    NSString *fbPageMessageID = tmpClient.fb_page_message_id;
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
            
            // Review if there are attachments
            if (newMessage[@"attachments"])
            { tempMessage.attachments = @"Y"; }
            else { tempMessage.attachments = @"N"; }
            
            tempMessage.agent_id = @"00001";
            tempMessage.status = @"N";
            tempMessage.type = @"M"; // Page message!
            
            NSLog(@"%@ : %@", tempMessage.fb_from_name, [FBSDKProfile currentProfile].name);
            
            if ([tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_user_id] || [tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_page_id])
            {
                // Message from GarageSale
                tempMessage.recipient = @"C";
                tempMessage.fb_from_id = fbIDfromInbox;
                tempMessage.fb_from_name = fbNamefromInbox;
            }
            else
            { tempMessage.recipient = @"G";}
            
            tempMessage.client_id = fromClientID;
            
            // Insert new message to array and add row to table
            [self addNewMessage:tempMessage];
            
            // If there are attachments, include them
            if ([tempMessage.attachments isEqualToString:@"Y"])
            {
                NSMutableArray *attachmentsArray = newMessage[@"attachments"][@"data"];
                [self parseFBMessageAttachments:attachmentsArray for:tempMessage];
            }
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
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:requestClientDetails
                                                                       parameters:nil];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
        {
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
                //[clientMethods addNewClient:newClient];
                
            }
            else {
                // An error occurred, we need to handle the error
                // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                NSLog(@"error makeFBRequestForClientsDetails: %@", error.description);
            }
        }];
    }
}

- (void) parseFBMessageAttachments:(NSMutableArray*)attachmentsArray for:(Message*)containerMessage;
{
    AttachmentModel *attachmentMethods = [[AttachmentModel alloc] init];
    Attachment *tempAttachment = [[Attachment alloc] init];
    
    // Add all messages from this conversation
    
    for (int i=0; i<attachmentsArray.count; i=i+1)
    {
        NSDictionary *newAttachment = attachmentsArray[i];
        tempAttachment = [[Attachment alloc] init];

        tempAttachment.fb_msg_id = containerMessage.fb_msg_id;
        tempAttachment.fb_attachment_id = newAttachment[@"id"];
        tempAttachment.client_id = containerMessage.client_id;
        tempAttachment.datetime = containerMessage.datetime;
        tempAttachment.fb_name = newAttachment[@"name"];
        tempAttachment.picture_link = newAttachment[@"image_data"][@"url"];
        tempAttachment.preview_link = newAttachment[@"image_data"][@"preview_url"];
        tempAttachment.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempAttachment.picture_link]];
        tempAttachment.agent_id = @"00001";
        
        [attachmentMethods addNewAttachment:tempAttachment];
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
