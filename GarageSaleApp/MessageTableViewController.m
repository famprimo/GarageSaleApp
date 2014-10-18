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


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
                                      
                                      NSLog(@"ID de la foto: %@", result[photosArray[i]][@"id"]);
                                      
                                      /*
                                       Message *tempMessage;

                                       tempMessage.fb_from_id = result[tempMessage.fb_msg_id][@"from"][@"id"];
                                      tempMessage.fb_from_name = result[tempMessage.fb_msg_id][@"from"][@"name"];
                                      
                                      tempMessage = [[Message alloc] init];
                                      tempMessage = (Message *)messagesArray[i];
                                   
                                      tempMessage = [[Message alloc] init];
                                      tempMessage.fb_notif_id = newMessage[@"id"];
                                      tempMessage.fb_link = newMessage[@"link"];
                                      tempMessage.fb_created_time = newMessage[@"created_time"];
                                      
                                      NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
                                      [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
                                      tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time];
                                      
                                      NSMutableString *msgIDfromLink = [[NSMutableString alloc] init];
                                      
                                      [msgIDfromLink appendString:[messagesMethods getPhotoID:tempMessage.fb_link]];
                                      tempMessage.fb_photo_id = msgIDfromLink;
                                      
                                      [msgIDfromLink appendString:@"_"];
                                      
                                      [msgIDfromLink appendString:[messagesMethods getCommentID:tempMessage.fb_link]];
                                      
                                      tempMessage.fb_msg_id = msgIDfromLink;
                                   

                                      
                                      // Insert new message to array and add row to table
                                      [self addNewMessage:tempMessage];
                                      */
                                      
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
    // Insert message to Array
    [_myData insertObject:newMessage atIndex:0];
    
    // Sort array to be sure new messages are on top
    [_myData sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Message*)a datetime];
        NSDate *second = [(Message*)b datetime];
        return [second compare:first];
        //return [first compare:second];
    }];
    
    // Update database
    
    // Reload table
    [self.tableView reloadData];
    
}

/*
 
 - (void) makeFBRequestForNewNotifications:(NSMutableArray*)messagesArray;
 {
 [FBRequestConnection startWithGraphPath:@"me/notifications?fields=application,link&include_read=true"
 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
 
 if (!error) {  // FB request was a success!
 
 if (result[@"data"]) {   // There is FB data!
 
 NSArray *jsonArray = result[@"data"];
 NSMutableArray *newMessagesArray = [[NSMutableArray alloc] init];
 
 // Get new notifactions
 newMessagesArray = [self getNewNotifications:jsonArray withMessagesArray:messagesArray];
 
 if (newMessagesArray.count >0) { // New Messages!
 
 // Get message details for those notifications
 [self makeFBRequestForMessageDetails:newMessagesArray];
 
 }
 
 }
 
 } else {
 // An error occurred, we need to handle the error
 // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
 NSLog(@"error %@", error.description);
 }
 }];
 
}
 
- (NSMutableArray*)getNewNotifications:(NSArray*)arrayResultsData withMessagesArray:(NSMutableArray*)messageList;
{
    // Method that takes the result of a call to FB and return the new notifications
 
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
 
    Message *tempMessage = [[Message alloc] init];
    MessageModel *messagesMethods = [[MessageModel alloc] init];
 
    // Look for "Photos" notifications
 
    for (int i=0; i<arrayResultsData.count; i=i+1)
    {
        NSDictionary *newMessage = arrayResultsData[i];
 
        if ([newMessage[@"application"][@"name"] isEqual: @"Photos"]) {
 
            if (![messagesMethods existNotification:newMessage[@"id"] withMessagesArray:messageList]) {
                // It's a new notification!
 
                tempMessage = [[Message alloc] init];
                tempMessage.fb_notif_id = newMessage[@"id"];
                tempMessage.fb_link = newMessage[@"link"];
                tempMessage.fb_created_time = newMessage[@"created_time"];
                
                NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
                [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
                tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time];
                
                NSMutableString *msgIDfromLink = [[NSMutableString alloc] init];
                
                [msgIDfromLink appendString:[messagesMethods getPhotoID:tempMessage.fb_link]];
                tempMessage.fb_photo_id = msgIDfromLink;
                
                [msgIDfromLink appendString:@"_"];
                
                [msgIDfromLink appendString:[messagesMethods getCommentID:tempMessage.fb_link]];
                
                tempMessage.fb_msg_id = msgIDfromLink;
                
                // Add new message object
                [messagesArray addObject:tempMessage];
                
            }
        }
    }
    
    return messagesArray;
    
}

- (void) makeFBRequestForMessageDetails:(NSMutableArray*)messagesArray;
{
    
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    
    // Create string for FB request
    NSMutableString *requestMessagesList = [[NSMutableString alloc] init];
    [requestMessagesList appendString:@"?ids="];
    [requestMessagesList appendString:[messagesMethods getMessagesIDs:messagesArray]];
    
    // Make FB request
    [FBRequestConnection startWithGraphPath:requestMessagesList
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error) { // FB request was a success!
                                  
                                  Message *tempMessage;
                                  
                                  // Get details and create array
                                  for (int i=0; i<messagesArray.count; i=i+1)
                                  {
                                      tempMessage = [[Message alloc] init];
                                      tempMessage = (Message *)messagesArray[i];
                                      
                                      tempMessage.message = result[tempMessage.fb_msg_id][@"message"];
                                      tempMessage.fb_from_id = result[tempMessage.fb_msg_id][@"from"][@"id"];
                                      tempMessage.fb_from_name = result[tempMessage.fb_msg_id][@"from"][@"name"];
                                      
                                      // Insert new message to array and add row to table
                                      [self addNewMessage:tempMessage];
                                      
                                  }
                                  
                              }
                              else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          } ];
    
}
 */


@end
