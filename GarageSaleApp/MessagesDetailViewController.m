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
    Message *_selectedMessage;
    Product *_selectedProduct;
    
    NSInteger _messageRowHeight;
    
    NSString *_templateTypeForPopover;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *clientPickerPopover;
@property (nonatomic, strong) UIPopoverController *productPickerPopover;
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
        
        _clientRelatedToMessage = [clientMethods getClientFromClientId:messageSelected.client_id];
        
        
        // Setting frames for all pictures
        CGRect imageClientFrame = self.imageClient.frame;
        imageClientFrame.origin.x = 16;
        imageClientFrame.origin.y = 25;
        imageClientFrame.size.width = 70;
        imageClientFrame.size.height = 70;
        self.imageClient.frame = imageClientFrame;
        
        CGRect imageClientStatusFrame = self.imageClientStatus.frame;
        imageClientStatusFrame.origin.x = 94;
        imageClientStatusFrame.origin.y = 31;
        imageClientStatusFrame.size.width = 10;
        imageClientStatusFrame.size.height = 10;
        self.imageClientStatus.frame = imageClientStatusFrame;
        
        CGRect picClientPhoneFrame = self.picClientPhone.frame;
        picClientPhoneFrame.origin.x = 94;
        picClientPhoneFrame.origin.y = 77;
        picClientPhoneFrame.size.width = 15;
        picClientPhoneFrame.size.height = 15;
        self.picClientPhone.frame = picClientPhoneFrame;
        
        // Make clients picture rounded
        self.imageClient.layer.cornerRadius = self.imageClient.frame.size.width / 2;
        self.imageClient.clipsToBounds = YES;
        
        // Client name and status
        if ([_clientRelatedToMessage.status isEqualToString:@"V"])
        {
            self.labelClientName.text = [NSString stringWithFormat:@"    %@ %@", _clientRelatedToMessage.name, _clientRelatedToMessage.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", _clientRelatedToMessage.name, _clientRelatedToMessage.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Blank"];
        }
        
        self.labelClientPhone.text = _clientRelatedToMessage.phone1;
        self.imageClient.image = [UIImage imageWithData:_clientRelatedToMessage.picture];

        
        // Load messsages from the same client
        _myDataMessages = [messageMethods getMessagesArrayFromClient:_clientRelatedToMessage.client_id];
        [self.tableMessages reloadData];

        
        _selectedMessage = [[Message alloc] init];
        _selectedProduct = [[Product alloc] init];
        
        if (_myDataMessages.count > 0)
        {
            // Sort array to be sure new messages are on top
            [_myDataMessages sortUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *first = [(Message*)a datetime];
                NSDate *second = [(Message*)b datetime];
                return [first compare:second];
            }];
            
            int lastRowNumber = [self.tableMessages numberOfRowsInSection:0] - 1;
            NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
            [self.tableMessages scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
            _selectedMessage = [_myDataMessages lastObject];
        }
        
        [self UpdateProductRelated];

    }
}


- (void)UpdateProductRelated
{

    ProductModel *productMethods = [[ProductModel alloc] init];
    ClientModel *clientMethods = [[ClientModel alloc] init];
    OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];

    Client *ownerRelatedToMessage = [[Client alloc] init];

    CGRect imageProductFrame = self.imageProduct.frame;
    imageProductFrame.origin.x = 400;
    imageProductFrame.origin.y = 163;
    imageProductFrame.size.width = 140;
    imageProductFrame.size.height = 140;
    self.imageProduct.frame = imageProductFrame;
    
    CGRect imageProductSoldFrame = self.imageProductSold.frame;
    imageProductSoldFrame.origin.x = 400;
    imageProductSoldFrame.origin.y = 193;
    imageProductSoldFrame.size.width = 140;
    imageProductSoldFrame.size.height = 80;
    self.imageProductSold.frame = imageProductSoldFrame;
    
    CGRect imageOwnerFrame = self.imageOwner.frame;
    imageOwnerFrame.origin.x = 400;
    imageOwnerFrame.origin.y = 363;
    imageOwnerFrame.size.width = 70;
    imageOwnerFrame.size.height = 70;
    self.imageOwner.frame = imageOwnerFrame;
    
    CGRect imageOwnerStatusFrame = self.imageOwnerStatus.frame;
    imageOwnerStatusFrame.origin.x = 478;
    imageOwnerStatusFrame.origin.y = 369;
    imageOwnerStatusFrame.size.width = 10;
    imageOwnerStatusFrame.size.height = 10;
    self.imageOwnerStatus.frame = imageOwnerStatusFrame;
    
    CGRect picOwnerZoneFrame = self.picOwnerZone.frame;
    picOwnerZoneFrame.origin.x = 476;
    picOwnerZoneFrame.origin.y = 413;
    picOwnerZoneFrame.size.width = 15;
    picOwnerZoneFrame.size.height = 15;
    self.picOwnerZone.frame = picOwnerZoneFrame;
    
    CGRect picOwnerPhoneFrame = self.picOwnerPhone.frame;
    picOwnerPhoneFrame.origin.x = 476;
    picOwnerPhoneFrame.origin.y = 436;
    picOwnerPhoneFrame.size.width = 15;
    picOwnerPhoneFrame.size.height = 15;
    self.picOwnerPhone.frame = picOwnerPhoneFrame;

    CGRect buttonRelateToProductFrame = self.buttonRelateToProduct.frame;
    buttonRelateToProductFrame.origin.x = 458;
    buttonRelateToProductFrame.origin.y = 211;
    buttonRelateToProductFrame.size.width = 180;
    buttonRelateToProductFrame.size.height = 44;
    self.buttonRelateToProduct.frame = buttonRelateToProductFrame;
    
    CGRect buttonRelateToOwnerFrame = self.buttonRelateToOwner.frame;
    buttonRelateToOwnerFrame.origin.x = 468;
    buttonRelateToOwnerFrame.origin.y = 377;
    buttonRelateToOwnerFrame.size.width = 180;
    buttonRelateToOwnerFrame.size.height = 44;
    self.buttonRelateToOwner.frame = buttonRelateToOwnerFrame;
    
    CGRect labelProductDetailsFrame = self.labelProductDetails.frame;
    labelProductDetailsFrame.origin.x = 554;
    labelProductDetailsFrame.origin.y = 163;
    labelProductDetailsFrame.size.width = 136;
    labelProductDetailsFrame.size.height = 88;
    self.labelProductDetails.frame = labelProductDetailsFrame;
    
    
    if ((_selectedMessage == nil) || !([_selectedMessage.product_id length] > 0))
    {
        
        // Hide information related to product
        self.imageProduct.image = [UIImage imageNamed:@"Blank"];
        self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
        self.imageOwner.image = [UIImage imageNamed:@"Blank"];
        self.imageOwnerStatus.image = [UIImage imageNamed:@"Blank"];
        
        self.labelProductName.text = @"";
        self.labelProductGSCode.text = @"";
        self.labelProductPrice.text = @"";
        self.LabelProductRelated.text = @"";
        self.labelPublishedAgo.text = @"";
        self.labelProductDetails.text = @"";
        self.labelOwnerName.text = @"";
        self.labelOwnerZone.text = @"";
        self.labelOwnerAddress.text = @"";
        self.labelOwnerPhones.text = @"";
        self.buttonRelateToOwner.hidden = YES;
        self.buttonSeeInFacebook.hidden = YES;
        self.buttonMessageToOwner.hidden = YES;
        self.buttonNewOpportunity.hidden = YES;
        self.picOwnerPhone.hidden = YES;
        self.picOwnerZone.hidden = YES;

        // show button to relate to product
        self.buttonRelateToProduct.hidden = NO;

        // self.labelOpportunitiesForProduct.text = @"";
        // self.tableOpportunities.hidden = YES;

    }
    else
    {
        self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
        
        _selectedProduct = [productMethods getProductFromProductId:_selectedMessage.product_id];
        self.imageProduct.image = [UIImage imageWithData:_selectedProduct.picture];
        
        // Set sold image if product is sold
        if ([_selectedProduct.status isEqualToString:@"S"])
        {
            self.imageProductSold.image = [UIImage imageNamed:@"Sold"];
        }
        
        self.labelProductName.text = _selectedProduct.name;
        self.labelProductGSCode.text = _selectedProduct.GS_code;
        self.labelProductPrice.text = [NSString stringWithFormat:@"%@%.f", _selectedProduct.currency, _selectedProduct.published_price];
        self.labelProductDetails.text = _selectedProduct.desc;
        self.labelProductDetails.numberOfLines = 0;
        [self.labelProductDetails sizeToFit];
        
        CGRect labelProductDetailsFrame = self.labelProductDetails.frame;
        if (labelProductDetailsFrame.size.height > 82)
        {   labelProductDetailsFrame.size.height = 82;
            self.labelProductDetails.frame = labelProductDetailsFrame; }
        
        // Set data for owner if assigned
        
        if ([_selectedProduct.client_id length] > 0)
        {
            ownerRelatedToMessage = [clientMethods getClientFromClientId:_selectedProduct.client_id];
            
            self.LabelProductRelated.text = @"Producto al que hace referencia:";
            self.labelPublishedAgo.text = [NSString stringWithFormat:@"Publicado %@ por:", [_selectedProduct.created_time formattedAsTimeAgo]];
            // self.labelOpportunitiesForProduct.text = @"Oportunidades de este producto:";
            self.imageOwner.image = [UIImage imageWithData:ownerRelatedToMessage.picture];
            self.labelOwnerZone.text = [NSString stringWithFormat:@"Vive en %@",ownerRelatedToMessage.zone];
            self.labelOwnerAddress.text = ownerRelatedToMessage.address;
            self.labelOwnerPhones.text = ownerRelatedToMessage.phone1;
            self.buttonRelateToOwner.hidden = YES;
            
            // Owner name and status
            if ([ownerRelatedToMessage.status isEqualToString:@"V"])
            {
                self.labelOwnerName.text = [NSString stringWithFormat:@"    %@ %@", ownerRelatedToMessage.name, ownerRelatedToMessage.last_name];
                self.imageOwnerStatus.image = [UIImage imageNamed:@"Verified"];
            }
            else
            {
                self.labelOwnerName.text = [NSString stringWithFormat:@"%@ %@", ownerRelatedToMessage.name, ownerRelatedToMessage.last_name];
                self.imageOwnerStatus.image = [UIImage imageNamed:@"Blank"];
            }
            self.buttonSeeInFacebook.hidden = NO;
            self.buttonMessageToOwner.hidden = NO;
            self.buttonNewOpportunity.hidden = NO;
            // self.tableOpportunities.hidden = NO;
            self.picOwnerPhone.hidden = NO;
            self.picOwnerZone.hidden = NO;
        }
        else
        {
            self.imageOwner.image = [UIImage imageNamed:@"Blank"];
            self.labelPublishedAgo.text = @"";
            self.labelOwnerName.text = @"";
            self.imageOwnerStatus.image = [UIImage imageNamed:@"Blank"];
            self.labelOwnerZone.text = @"";
            self.labelOwnerAddress.text = @"";
            self.labelOwnerPhones.text = @"";
            self.buttonRelateToOwner.hidden = NO;
            self.buttonSeeInFacebook.hidden = NO;
            self.buttonMessageToOwner.hidden = YES;
            self.buttonNewOpportunity.hidden = NO;
            // self.tableOpportunities.hidden = NO;
            self.picOwnerPhone.hidden = YES;
            self.picOwnerZone.hidden = YES;
        }
        
        // Hide button to relate to product
        self.buttonRelateToProduct.hidden = YES;
        
        // Ge opportunitie related to product
        // _myDataOpportunities = [opportunityMethods getOpportunitiesFromProduct:productRelatedToMessage.product_id];
        // [self.tableOpportunities reloadData];

    }

}

#pragma mark - Managing button actions

- (IBAction)replyMessage:(id)sender
{
}

- (IBAction)messageToOwner:(id)sender
{
}

- (IBAction)markAsDone:(id)sender
{
}

- (IBAction)newOpportunity:(id)sender
{
}

- (IBAction)relateToClient:(id)sender
{
    ClientPickerViewController *clientPickerController = [[ClientPickerViewController alloc] initWithNibName:@"ClientPickerViewController" bundle:nil];
    clientPickerController.delegate = self;
    
    
    self.clientPickerPopover = [[UIPopoverController alloc] initWithContentViewController:clientPickerController];
    self.clientPickerPopover.popoverContentSize = CGSizeMake(350.0, 400.0);
    [self.clientPickerPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
}

-(void)clientSelectedfromClientPicker:(NSString *)clientIDSelected;
{
    // Dismiss the popover view
    [self.clientPickerPopover dismissPopoverAnimated:YES];
    
    // Update the product with the client selected (owner)
    Message *messageSelected = [[Message alloc] init];
    messageSelected = (Message *)_detailItem;
    
    ProductModel *productMethods = [[ProductModel alloc] init];
    Product *productRelatedToMessage = [[Product alloc] init];
    
    productRelatedToMessage = [productMethods getProductFromProductId:messageSelected.product_id];
    
    productRelatedToMessage.client_id = clientIDSelected;
    [productMethods updateProduct:productRelatedToMessage];
    
    [self configureView];
}



- (IBAction)relateToProduct:(id)sender
{
    ProductPickerViewController *productPickerController = [[ProductPickerViewController alloc] initWithNibName:@"ProductPickerViewController" bundle:nil];
    productPickerController.delegate = self;
    
    
    self.productPickerPopover = [[UIPopoverController alloc] initWithContentViewController:productPickerController];
    self.productPickerPopover.popoverContentSize = CGSizeMake(400.0, 500.0);
    [self.productPickerPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
}

-(void)productSelectedfromProductPicker:(NSString *)productIDSelected;
{
    // Dismiss the popover view
    [self.productPickerPopover dismissPopoverAnimated:YES];
    
    ProductModel *productMethods = [[ProductModel alloc] init];
    MessageModel *messageMethods = [[MessageModel alloc] init];
    
    _selectedProduct = [productMethods getProductFromProductId:productIDSelected];
    _selectedMessage.product_id = productIDSelected;
    [messageMethods updateMessage:_selectedMessage];
    
    [self configureView];
}



- (IBAction)editClientDetails:(id)sender
{
}

- (IBAction)seeProductInFacebook:(id)sender
{
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
        UIImageView *bubbleImage = (UIImageView*)[myCell.contentView viewWithTag:5];
        
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
        // if ([myMessage.type isEqualToString:@"P"])
        if ([myMessage.product_id length] > 0)
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
            // if ([myMessage.type isEqualToString:@"P"])
            if ([myMessage.product_id length] > 0)
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
            int datetimepositionX = messageLabelFrame.origin.x + messageLabelFrame.size.width - datetimeLabelFrame.size.width;
            if (datetimepositionX < 85) {
                datetimepositionX = 85;
            }
            datetimeLabelFrame.origin.x = datetimepositionX;
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
            messageLabelFrame.origin.x = 340 - messageLabelFrame.size.width;
            messageLabelFrame.origin.y = 5;
            messageLabel.frame = messageLabelFrame;
            
            CGRect imageProductFrame = productImage.frame;
            imageProductFrame.origin.x = messageLabelFrame.origin.x - 45;
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
        // if ([myMessage.type isEqualToString:@"P"] && _messageRowHeight<50)
        if (([myMessage.product_id length] > 0) && _messageRowHeight<50)
        {
            _messageRowHeight = 50;
        }
        
        
        // Set bubble
        bubbleImage.image = [UIImage imageNamed:@"Blank"];
        bubbleImage.layer.cornerRadius = 5.0;
        bubbleImage.clipsToBounds = YES;
        
        CGRect bubbleImageFrame = bubbleImage.frame;
        bubbleImageFrame.origin.y = 2;
        bubbleImageFrame.size.height = _messageRowHeight - 4;
        
        if ([myMessage.recipient isEqualToString:@"G"])
        {
            bubbleImageFrame.origin.x = 37;
            bubbleImageFrame.size.width = datetimeLabel.frame.origin.x + datetimeLabel.frame.size.width - 37 + 3;
        }
        else
        {
            // if ([myMessage.type isEqualToString:@"P"])
            if ([_selectedMessage.product_id length] > 0)
            {
                bubbleImageFrame.origin.x = productImage.frame.origin.x - 3;
            }
            else
            {
                if (datetimeLabel.frame.origin.x < messageLabel.frame.origin.x)
                {
                    bubbleImageFrame.origin.x = datetimeLabel.frame.origin.x - 3;
                }
                else
                {
                    bubbleImageFrame.origin.x = messageLabel.frame.origin.x - 3;
                }
            }
            bubbleImageFrame.size.width = 343 - bubbleImageFrame.origin.x;
        }
        
        bubbleImage.frame = bubbleImageFrame;
        
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
        
        [self UpdateProductRelated];

    }
    
}

@end
