//
//  MessagesTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 06/02/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "SWRevealViewController.h"
#import "Settings.h"
#import "SettingsModel.h"
#import "Message.h"
#import "MessageModel.h"
#import "Client.h"
#import "Product.h"
#import "Attachment.h"
#import "AttachmentModel.h"
#import "NSDate+NVTimeAgo.h"
#import "NS-Extensions.h"

// #import <FBSDKCoreKit/FBSDKCoreKit.h>
// #import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MessagesTableViewController ()
{
    // Data for the table
    NSMutableArray *_myDataClients;
    
    // Data for the search
    NSMutableArray *_mySearchData;
    
    // The message that is selected from the table
    Client *_selectedClientBox;
 
    // For managing the since date
    NSDate *_messagesSinceDate;
    
    // Temp variables for user and page IDs
    Settings *_tmpSettings;
    
    // Objects for delegate methods
    ClientModel *_clientMethods;
    ProductModel *_productMethods;
    FacebookMethods *_facebookMethods;
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
    
    self.detailViewController = (MessagesDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];
    self.detailViewController.delegate = self;

    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Initialize objects methods
    _facebookMethods = [[FacebookMethods alloc] init];
    _facebookMethods.delegate = self;
    
    _clientMethods = [[ClientModel alloc] init];
    _clientMethods.delegate = self;
    
    _productMethods = [[ProductModel alloc] init];
    _productMethods.delegate = self;
    
    // Get the data
    _myDataClients = [_clientMethods getClientArray];
    _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
    
    // Add title and menu button
    [self updateTableTitle];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    [self defineSetupButtonImage];
    
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

- (void)defineSetupButtonImage;
{
    UIBarButtonItem *menuButtonSetup;
    Settings *currentSettings = [[[SettingsModel alloc] init] getSharedSettings];
    
    if ([currentSettings.since_date isEqualToString:@"1D"])
    {
        menuButtonSetup = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MsgSince1D"] makeThumbnailOfSize:CGSizeMake(20, 20)] style:UIBarButtonItemStylePlain target:self action:@selector(setupButtonClicked:)];
    }
    else if ([currentSettings.since_date isEqualToString:@"1S"])
    {
        menuButtonSetup = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MsgSince1S"] makeThumbnailOfSize:CGSizeMake(20, 20)] style:UIBarButtonItemStylePlain target:self action:@selector(setupButtonClicked:)];
    }
    else if ([currentSettings.since_date isEqualToString:@"1M"])
    {
        menuButtonSetup = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MsgSince1M"] makeThumbnailOfSize:CGSizeMake(20, 20)] style:UIBarButtonItemStylePlain target:self action:@selector(setupButtonClicked:)];
    }
    else
    {
        menuButtonSetup = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MsgSince6M"] makeThumbnailOfSize:CGSizeMake(20, 20)] style:UIBarButtonItemStylePlain target:self action:@selector(setupButtonClicked:)];
    }

    menuButtonSetup.width = 40;
    self.navigationItem.rightBarButtonItem = menuButtonSetup;
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
    self.messagesSincePopover.popoverContentSize = CGSizeMake(180.0, 200.0);
    [self.messagesSincePopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void)refreshTableGesture:(id)sender
{
    // Refresh table... First sync Clients
    
    [_clientMethods syncCoreDataWithParse];
}

- (void)updateTableTitle
{
    NSString *tableTitle = [[NSString alloc] init];
    
    MessageModel *messageMethods = [[MessageModel alloc] init];
    
    int numberOfMessagesToDisplay = [messageMethods numberOfUnreadMessages];
    
    if (numberOfMessagesToDisplay == 0)
    {
        tableTitle = @"Mensajes";
    }
    else
    {
        tableTitle = [NSString stringWithFormat:@"Mensajes (%i)", numberOfMessagesToDisplay];
    }
    
    self.navigationItem.title = tableTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Detail View Controller delegate methods

-(void)messagesUpdated;
{
    [self updateTableTitle];
    [self.tableView reloadData];
}


#pragma mark MessageSinceViewController delegate methods

-(void)sinceDateSelected;
{
    // Change button icon
    [self defineSetupButtonImage];
    
    // Dismiss the popover view
    [self.messagesSincePopover dismissPopoverAnimated:NO];
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

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
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
    UILabel *unreadMessages = (UILabel*)[myCell.contentView viewWithTag:7];
    
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

    CGRect messageLabelFrame = messageLabel.frame;
    messageLabelFrame.origin.x = 63;
    messageLabelFrame.size.width = 245;
    messageLabel.frame = messageLabelFrame;

    CGRect unreadMessagesFrame = unreadMessages.frame;
    unreadMessagesFrame.origin.x = 285;
    unreadMessagesFrame.size.width = 30;
    unreadMessages.frame = unreadMessagesFrame;

    
    // Client image, name and status
    clientImage.image = [UIImage imageWithData:[_clientMethods getClientPhotoFrom:myClient]];
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
    
    if ([myClient.replied isEqualToString:@"Y"])
    {
        myCell.backgroundColor = [UIColor clearColor];
    }
    else
    {
        myCell.backgroundColor = [UIColor colorWithRed:231/255.0f green:240/255.0f blue:250/255.0f alpha:1.0f];
    }

    // Message info
    lastMessageFromClient = [messageMethods getMessageFromMessageId:myClient.last_msg_id];
    
    if (lastMessageFromClient == nil)
    {
        productImage.hidden = YES;
        messageLabel.frame = messageLabelFrame;
        datetimeLabel.text = [myClient.last_interacted_time formattedAsTimeAgo];
        unreadMessages.hidden = YES;
        if ([myClient.replied isEqualToString:@"Y"])
        {
            messageLabel.text = @"No hay mensajes";
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.font = [UIFont systemFontOfSize:12];
        }
        else
        {
            messageLabel.text = @"No se han cargado los mensajes";
            nameLabel.textColor = [UIColor blueColor];
            nameLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    else
    {
        CGRect messageLabelFrame = messageLabel.frame;
        int numberOfUnreadMessages = [messageMethods numberOfUnreadMessagesForClient:myClient.client_id];
        
        if (numberOfUnreadMessages == 0)
        {
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.font = [UIFont systemFontOfSize:12];
            unreadMessages.hidden = YES;
        }
        else  // @"N"
        {
            // There are unread messages
            nameLabel.textColor = [UIColor blueColor];
            nameLabel.font = [UIFont systemFontOfSize:12];

            unreadMessages.hidden = NO;
            unreadMessages.text = [NSString stringWithFormat:@" %i ", numberOfUnreadMessages];
            [unreadMessages sizeToFit];
            unreadMessages.layer.cornerRadius = 7;
            unreadMessages.clipsToBounds = YES;
            messageLabelFrame.size.width = 212;
        }
        
        if ([lastMessageFromClient.type isEqualToString:@"P"])
        {
            productImage.hidden = NO;
            productRelatedToMessage = [_productMethods getProductFromProductId:lastMessageFromClient.product_id];
            productImage.image = [UIImage imageWithData:[_productMethods getProductPhotoFrom:productRelatedToMessage]];
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


#pragma mark - ClientModel delegate methods

-(void)clientsSyncedWithCoreData:(BOOL)succeed;
{
    if (succeed)
    {
        // Clients synced, now sync products
        
        [_productMethods syncCoreDataWithParse];
    }
    else
    {
        [self.refreshControl endRefreshing];
    }
}

-(void)clientAddedOrUpdated:(BOOL)succeed;
{
    // No need to implement
}


#pragma mark - ProductModel delegate methods

-(void)productsSyncedWithCoreData:(BOOL)succeed;
{
    if (succeed)
    {
        // Clients and product synced so call FB methods
        
        _messagesSinceDate = [[[SettingsModel alloc] init] getSinceDate];
        
        [_facebookMethods initializeMethods];
        
        [_facebookMethods getFBPageNotifications:_messagesSinceDate];
    }
    else
    {
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        [self updateTableTitle];
    }
}

-(void)productAddedOrUpdated:(BOOL)succeed;
{
    // No need to implement
}


#pragma mark - FacebookMethods delegate methods

-(void)finishedGettingFBpageNotifications:(BOOL)succeed;
{
    if (succeed)
    {
        [_facebookMethods getFBPageMessages:_messagesSinceDate];
    }
    else
    {
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        [self updateTableTitle];
    }
}

-(void)finishedGettingFBInbox:(BOOL)succeed;
{
    // No Inbox asked!
}

-(void)finishedGettingFBPageMessages:(BOOL)succeed;
{
    // It doesn't matter if succeed as it might have inserted new clients from PageNotifications
    
    [_facebookMethods insertNewClientsFound];
}

-(void)finishedInsertingNewClientsFound:(BOOL)succeed;
{
    [self.refreshControl endRefreshing];
    
    // Reload table to make sure all clients (chats) are included
    
    _myDataClients = [[NSMutableArray alloc] init];
    
    _myDataClients = [_clientMethods getClientArray];
    
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

    [self updateTableTitle];
}

-(void)newMessageAddedFromFB:(Message*)messageAdded;
{
    // EVALUATE IF NEEDED!!!!!
}

-(void)finishedGettingFBPhotos:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedGettingFBPhotoComments:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedSendingFBPageMessage:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedSendingFBPhotoMessage:(BOOL)succeed;
{
    // No need to implement
}

@end
