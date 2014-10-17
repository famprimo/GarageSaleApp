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
    NSMutableArray *newMessagesArray = [[NSMutableArray alloc] init];
    newMessagesArray = [self makeFBRequestForNewNotifications:_myData];

    NSLog(@"Array!");
    // [_myData addObjectsFromArray:newMessagesArray];
    
    
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
    
    // Set table cell labels to listing data
    nameLabel.text = myMessage.fb_from_name;
    messageLabel.text = myMessage.message;
    
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

- (NSMutableArray*) makeFBRequestForNewNotifications:(NSMutableArray*)messagesArray;
{
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    NSMutableArray *newMessagesArrayFinal = [[NSMutableArray alloc] init];
    
    [FBRequestConnection startWithGraphPath:@"me/notifications?fields=application,link&include_read=true"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error) {  // FB request was a success!
                                  
                                  if (result[@"data"]) {   // There is FB data!
                                      
                                      NSArray *jsonArray = result[@"data"];
                                      NSMutableArray *newMessagesArray = [[NSMutableArray alloc] init];
                                      
                                      // Get new notifactions
                                      newMessagesArray = [messagesMethods getNewNotifications:jsonArray withMessagesArray:messagesArray];
                                      
                                      // Get message details for those notifications
                                      newMessagesArray = [self makeFBRequestForMessageDetails:newMessagesArray];
                                      
                                     // Sorting arrays
                                      NSArray *sortedArray;
                                      sortedArray = [newMessagesArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                                          NSDate *first = [(Message*)a datetime];
                                          NSDate *second = [(Message*)b datetime];
                                          return [first compare:second];
                                      }];
                                      
                                      [newMessagesArrayFinal addObjectsFromArray:sortedArray];
                                      
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
    
    return newMessagesArrayFinal;
}

- (NSMutableArray*) makeFBRequestForMessageDetails:(NSMutableArray*)messagesArray;
{
    
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    NSMutableArray *updatedMessagesArray = [[NSMutableArray alloc] init];
    
    // Create string for FB request
    NSMutableString *requestMessagesList = [[NSMutableString alloc] init];
    [requestMessagesList appendString:@"?ids="];
    [requestMessagesList appendString:[messagesMethods getMessagesIDs:messagesArray]];
    
    // NSLog(@"request para FB: %@", requestMessagesList);
    
    [FBRequestConnection startWithGraphPath:requestMessagesList
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error) { // FB request was a success!
                                  
                                  Message *tempMessage;
                                  
                                  for (int i=0; i<messagesArray.count; i=i+1)
                                  {
                                      tempMessage = [[Message alloc] init];
                                      tempMessage = (Message *)messagesArray[i];
                                      
                                      tempMessage.message = result[tempMessage.fb_msg_id][@"message"];
                                      tempMessage.fb_from_id = result[tempMessage.fb_msg_id][@"from"][@"id"];
                                      tempMessage.fb_from_name = result[tempMessage.fb_msg_id][@"from"][@"name"];
                                      
                                      [updatedMessagesArray addObject:tempMessage];
                                      
                                      /// LLAMAR A UN METODO QUE AGREGUE LOS NUEVOS MENSAJES!!!
                                  }
                                  
                              }
                              else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          } ];
    
    return updatedMessagesArray;
}

@end
