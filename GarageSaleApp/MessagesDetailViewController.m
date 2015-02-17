//
//  MessagesDetailViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 06/02/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "MessagesDetailViewController.h"
#import "Message.h"
#import "Product.h"
#import "ProductModel.h"
#import "Client.h"
#import "ClientModel.h"
#import "Opportunity.h"
#import "OpportunityModel.h"
#import "NSDate+NVTimeAgo.h"

@interface MessagesDetailViewController ()
{
    // Data for the tables
    NSMutableArray *_myDataMessages;
    NSMutableArray *_myDataOpportunities;
    
    Client *_clientRelatedToMessage;
    // /For the selections in the tables
    Message *_selectedMessage;
    NSInteger _messageRowHeight;
    
    NSString *_templateTypeForPopover;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *clientPickerPopover;
@property (nonatomic, strong) UIPopoverController *sendMessagePopover;
@property (nonatomic, strong) UIPopoverController *createOpportunityPopover;

@end


@implementation MessagesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableMessages.delegate = self;
    self.tableMessages.dataSource = self;
    
    // self.tableOpportunities.delegate = self;
    // self.tableOpportunities.dataSource = self;
    
    // Update the view
    [self configureView];
    
    _messageRowHeight = 80;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        // Asign values to objects in View
        
        MessageModel *messageMethods = [[MessageModel alloc] init];
        Message *messageSelected = [[Message alloc] init];
        messageSelected = (Message *)_detailItem;
        
        ClientModel *clientMethods = [[ClientModel alloc] init];
        Client *ownerRelatedToMessage = [[Client alloc] init];
        
        OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];
        
        _clientRelatedToMessage = [clientMethods getClientFromClientId:messageSelected.client_id];
        
        
        // Load messsages from the same client
        _myDataMessages = [messageMethods getMessagesArrayFromClient:_clientRelatedToMessage.client_id];
        [self.tableMessages reloadData];
        
        // Sort array to be sure new messages are on top
        [_myDataMessages sortUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(Message*)a datetime];
            NSDate *second = [(Message*)b datetime];
            return [first compare:second];
            }];

        int lastRowNumber = [self.tableMessages numberOfRowsInSection:0] - 1;
        NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.tableMessages scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];

        _selectedMessage = [[Message alloc] init];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _messageRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tableMessages) // Messages Table
    {
        return _myDataMessages.count;
    }
    else  // Opportunities Table
    {
        return _myDataOpportunities.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableMessages) // Messages Table
    {
        ProductModel *productMethods = [[ProductModel alloc] init];
        Product *productRelatedToMessage = [[Product alloc] init];
        
        // Retrieve cell
        NSString *cellIdentifier = @"Cell";
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Get the message to be shown
        Message *myMessage = _myDataMessages[indexPath.row];
        
        // Get references to images and labels of cell
        UIImageView *clientImage = (UIImageView*)[myCell.contentView viewWithTag:1];
        UILabel *messageLabel = (UILabel*)[myCell.contentView viewWithTag:2];
        UIImageView *productImage = (UIImageView*)[myCell.contentView viewWithTag:3];
        UILabel *datetimeLabel = (UILabel*)[myCell.contentView viewWithTag:4];
        
        // Set client picture
        if ([myMessage.recipient isEqualToString:@"G"])
        {
            clientImage.image = [UIImage imageWithData:_clientRelatedToMessage.picture];
        }
        else
        {
            clientImage.image = [UIImage imageNamed:@"GarageSale"];
        }
        
        // Make client picture rounded
        clientImage.layer.cornerRadius = clientImage.frame.size.width / 2;
        clientImage.clipsToBounds = YES;
        
        
        // Set message date time
        CGRect datetimeLabelFrame = datetimeLabel.frame;
        datetimeLabelFrame.size.width = 200;
        datetimeLabel.frame = datetimeLabelFrame;

        datetimeLabel.text = [myMessage.datetime formattedAsTimeAgo];
        [datetimeLabel sizeToFit];

        
        // Set message text
        
        CGRect messageLabelFrame = messageLabel.frame;
        messageLabelFrame.size.width = 230;
        
        // Set image for product or message
        if ([myMessage.type isEqualToString:@"P"])
        {
            productRelatedToMessage = [productMethods getProductFromProductId:myMessage.product_id];
            productImage.image = [UIImage imageWithData:productRelatedToMessage.picture];
            
            // Change width of the message text if there is an image
            messageLabelFrame.size.width = messageLabelFrame.size.width - 45;
        }
        else
        {
            productImage.image = [UIImage imageNamed:@"Blank"];
        }
        messageLabel.frame = messageLabelFrame;

        messageLabel.text = myMessage.message;
        messageLabel.numberOfLines = 0;
        [messageLabel sizeToFit];

        
        // Define position of objects depending on the recipient
        
        if ([myMessage.recipient isEqualToString:@"G"])
        {
            CGRect clientImageFrame = clientImage.frame;
            clientImageFrame.origin.x = 5;
            clientImageFrame.origin.y = 5;
            clientImageFrame.size.width = 30;
            clientImageFrame.size.height = 30;
            clientImage.frame = clientImageFrame;
            
            messageLabelFrame = messageLabel.frame;
            if ([myMessage.type isEqualToString:@"P"])
            {
                messageLabelFrame.origin.x = 85;
            }
            else
            {
                messageLabelFrame.origin.x = 40;
            }
            messageLabelFrame.origin.y = 5;
            messageLabel.frame = messageLabelFrame;
            
            CGRect imageProductFrame = productImage.frame;
            imageProductFrame.origin.x = 40;
            imageProductFrame.origin.y = 5;
            imageProductFrame.size.width = 40;
            imageProductFrame.size.height = 40;
            productImage.frame = imageProductFrame;

            CGRect datetimeLabelFrame = datetimeLabel.frame;
            datetimeLabelFrame.origin.x = 270 - datetimeLabelFrame.size.width;
            datetimeLabelFrame.origin.y = messageLabelFrame.origin.y + messageLabelFrame.size.height + 5;
            datetimeLabel.frame = datetimeLabelFrame;

        }
        else
        {
            CGRect clientImageFrame = clientImage.frame;
            clientImageFrame.origin.x = 345;
            clientImageFrame.origin.y = 5;
            clientImageFrame.size.width = 30;
            clientImageFrame.size.height = 30;
            clientImage.frame = clientImageFrame;
            
            messageLabelFrame = messageLabel.frame;
            /*if ([myMessage.type isEqualToString:@"P"])
            {
                messageLabelFrame.origin.x = 155;
            }
            else
            {
                messageLabelFrame.origin.x = 110;
            }*/
            messageLabelFrame.origin.x = 340 - messageLabelFrame.size.width;
            messageLabelFrame.origin.y = 5;
            messageLabel.frame = messageLabelFrame;
            
            CGRect imageProductFrame = productImage.frame;
            imageProductFrame.origin.x = 110;
            imageProductFrame.origin.y = 5;
            imageProductFrame.size.width = 40;
            imageProductFrame.size.height = 40;
            productImage.frame = imageProductFrame;
            
            CGRect datetimeLabelFrame = datetimeLabel.frame;
            datetimeLabelFrame.origin.x = 340 - datetimeLabelFrame.size.width;
            datetimeLabelFrame.origin.y = messageLabelFrame.origin.y + messageLabelFrame.size.height + 5;
            datetimeLabel.frame = datetimeLabelFrame;
        }
        
        _messageRowHeight = messageLabelFrame.size.height + 30;
        
        return myCell;
    }
    
    else // Opportunities Table
        
    {
        ClientModel *clientMethods = [[ClientModel alloc] init];
        
        // Retrieve cell
        NSString *cellIdentifier = @"CellOpp";
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
        return myCell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableMessages) // Messages Table
    {
        _selectedMessage = _myDataMessages[indexPath.row];
    }
    
}

@end
