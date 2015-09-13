//
//  MessagesDetailViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 06/02/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "MessagesDetailViewController.h"
#import "Product.h"
#import "Message.h"
#import "ProductModel.h"
#import "Client.h"
#import "ClientModel.h"
#import "Opportunity.h"
#import "OpportunityModel.h"
#import "Attachment.h"
#import "AttachmentModel.h"
#import "Settings.h"
#import "SettingsModel.h"
#import "NSDate+NVTimeAgo.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface MessagesDetailViewController ()
{
    // Data for the tables
    NSMutableArray *_myDataMessages;
    NSMutableArray *_myDataOpportunities;
    
    Client *_selectedClient;
    Message *_selectedMessage;
    Product *_selectedProduct;
    Client *_relatedClient;
    Opportunity *_selectedOpportunity;
    
    NSInteger _messageRowHeight;
    
    NSString *_client2Type;
    NSString *_templateTypeForPopover;
    
    UIRefreshControl *_refreshControl;
    
    NSTimer *_readTimer;
    
    // Temp variables for user and page IDs
    Settings *_tmpSettings;

    // For managing the since date
    NSDate *_messagesSinceDate;
    
    // Objects for delegate methods
    FacebookMethods *_facebookMethods;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *clientPickerPopover;
@property (nonatomic, strong) UIPopoverController *productPickerPopover;
@property (nonatomic, strong) UIPopoverController *sendMessagePopover;
@property (nonatomic, strong) UIPopoverController *createOpportunityPopover;
@property (nonatomic, strong) UIPopoverController *editClientPopover;

@end


@implementation MessagesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableMessages.delegate = self;
    self.tableMessages.dataSource = self;
    
    self.tableOpportunities.delegate = self;
    self.tableOpportunities.dataSource = self;
    
    // Initialize objects methods
    _facebookMethods = [[FacebookMethods alloc] init];
    _facebookMethods.delegate = self;

    _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
    
    // Update the view
    [self configureView];
    
    _messageRowHeight = 80;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(getPreviousMessages:) forControlEvents:UIControlEventValueChanged];
    [self.tableMessages addSubview:_refreshControl];
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
        
        // Set a timer for update messages to read
        
        if (_readTimer)
        {
            [_readTimer invalidate];
        }
        _readTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(updateMessagesToRead:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        // Asign values to objects in View
        
        OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];
        
        MessageModel *messageMethods = [[MessageModel alloc] init];
        
        _selectedClient = (Client *)_detailItem;
        _client2Type = [[NSString alloc] init];
        
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
        
        CGRect picProductBackgroundFrame = self.picProductBackground.frame;
        picProductBackgroundFrame.origin.x = 390;
        picProductBackgroundFrame.origin.y = 0;
        picProductBackgroundFrame.size.width = 315;
        picProductBackgroundFrame.size.height = 765;
        self.picProductBackground.frame = picProductBackgroundFrame;

        self.picProductBackground.image = [UIImage imageNamed:@"Blank"];

        // Make clients picture rounded
        self.imageClient.layer.cornerRadius = self.imageClient.frame.size.width / 2;
        self.imageClient.clipsToBounds = YES;
        
        // Client name and status
        if ([_selectedClient.status isEqualToString:@"V"])
        {
            self.labelClientName.text = [NSString stringWithFormat:@"    %@ %@", _selectedClient.name, _selectedClient.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", _selectedClient.name, _selectedClient.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Blank"];
        }
        
        self.labelClientPhone.text = [NSString stringWithFormat:@"%@ %@ %@", _selectedClient.phone1, _selectedClient.phone2, _selectedClient.phone3];
        self.imageClient.image = [UIImage imageWithData:[[[ClientModel alloc] init] getClientPhotoFrom:_selectedClient]];
        self.labelOpportunitiesRelated.text = [NSString stringWithFormat:@"Oportunidades relacionadas a %@ %@:", _selectedClient.name, _selectedClient.last_name];

        // Load messsages from the same client
        _myDataMessages = [messageMethods getMessagesArrayFromClient:_selectedClient.client_id];
        [self.tableMessages reloadData];

        _selectedMessage = [[Message alloc] init];
        
        if (_myDataMessages.count > 0)
        {
            // Sort messages array
            _myDataMessages = [messageMethods sortMessagesArrayConsideringParents:_myDataMessages];
            
            // Go to last message
            [self scrollToBottom];
        }
        
        
        // Get opportunities related to client
        _myDataOpportunities = [opportunityMethods getOpportunitiesRelatedToClient:_selectedClient.client_id];
        
        // Sort array to be sure new opportunities are on top
        [_myDataOpportunities sortUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(Opportunity*)a created_time];
            NSDate *second = [(Opportunity*)b created_time];
            return [second compare:first];
            //return [first compare:second];
        }];
        
        _selectedOpportunity = [[Opportunity alloc] init];
        
        // Related product to last message
        if ([_selectedMessage.product_id length] >0)
        {
            ProductModel *productMethods = [[ProductModel alloc] init];
            _selectedProduct = [productMethods getProductFromProductId:_selectedMessage.product_id];
        }
        else
        {
            _selectedProduct = [[Product alloc] init];
        }
        
        [self UpdateProductRelated];
        [self.tableOpportunities reloadData];
    }
}

- (void)scrollToBottom;
{
    // Go to last message
    [self.tableMessages scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableMessages numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    _selectedMessage = [_myDataMessages lastObject];
}

- (void)UpdateProductRelated
{

    ClientModel *clientMethods = [[ClientModel alloc] init];

    _relatedClient = [[Client alloc] init];
    _client2Type = [[NSString alloc] init];

    CGRect imageProductFrame = self.imageProduct.frame;
    imageProductFrame.origin.x = 400;
    imageProductFrame.origin.y = 400;
    imageProductFrame.size.width = 140;
    imageProductFrame.size.height = 140;
    self.imageProduct.frame = imageProductFrame;
    
    CGRect imageClient2Frame = self.imageClient2.frame;
    imageClient2Frame.origin.x = 400;
    imageClient2Frame.origin.y = 600;
    imageClient2Frame.size.width = 70;
    imageClient2Frame.size.height = 70;
    self.imageClient2.frame = imageClient2Frame;
    
    CGRect imageClient2StatusFrame = self.imageClient2Status.frame;
    imageClient2StatusFrame.origin.x = 478;
    imageClient2StatusFrame.origin.y = 606;
    imageClient2StatusFrame.size.width = 10;
    imageClient2StatusFrame.size.height = 10;
    self.imageClient2Status.frame = imageClient2StatusFrame;
    
    CGRect picClient2ZoneFrame = self.picClient2Zone.frame;
    picClient2ZoneFrame.origin.x = 476;
    picClient2ZoneFrame.origin.y = 650;
    picClient2ZoneFrame.size.width = 15;
    picClient2ZoneFrame.size.height = 15;
    self.picClient2Zone.frame = picClient2ZoneFrame;
    
    CGRect picClient2PhoneFrame = self.picClient2Phone.frame;
    picClient2PhoneFrame.origin.x = 476;
    picClient2PhoneFrame.origin.y = 673;
    picClient2PhoneFrame.size.width = 15;
    picClient2PhoneFrame.size.height = 15;
    self.picClient2Phone.frame = picClient2PhoneFrame;

    CGRect buttonRelateToProductFrame = self.buttonRelateToProduct.frame;
    buttonRelateToProductFrame.origin.x = 455;
    buttonRelateToProductFrame.origin.y = 450;
    buttonRelateToProductFrame.size.width = 180;
    buttonRelateToProductFrame.size.height = 44;
    self.buttonRelateToProduct.frame = buttonRelateToProductFrame;
    
    CGRect buttonRelateToOwnerFrame = self.buttonRelateToOwner.frame;
    buttonRelateToOwnerFrame.origin.x = 458;
    buttonRelateToOwnerFrame.origin.y = 600;
    buttonRelateToOwnerFrame.size.width = 180;
    buttonRelateToOwnerFrame.size.height = 44;
    self.buttonRelateToOwner.frame = buttonRelateToOwnerFrame;
    
    CGRect labelProductDetailsFrame = self.labelProductDetails.frame;
    labelProductDetailsFrame.origin.x = 554;
    labelProductDetailsFrame.origin.y = 400;
    labelProductDetailsFrame.size.width = 136;
    labelProductDetailsFrame.size.height = 88;
    self.labelProductDetails.frame = labelProductDetailsFrame;
    
    // Make clients picture rounded
    self.imageClient2.layer.cornerRadius = self.imageClient2.frame.size.width / 2;
    self.imageClient2.clipsToBounds = YES;

    
    // if ((_selectedMessage == nil) || !([_selectedMessage.product_id length] > 0))
    
    if (!([_selectedProduct.product_id length] > 0))
    {
        
        // Hide information related to product
        self.imageProduct.image = [UIImage imageNamed:@"Blank"];
        self.imageClient2.image = [UIImage imageNamed:@"Blank"];
        self.imageClient2Status.image = [UIImage imageNamed:@"Blank"];
        
        self.labelProductName.text = @"";
        self.labelProductGSCode.text = @"";
        self.labelProductPrice.text = @"";
        self.LabelProductRelated.text = @"";
        self.labelProductReference.text = @"";
        self.labelProductDetails.text = @"";
        self.labelClient2Title.text = @"";
        self.labelClient2Name.text = @"";
        self.labelClient2Zone.text = @"";
        self.labelClient2Address.text = @"";
        self.labelClient2Phones.text = @"";
        self.buttonRelateToOwner.hidden = YES;
        self.buttonSeeInFacebook.hidden = YES;
        self.buttonMessageToRelatedClient.hidden = YES;
        self.buttonNewOpportunity.hidden = YES;
        self.picClient2Phone.hidden = YES;
        self.picClient2Zone.hidden = YES;

        // show button to relate to product
        self.buttonRelateToProduct.hidden = NO;

    }
    else
    {
        // self.imageProduct.image = [UIImage imageWithData:_selectedProduct.picture];
        self.imageProduct.image = [UIImage imageWithData:[[[ProductModel alloc] init] getProductPhotoFrom:_selectedProduct]];
        
        self.labelProductName.text = _selectedProduct.name;
        self.labelProductGSCode.text = _selectedProduct.codeGS;
        self.labelProductPrice.text = [NSString stringWithFormat:@"%@%@", _selectedProduct.currency, _selectedProduct.price];
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
            
            // Define if related client would be the owner or the interested (buyer)
            
            if (([_selectedProduct.client_id isEqualToString:_selectedClient.client_id]) && ([_selectedOpportunity.client_id length] > 0))
            {
                // show the client interested (buyer)
                if ([_selectedClient.sex isEqualToString:@"M"])
                {
                    self.labelProductReference.text = [NSString stringWithFormat:@"El dueño de este producto es %@ %@", _selectedClient.name, _selectedClient.last_name];
                }
                else
                {
                    self.labelProductReference.text = [NSString stringWithFormat:@"La dueña de este producto es %@ %@", _selectedClient.name, _selectedClient.last_name];
                }
                self.labelClient2Title.text = @"Interesado:";
                _client2Type = @"I";
                _relatedClient = [clientMethods getClientFromClientId:_selectedOpportunity.client_id];
                if ([_relatedClient.sex isEqualToString:@"M"])
                {
                    self.labelClient2Title.text = @"Interesado:";
                }
                else
                {
                    self.labelClient2Title.text = @"Interesada:";
                }
            }
            else
            {
                // Show the owner
                self.labelProductReference.text = [NSString stringWithFormat:@"Publicado %@ por:", [_selectedProduct.created_time formattedAsTimeAgo]];
                _client2Type = @"O";
                _relatedClient = [clientMethods getClientFromClientId:_selectedProduct.client_id];
                if ([_relatedClient.sex isEqualToString:@"M"])
                {
                    self.labelClient2Title.text = @"Dueño:";
                }
                else
                {
                    self.labelClient2Title.text = @"Dueña:";
                }
            }
            
            self.LabelProductRelated.text = @"Producto relacionado:";
            //self.imageClient2.image = [UIImage imageWithData:_relatedClient.picture];
            self.imageClient2.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:_relatedClient]];
            self.labelClient2Zone.text = [NSString stringWithFormat:@"Vive en %@",_relatedClient.client_zone];
            self.labelClient2Address.text = _relatedClient.address;
            self.labelClient2Phones.text = [NSString stringWithFormat:@"%@ %@ %@", _relatedClient.phone1, _relatedClient.phone2, _relatedClient.phone3];
            self.buttonRelateToOwner.hidden = YES;
            
            // Owner name and status
            if ([_relatedClient.status isEqualToString:@"V"])
            {
                self.labelClient2Name.text = [NSString stringWithFormat:@"    %@ %@", _relatedClient.name, _relatedClient.last_name];
                self.imageClient2Status.image = [UIImage imageNamed:@"Verified"];
            }
            else
            {
                self.labelClient2Name.text = [NSString stringWithFormat:@"%@ %@", _relatedClient.name, _relatedClient.last_name];
                self.imageClient2Status.image = [UIImage imageNamed:@"Blank"];
            }
            self.buttonSeeInFacebook.hidden = NO;
            self.buttonMessageToRelatedClient.hidden = NO;
            self.buttonNewOpportunity.hidden = NO;
            self.picClient2Phone.hidden = NO;
            self.picClient2Zone.hidden = NO;
        }
        else
        {
            self.imageClient2.image = [UIImage imageNamed:@"Blank"];
            self.labelProductReference.text = @"";
            self.labelClient2Name.text = @"";
            self.imageClient2Status.image = [UIImage imageNamed:@"Blank"];
            self.labelClient2Zone.text = @"";
            self.labelClient2Address.text = @"";
            self.labelClient2Phones.text = @"";
            self.buttonRelateToOwner.hidden = NO;
            self.buttonSeeInFacebook.hidden = NO;
            self.buttonMessageToRelatedClient.hidden = YES;
            self.buttonNewOpportunity.hidden = NO;
            self.picClient2Phone.hidden = YES;
            self.picClient2Zone.hidden = YES;
        }
        
        // Hide button to relate to product
        self.buttonRelateToProduct.hidden = YES;
        
    }

}


#pragma mark - Managing button actions

- (IBAction)updateMessagesToRead:(id)sender
{
    Message *tmpMessage = [[Message alloc] init];
    BOOL updateMessage = NO;
    
    for (int i=0; i<_myDataMessages.count; i=i+1)
    {
        tmpMessage = (Message*)_myDataMessages[i];
        
        if ([tmpMessage.status isEqualToString:@"N"])
        {
            tmpMessage.status = @"R";
            updateMessage = YES;
            [[[MessageModel alloc] init] updateMessage:tmpMessage];
        }
    }
    
    if (updateMessage)
    {
        [self.delegate messagesUpdated];
    }
}

- (IBAction)getPreviousMessages:(id)sender
{
    [_facebookMethods initializeMethods];
    
    [_facebookMethods getFBPageMessagesForClient:_selectedClient];
}

- (IBAction)replyMessage:(id)sender
{
    if ((_relatedClient.client_id == nil) || ([_client2Type isEqualToString:@"O"]))
    {
        _templateTypeForPopover = @"B";
    }
    else
    {
        _templateTypeForPopover = @"O";
    }
    
    SendMessageViewController *sendMessageController = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
    sendMessageController.delegate = self;
    
    
    self.sendMessagePopover = [[UIPopoverController alloc] initWithContentViewController:sendMessageController];
    self.sendMessagePopover.popoverContentSize = CGSizeMake(800.0, 500.0);
    [self.sendMessagePopover presentPopoverFromRect:[(UIButton *)sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
}

- (IBAction)messageToRelatedClient:(id)sender
{
    if ([_client2Type isEqualToString:@"O"])
    {
        _templateTypeForPopover = @"O";
    }
    else
    {
        _templateTypeForPopover = @"B";
    }
    
    SendMessageViewController *sendMessageController = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
    sendMessageController.delegate = self;
    
    
    self.sendMessagePopover = [[UIPopoverController alloc] initWithContentViewController:sendMessageController];
    self.sendMessagePopover.popoverContentSize = CGSizeMake(800.0, 500.0);
    [self.sendMessagePopover presentPopoverFromRect:[(UIButton *)sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
}

- (IBAction)reviewNewMessages:(id)sender
{
    [self getPreviousMessages:(sender)];
}

- (IBAction)newOpportunity:(id)sender
{
    NewOpportunityViewController *createOpportunityController = [[NewOpportunityViewController alloc] initWithNibName:@"NewOpportunityViewController" bundle:nil];
    createOpportunityController.delegate = self;
    
    
    self.createOpportunityPopover = [[UIPopoverController alloc] initWithContentViewController:createOpportunityController];
    self.createOpportunityPopover.popoverContentSize = CGSizeMake(500.0, 300.0);
    [self.createOpportunityPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                                   inView:self.view
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
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

- (IBAction)relateToProduct:(id)sender
{
    ProductPickerViewController *productPickerController = [[ProductPickerViewController alloc] initWithNibName:@"ProductPickerViewController" bundle:nil];
    productPickerController.delegate = self;
    
    
    self.productPickerPopover = [[UIPopoverController alloc] initWithContentViewController:productPickerController];
    self.productPickerPopover.popoverContentSize = CGSizeMake(500.0, 500.0);
    [self.productPickerPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
}

- (IBAction)editClientDetails:(id)sender
{
    EditClientViewController *editClientController = [[EditClientViewController alloc] initWithNibName:@"EditClientViewController" bundle:nil];
    editClientController.delegate = self;
    
    self.editClientPopover = [[UIPopoverController alloc] initWithContentViewController:editClientController];
    self.editClientPopover.popoverContentSize = CGSizeMake(800, 300);
    [self.editClientPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    
}

- (IBAction)seeProductInFacebook:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_selectedProduct.fb_link]];

}


#pragma mark - Delegate methods for SendMessge

-(NSString*)getTemplateTypeFromMessage;
{
    return _templateTypeForPopover;
}

-(NSString*)getBuyerIdFromMessage;
{
    if ([_client2Type isEqualToString:@"I"])
    {
        return _relatedClient.client_id;
    }
    else
    {
        return _selectedClient.client_id;
    }
}

-(NSString*)getOwnerIdFromMessage;
{
    if (_relatedClient.client_id == nil)
    {
        return @"";
    }
    else if ([_client2Type isEqualToString:@"I"])
    {
        return _selectedClient.client_id;
    }
    else
    {
        return _relatedClient.client_id;
    }
}

-(NSString*)getProductIdFromMessage;
{
    if (_selectedProduct.product_id == nil)
    {
        return @"";
    }
    else
    {
        return _selectedProduct.product_id;
    }
}

-(NSString*)getMessageIdFromMessage;
{
    if (_selectedMessage.fb_msg_id == nil)
    {
        return @"";
    }
    else
    {
        return _selectedMessage.fb_msg_id;
    }
}

-(void)messageSent:(NSString*)postType; // postType = (P)hoto (I)nbox (M)essage
{
    // Dismiss the popover view
    [self.sendMessagePopover dismissPopoverAnimated:YES];
    
    // Reload messages to show the new one
    [self getPreviousMessages:nil];
    
    // Mark all messages as read
    [self updateMessagesToRead:nil];
    
    // Go to last message
    [self scrollToBottom];
}


#pragma mark - Delegate methods for NewOpportunity

-(void)opportunityCreated;
{
    // Dismiss the popover view
    [self.createOpportunityPopover dismissPopoverAnimated:YES];
    
    OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];
    
    _myDataOpportunities = [opportunityMethods getOpportunitiesRelatedToClient:_selectedClient.client_id];
    
    [self.tableOpportunities reloadData];
    
    // Go to last message
    [self.tableOpportunities scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableOpportunities numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(NSString*)getBuyerIdForOpportunity;
{
    return _selectedClient.client_id;
}

-(NSString*)getProductIdForOpportunity;
{
    return _selectedProduct.product_id;
}


#pragma mark - Delegate methods for ProductPicker

-(void)productSelectedfromProductPicker:(NSMutableArray *)selectedProductsArray;
{
    // Dismiss the popover view
    [self.productPickerPopover dismissPopoverAnimated:YES];
    
    MessageModel *messageMethods = [[MessageModel alloc] init];
    
    _selectedProduct = selectedProductsArray[0];
    _selectedMessage.product_id = _selectedProduct.product_id;
    [messageMethods updateMessage:_selectedMessage];
    
    [self configureView];
}

-(BOOL)allowMultipleSelectionfromProductPicker
{
    return NO;
}

-(NSString*)getRelatedOwnerfromProductPicker
{
    return _selectedClient.client_id;
}


#pragma mark - Delegate methods for ClientPicker

-(void)clientSelectedfromClientPicker:(NSString *)clientIDSelected;
{
    // Dismiss the popover view
    [self.clientPickerPopover dismissPopoverAnimated:YES];
    
    // Update the product with the client selected (owner)
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    _selectedProduct.client_id = clientIDSelected;
    [productMethods updateProduct:_selectedProduct];
    
    [self configureView];
}


#pragma mark - Delegate methods for EditClient

-(Client *)getClientforEdit;
{
    return _selectedClient;
}

-(void)clientEdited:(Client *)editedClient;
{
    // Dismiss the popover view
    [self.editClientPopover dismissPopoverAnimated:YES];
    
    [self configureView];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableMessages) // Messages Table
    {
        return _messageRowHeight;
    }
    else  // Opportunities Table
    {
        return 80;
    }
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
        
        AttachmentModel *attachmentMethods = [[AttachmentModel alloc] init];
        Attachment *tempAttachment;
        
        // Retrieve cell
        NSString *cellIdentifier = @"Cell";
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Get references to images and labels of cell
        UIImageView *clientImage = (UIImageView*)[myCell.contentView viewWithTag:1];
        UILabel *messageLabel = (UILabel*)[myCell.contentView viewWithTag:2];
        UIImageView *productImage = (UIImageView*)[myCell.contentView viewWithTag:3];
        UILabel *datetimeLabel = (UILabel*)[myCell.contentView viewWithTag:4];
        UIImageView *bubbleImage = (UIImageView*)[myCell.contentView viewWithTag:5];

        // Clear any image added programmaticaly
        for (UIView *subview in myCell.subviews) {
            if (subview.tag == 1000) {
                [subview removeFromSuperview];
            }
        }

        // Get the message to be shown
        Message *myMessage = _myDataMessages[indexPath.row];
        
        // Set client picture
        if ([myMessage.recipient isEqualToString:@"G"])
        {
            //clientImage.image = [UIImage imageWithData:_selectedClient.picture];
            clientImage.image = [UIImage imageWithData:[[[ClientModel alloc] init] getClientPhotoFrom:_selectedClient]];
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
        if ([myMessage.product_id length] > 0)
        {
            productRelatedToMessage = [productMethods getProductFromProductId:myMessage.product_id];
            // productImage.image = [UIImage imageWithData:productRelatedToMessage.picture];
            productImage.image = [UIImage imageWithData:[productMethods getProductPhotoFrom:productRelatedToMessage]];
            
            // Change width of the message text if there is a product image
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
            datetimepositionX = MAX( datetimepositionX, 85 );
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
            
            CGRect datetimeLabelFrame = datetimeLabel.frame;
            datetimeLabelFrame.origin.x = 340 - datetimeLabelFrame.size.width;
            datetimeLabelFrame.origin.y = messageLabelFrame.origin.y + messageLabelFrame.size.height + 5;
            datetimeLabel.frame = datetimeLabelFrame;
            
            CGRect imageProductFrame = productImage.frame;
            imageProductFrame.origin.x = messageLabelFrame.origin.x - 45;
            if ((imageProductFrame.origin.x + imageProductFrame.size.width) > datetimeLabelFrame.origin.x)
            {
                imageProductFrame.origin.x = datetimeLabelFrame.origin.x - 45;
            }
            imageProductFrame.origin.y = 5;
            imageProductFrame.size.width = 40;
            imageProductFrame.size.height = 40;
            productImage.frame = imageProductFrame;
            
        }
        
        _messageRowHeight = messageLabelFrame.size.height + 30;
        if (([myMessage.product_id length] > 0) && _messageRowHeight<50)
        {
            _messageRowHeight = 50;
        }
        
        // Add pictures if there are attachments

        int picturesWidth = 0;
        
        if ([myMessage.attachments isEqualToString:@"Y"])
        {
            int initialPosX = 0;
            int initialPosY = 5;
            int imageSize = 70;
            int imagesPerRow = 3;
            int imagePosX = 0;
            int imagePosY = 0;
            int direction = 1;
            
            if ([myMessage.recipient isEqualToString:@"G"])
            {
                initialPosX = 50;
            }
            else
            {
                initialPosX = 337 - imageSize;
                direction = -1;
            }
            
            NSMutableArray *attachmentsArray = [attachmentMethods getAttachmentsForFBMessageId:myMessage.fb_msg_id];
            for (int i = 0; i < attachmentsArray.count; i++)
            {
                tempAttachment = [[Attachment alloc] init];
                tempAttachment = attachmentsArray[i];
                
                imagePosX = initialPosX + direction * (i % imagesPerRow) * (imageSize + 5);
                imagePosY = initialPosY + floor(i / imagesPerRow) * (imageSize + 5);
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imagePosX, imagePosY, imageSize, imageSize)];
                imgView.image = [UIImage imageWithData:tempAttachment.picture];
                imgView.tag = 1000;
                
                [myCell addSubview:imgView];
            }
            picturesWidth = MIN( attachmentsArray.count, imagesPerRow ) * (imageSize + 5) + 20;
            _messageRowHeight = imagePosY + imageSize + 25;
            
            CGRect datetimeLabelFrame = datetimeLabel.frame;
            datetimeLabelFrame.origin.y = _messageRowHeight - 20;
            datetimeLabel.frame = datetimeLabelFrame;
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
            if ([myMessage.product_id length] > 0)
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
        
        // Adjust bubble if there are pictures
        bubbleImageFrame.size.width = MAX( bubbleImageFrame.size.width, picturesWidth );
        bubbleImageFrame.origin.x = MIN( bubbleImageFrame.origin.x, 345 - picturesWidth);
        
        bubbleImage.frame = bubbleImageFrame;
        
        UIColor *bubbleColor;
        if ([myMessage.type isEqualToString:@"P"]) // Photo
        {
            bubbleColor = [UIColor colorWithRed:234/255.0f green:240/255.0f blue:243/255.0f alpha:1.0f];
        }
        else if ([myMessage.type isEqualToString:@"I"]) // Inbox
        {
            bubbleColor = [UIColor colorWithRed:231/255.0f green:240/255.0f blue:250/255.0f alpha:1.0f];
        }
        else // Message to Page - Conversation
        {
            bubbleColor = [UIColor colorWithRed:246/255.0f green:247/255.0f blue:236/255.0f alpha:1.0f];
        }
        bubbleImage.backgroundColor = bubbleColor;
        
        return myCell;
    }
    
    else // Opportunities Table
        
    {
        // Retrieve cell
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"CellOpp" forIndexPath:indexPath];
        
        // Get references to images and labels of cell
        UILabel *productLabel = (UILabel*)[myCell.contentView viewWithTag:1];
        UILabel *opportunityDate = (UILabel*)[myCell.contentView viewWithTag:2];
        UILabel *clientName = (UILabel*)[myCell.contentView viewWithTag:3];
        UILabel *opportunityStatus = (UILabel*)[myCell.contentView viewWithTag:4];
        UIImageView *productImage = (UIImageView*)[myCell.contentView viewWithTag:5];
        UIImageView *clientImage = (UIImageView*)[myCell.contentView viewWithTag:7];
        UIImageView *clientStatus = (UIImageView*)[myCell.contentView viewWithTag:8];
        
        CGRect productImageFrame = productImage.frame;
        productImageFrame.origin.x = 8;
        productImageFrame.origin.y = 24;
        productImageFrame.size.width = 40;
        productImageFrame.size.height = 40;
        productImage.frame = productImageFrame;
        
        CGRect clientImageFrame = clientImage.frame;
        clientImageFrame.origin.x = 56;
        clientImageFrame.origin.y = 24;
        clientImageFrame.size.width = 40;
        clientImageFrame.size.height = 40;
        clientImage.frame = clientImageFrame;
        
        CGRect clientStatusFrame = clientStatus.frame;
        clientStatusFrame.origin.x = 104;
        clientStatusFrame.origin.y = 27;
        clientStatusFrame.size.width = 10;
        clientStatusFrame.size.height = 10;
        clientStatus.frame = clientStatusFrame;
        
        // Make client picture rounded
        clientImage.layer.cornerRadius = clientImage.frame.size.width / 2;
        clientImage.clipsToBounds = YES;
        
        // Get the information to be shown
        Opportunity *myOpportunity = _myDataOpportunities[indexPath.row];
        
        Product *relatedProduct = [[[ProductModel alloc] init] getProductFromProductId:myOpportunity.product_id];
        Client *clientRelatedToOpportunity = [[[ClientModel alloc] init] getClientFromClientId:myOpportunity.client_id];
        
        // Set product data
        
        productLabel.text = relatedProduct.name;
        // productImage.image = [UIImage imageWithData:relatedProduct.picture];
        productImage.image = [UIImage imageWithData:[[[ProductModel alloc] init] getProductPhotoFrom:relatedProduct]];
        
        // Set client data
        //clientImage.image = [UIImage imageWithData:clientRelatedToOpportunity.picture];
        clientImage.image = [UIImage imageWithData:[[[ClientModel alloc] init] getClientPhotoFrom:clientRelatedToOpportunity]];
        if ([clientRelatedToOpportunity.status isEqualToString:@"V"])
        {
            clientName.text = [NSString stringWithFormat:@"    %@ %@", clientRelatedToOpportunity.name, clientRelatedToOpportunity.last_name];
            clientStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            clientName.text = [NSString stringWithFormat:@"%@ %@", clientRelatedToOpportunity.name, clientRelatedToOpportunity.last_name];
            clientStatus.image = [UIImage imageNamed:@"Blank"];
        }
        
        // Set opportunity status and dates
        
        opportunityDate.text = [myOpportunity.created_time formattedAsTimeAgo];
        
        if ([myOpportunity.status isEqualToString:@"O"])
        {
            opportunityStatus.text = @"Oportunidad abierta";
        }
        else if ([myOpportunity.status isEqualToString:@"C"])
        {
            opportunityStatus.text = [NSString stringWithFormat:@"Oportunidad cerrada %@", [myOpportunity.closedsold_time formattedAsTimeAgo]];
        }
        else if ([myOpportunity.status isEqualToString:@"S"])
        {
            opportunityStatus.text = [NSString stringWithFormat:@"Producto vendido %@, pero pendiente de pago", [myOpportunity.closedsold_time formattedAsTimeAgo]];
        }
        else if ([myOpportunity.status isEqualToString:@"P"])
        {
            opportunityStatus.text = [NSString stringWithFormat:@"Producto vendido %@, y pagado %@", [myOpportunity.closedsold_time formattedAsTimeAgo], [myOpportunity.paid_time formattedAsTimeAgo]];
        }
        
        return myCell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    if (tableView == self.tableMessages) // Messages Table
    {
        _selectedMessage = _myDataMessages[indexPath.row];
        
        if ([_selectedMessage.product_id length] >0)
        {
            _selectedProduct = [productMethods getProductFromProductId:_selectedMessage.product_id];
        }
        else
        {
            _selectedProduct = [[Product alloc] init];
        }
        
        [self.tableOpportunities deselectRowAtIndexPath:[self.tableOpportunities indexPathForSelectedRow] animated:NO];
    }
    else  // Opportunities Table
    {
        _selectedOpportunity = _myDataOpportunities[indexPath.row];
        _selectedProduct = [productMethods getProductFromProductId:_selectedOpportunity.product_id];
        
        [self.tableMessages deselectRowAtIndexPath:[self.tableMessages indexPathForSelectedRow] animated:NO];
        
    }

    [self UpdateProductRelated];

}


#pragma mark - FacebookMethods delegate methods

-(void)finishedGettingFBpageNotifications:(BOOL)succeed;
{
    // No need
}

-(void)finishedGettingFBInbox:(BOOL)succeed;
{
    // No Inbox asked!
}

-(void)finishedGettingFBPageMessages:(BOOL)succeed;
{
    [_facebookMethods insertNewClientsFound];
}

-(void)finishedInsertingNewClientsFound:(BOOL)succeed;
{
    [_refreshControl endRefreshing];

    if (succeed)
    {
        MessageModel *messageMethods = [[MessageModel alloc] init];
        
        // Update messages table
        _myDataMessages = [[NSMutableArray alloc] init];
        
        _myDataMessages = [messageMethods getMessagesArrayFromClient:_selectedClient.client_id];
        
        // Sort array to be sure new messages are on top
        
        [_myDataMessages sortUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(Message*)a datetime];
            NSDate *second = [(Message*)b datetime];
            return [first compare:second];
        }];
        
        // Reload table
        [UIView transitionWithView:self.tableMessages
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^(void) {
                            [self.tableMessages reloadData];
                        } completion:NULL];
        
        // Go to last message
        [self scrollToBottom];

        [self.delegate messagesUpdated];
    }
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

@end
