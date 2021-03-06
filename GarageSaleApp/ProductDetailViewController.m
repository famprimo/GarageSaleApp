//
//  ProductDetailViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductTableViewController.h"
#import "Product.h"
#import "ProductModel.h"
#import "Client.h"
#import "ClientModel.h"
#import "Opportunity.h"
#import "OpportunityModel.h"
#import "Message.h"
#import "MessageModel.h"
#import "Settings.h"
#import "SettingsModel.h"
#import "NSDate+NVTimeAgo.h"
#import "NS-Extensions.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ProductDetailViewController ()

{
    // Data for the tables
    NSMutableArray *_myDataMessages;
    NSMutableArray *_myDataOpportunities;
    
    NSString *_templateTypeForPopover;
    NSString *_clientPickerOrigin;
    id _buttonOrigin;
    NSString *_buyerSelected;
    
    Opportunity *_selectedOpportunity;
    Message *_selectedMessage;
    
    NSInteger _messageRowHeight;
    
    UIRefreshControl *_refreshControl;
    
    // Temp variables for user and page IDs
    Settings *_tmpSettings;
    
    // Objects Methods
    ProductModel *_productMethods;
    FacebookMethods *_facebookMethods;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *clientPickerPopover;
@property (nonatomic, strong) UIPopoverController *sendMessagePopover;
@property (nonatomic, strong) UIPopoverController *createOpportunityPopover;
@property (nonatomic, strong) UIPopoverController *editProductPopover;

- (void)configureView;

@end


@implementation ProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableMessages.delegate = self;
    self.tableMessages.dataSource = self;
    
    self.tableOpportunities.delegate = self;
    self.tableOpportunities.dataSource = self;
    
    // Initialize objects methods
    _productMethods = [[ProductModel alloc] init];
    
    _facebookMethods = [[FacebookMethods alloc] init];
    _facebookMethods.delegate = self;
    
    _messageRowHeight = 80;
    
    _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];

    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(getPreviousMessages:) forControlEvents:UIControlEventValueChanged];
    [self.tableMessages addSubview:_refreshControl];

    // Update the view
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
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
        
        Product *productSelected = [[Product alloc] init];
        productSelected = (Product *)_detailItem;
        
        ClientModel *clientMethods = [[ClientModel alloc] init];
        OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];
        MessageModel *messageMethods = [[MessageModel alloc] init];
        
        // Setting frames for all pictures
        CGRect productImageFrame = self.imageProduct.frame;
        productImageFrame.origin.x = 15;
        productImageFrame.origin.y = 106;
        productImageFrame.size.width = 180;
        productImageFrame.size.height = 180;
        self.imageProduct.frame = productImageFrame;
        
        CGRect imageOwnerFrame = self.imageOwner.frame;
        imageOwnerFrame.origin.x = 410;
        imageOwnerFrame.origin.y = 106;
        imageOwnerFrame.size.width = 70;
        imageOwnerFrame.size.height = 70;
        self.imageOwner.frame = imageOwnerFrame;
        
        CGRect imageOwnerStatusFrame = self.imageOwnerStatus.frame;
        imageOwnerStatusFrame.origin.x = 489;
        imageOwnerStatusFrame.origin.y = 109;
        imageOwnerStatusFrame.size.width = 10;
        imageOwnerStatusFrame.size.height = 10;
        self.imageOwnerStatus.frame = imageOwnerStatusFrame;
        
        CGRect picOwnerPhoneFrame = self.picOwnerPhone.frame;
        picOwnerPhoneFrame.origin.x = 487;
        picOwnerPhoneFrame.origin.y = 130;
        picOwnerPhoneFrame.size.width = 15;
        picOwnerPhoneFrame.size.height = 15;
        self.picOwnerPhone.frame = picOwnerPhoneFrame;

        CGRect picOwnerZoneFrame = self.picOwnerZone.frame;
        picOwnerZoneFrame.origin.x = 487;
        picOwnerZoneFrame.origin.y = 158;
        picOwnerZoneFrame.size.width = 15;
        picOwnerZoneFrame.size.height = 15;
        self.picOwnerZone.frame = picOwnerZoneFrame;

        CGRect labelDescriptionFrame = self.labelDescription.frame;
        labelDescriptionFrame.origin.x = 205;
        labelDescriptionFrame.origin.y = 120;
        labelDescriptionFrame.size.width = 190;
        labelDescriptionFrame.size.height = 195;
        self.labelDescription.frame = labelDescriptionFrame;

        CGRect labelNotesFrame = self.labelNotes.frame;
        labelNotesFrame.origin.x = 410;
        labelNotesFrame.origin.y = 242;
        labelNotesFrame.size.width = 164;
        labelNotesFrame.size.height = 75;
        self.labelNotes.frame = labelNotesFrame;

        CGRect labelOwnerNotesFrame = self.labelOwnerNotes.frame;
        labelOwnerNotesFrame.origin.x = 489;
        labelOwnerNotesFrame.origin.y = 177;
        labelOwnerNotesFrame.size.width = 201;
        labelOwnerNotesFrame.size.height = 51;
        self.labelOwnerNotes.frame = labelOwnerNotesFrame;


        // Set data
        self.imageProduct.image = [UIImage imageWithData:[_productMethods getProductPhotoFrom:productSelected]];
        
        self.labelProductName.text = productSelected.name;
        if ([productSelected.type isEqualToString:@"S"])
        {
            self.labelPrice.text = [NSString stringWithFormat:@"%@%@", productSelected.currency, productSelected.price];
        }
        else // @"A"
        {
            self.labelPrice.text = @"Publicidad";
        }
        
        if ([productSelected.status isEqualToString:@"N"])
        {
            self.buttonChangeProductStatus.backgroundColor = [UIColor blueColor];
        }
        else if ([productSelected.status isEqualToString:@"D"])
        {
            self.buttonChangeProductStatus.backgroundColor = [UIColor redColor];
        }
        else
        {
            self.buttonChangeProductStatus.backgroundColor = [UIColor darkGrayColor];
        }
        
        self.labelGSCode.text = productSelected.codeGS;
        self.labelInventoryTime.text = [productSelected.last_inventory_time formattedAsDateComplete];
        
        self.labelDescription.text = productSelected.desc;
        self.labelDescription.numberOfLines = 0;
        [self.labelDescription sizeToFit];

        labelDescriptionFrame = self.labelDescription.frame;
        if (labelDescriptionFrame.size.height > 195)
        {   labelDescriptionFrame.size.height = 195;
            self.labelDescription.frame = labelDescriptionFrame; }

        self.labelNotes.text = productSelected.notes;
        self.labelNotes.numberOfLines = 0;
        [self.labelNotes sizeToFit];

        labelNotesFrame = self.labelNotes.frame;
        if (labelNotesFrame.size.height > 75)
        {   labelNotesFrame.size.height = 75;
            self.labelNotes.frame = labelNotesFrame; }

        // Make owners picture rounded
        self.imageOwner.layer.cornerRadius = self.imageOwner.frame.size.width / 2;
        self.imageOwner.clipsToBounds = YES;
        
        self.buttonSeeInFacebook.imageView.image = [[UIImage imageNamed:@"Facebook"] makeThumbnailOfSize:CGSizeMake(40, 40)];
        
        // Set data for owner if assigned
        
        if ([productSelected.client_id length] > 0)
        {
            Client *ownerForProduct = [clientMethods getClientFromClientId:productSelected.client_id];
            
            self.labelPublishedAgo.text = @"Publicado por:";
            //self.imageOwner.image = [UIImage imageWithData:ownerForProduct.picture];
            self.imageOwner.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:ownerForProduct]];
            self.labelOwnerZone.text = [NSString stringWithFormat:@"Vive en %@",ownerForProduct.client_zone];
            self.labelOwnerPhones.text = ownerForProduct.phone1;
            
            // Owner Address
            self.labelOwnerNotes.text = ownerForProduct.notes;
            self.labelOwnerNotes.numberOfLines = 0;
            [self.labelOwnerNotes sizeToFit];
            
            labelOwnerNotesFrame = self.labelOwnerNotes.frame;
            if (labelOwnerNotesFrame.size.height > 51)
            {   labelOwnerNotesFrame.size.height = 51;
                self.labelOwnerNotes.frame = labelOwnerNotesFrame; }

            // Owner name and status
            if ([ownerForProduct.status isEqualToString:@"V"])
            {
                self.labelOwnerName.text = [NSString stringWithFormat:@"    %@ %@", ownerForProduct.name, ownerForProduct.last_name];
                self.imageOwnerStatus.image = [UIImage imageNamed:@"Verified"];
            }
            else
            {
                self.labelOwnerName.text = [NSString stringWithFormat:@"%@ %@", ownerForProduct.name, ownerForProduct.last_name];
                self.imageOwnerStatus.image = [UIImage imageNamed:@"Blank"];
            }
            
            self.buttonRelateToOwner.hidden = YES;
            self.buttonMessageToOwner.hidden = NO;
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
            self.labelOwnerNotes.text = @"";
            self.labelOwnerPhones.text = @"";
 
            self.buttonRelateToOwner.hidden = NO;
            self.buttonMessageToOwner.hidden = YES;
            self.picOwnerPhone.hidden = YES;
            self.picOwnerZone.hidden = YES;
        }
        
        
        // Load messsages related to the product
        _myDataMessages = [messageMethods getMessagesArrayForProduct:productSelected.product_id];
        
        _selectedMessage = [[Message alloc] init];
        
        if (_myDataMessages.count > 0)
        {
            _myDataMessages = [messageMethods sortMessagesArrayConsideringParents:_myDataMessages];
         
            [self.tableMessages reloadData];
            
            int lastRowNumber = [self.tableMessages numberOfRowsInSection:0] - 1;
            NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
            [self.tableMessages scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
            _selectedMessage = [_myDataMessages lastObject];
        }
        else
        {
            [self.tableMessages reloadData];
        }
        
        // Get opportunitie related to product
        _myDataOpportunities = [opportunityMethods getOpportunitiesFromProduct:productSelected.product_id];
        
        if (_myDataOpportunities.count > 0)
        {
            // Sort array to be sure new opportunities are on top
            [_myDataOpportunities sortUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *first = [(Opportunity*)a created_time];
                NSDate *second = [(Opportunity*)b created_time];
                return [second compare:first];
            }];
        }
        [self.tableOpportunities reloadData];

        self.buttonMessageToBuyer.enabled = NO;
    }
}


#pragma mark - Managing button actions

- (IBAction)changeProductStatus:(id)sender
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;

    if ([productSelected.status isEqualToString:@"N"])
    {
        productSelected.status = @"U";
        productSelected.updated_time = [NSDate date];
    }
    else if ([productSelected.status isEqualToString:@"U"])
    {
        productSelected.status = @"N";
        productSelected.updated_time = [NSDate date];
    }
    
    // Update products
    [_productMethods updateProduct:productSelected];
    
    [self configureView];
    [self.delegate productUpdated];
}

- (IBAction)getPreviousMessages:(id)sender
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;

    [_facebookMethods initializeMethods];

    [_facebookMethods getFBPhotoCommentsforProduct:productSelected];
}

-(IBAction)relateToClient:(id)sender;
{
    _clientPickerOrigin = @"RELATE";
    
    [self showPopoverClientPicker:sender];
}

-(IBAction)CreateOpportunity:(id)sender;
{
    _clientPickerOrigin = @"NEW OPP";
    _buttonOrigin = sender;
    
    [self showPopoverClientPicker:sender];
    
}

- (IBAction)replyMessage:(id)sender
{
    _templateTypeForPopover = @"P";
    
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
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    [_facebookMethods initializeMethods];

    [_facebookMethods getFBPhotoCommentsforProduct:productSelected];
}

-(IBAction)showPopoverClientPicker:(id)sender;
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

- (IBAction)sendMessageBuyer:(id)sender
{
    _templateTypeForPopover = @"B";
    
    SendMessageViewController *sendMessageController = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
    sendMessageController.delegate = self;
    
    
    self.sendMessagePopover = [[UIPopoverController alloc] initWithContentViewController:sendMessageController];
    self.sendMessagePopover.popoverContentSize = CGSizeMake(800.0, 500.0);
    [self.sendMessagePopover presentPopoverFromRect:[(UIButton *)sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
}

- (IBAction)sendMessageOwner:(id)sender
{
    _templateTypeForPopover = @"O";
    
    SendMessageViewController *sendMessageController = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
    sendMessageController.delegate = self;
    
    
    self.sendMessagePopover = [[UIPopoverController alloc] initWithContentViewController:sendMessageController];
    self.sendMessagePopover.popoverContentSize = CGSizeMake(800.0, 500.0);
    [self.sendMessagePopover presentPopoverFromRect:[(UIButton *)sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
    
}

- (IBAction)editProductDetails:(id)sender
{
    EditProductViewController *editProductController = [[EditProductViewController alloc] initWithNibName:@"EditProductViewController" bundle:nil];
    editProductController.delegate = self;
    
    self.editProductPopover = [[UIPopoverController alloc] initWithContentViewController:editProductController];
    self.editProductPopover.popoverContentSize = CGSizeMake(800, 300);
    [self.editProductPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    
}

- (IBAction)goToFacebook:(id)sender
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    if (productSelected.fb_link && ![productSelected.fb_link isEqualToString:@""])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:productSelected.fb_link]];
    }
}


#pragma mark - Delegate methods for ClientPicker

-(void)clientSelectedfromClientPicker:(NSString *)clientIDSelected;
{
    // Dismiss the popover view
    [self.clientPickerPopover dismissPopoverAnimated:YES];
    
    if ([_clientPickerOrigin isEqualToString:@"RELATE"])
    {
        // Update the product with the client selected (owner)
        Product *productSelected = [[Product alloc] init];
        productSelected = (Product *)_detailItem;
        
        productSelected.client_id = clientIDSelected;
        
        [_productMethods updateProduct:productSelected];
        
    }
    else if ([_clientPickerOrigin isEqualToString:@"NEW OPP"])
    {
        
        _buyerSelected = clientIDSelected;
        
        NewOpportunityViewController *createOpportunityController = [[NewOpportunityViewController alloc] initWithNibName:@"NewOpportunityViewController" bundle:nil];
        createOpportunityController.delegate = self;
        
        
        self.createOpportunityPopover = [[UIPopoverController alloc] initWithContentViewController:createOpportunityController];
        self.createOpportunityPopover.popoverContentSize = CGSizeMake(500.0, 300.0);
        [self.createOpportunityPopover presentPopoverFromRect:[(UIButton *)_buttonOrigin frame]
                                                       inView:self.view
                                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                                     animated:YES];
    }
    
    [self configureView];
}


#pragma mark - Delegate methods for NewOpportunity

-(NSString*)getBuyerIdForOpportunity;
{
    return _buyerSelected;
}

-(NSString*)getProductIdForOpportunity;
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    return productSelected.product_id;
}

-(void)opportunityCreated;
{
    // Dismiss the popover view
    [self.createOpportunityPopover dismissPopoverAnimated:YES];
    
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];
    
    _myDataOpportunities = [opportunityMethods getOpportunitiesFromProduct:productSelected.product_id];
    [self.tableOpportunities reloadData];
    
}


#pragma mark - Delegate methods for EditProduct

-(Product *)getProductforEdit;
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    return productSelected;
}

-(void)productEdited:(Product *)editedProduct;
{
    // Dismiss the popover view
    [self.editProductPopover dismissPopoverAnimated:YES];
    
    [self configureView];
    [self.delegate productUpdated];
}


#pragma mark - Delegate methods for SendMessage

-(NSString*)getTemplateTypeFromMessage;
{
    return _templateTypeForPopover;
}

-(NSString*)getBuyerIdFromMessage;
{
    if ([_templateTypeForPopover isEqualToString:@"P"])
    {
        if (_selectedMessage || [_selectedMessage.recipient isEqualToString:@"G"])
        {
            return _selectedMessage.client_id;
        }
        else
        {
            return @"";
        }
    }
    else
    {
        if (_selectedOpportunity)
        {
            return _selectedOpportunity.client_id;
        }
        else
        {
            return @"";
        }
    }
}

-(NSString*)getOwnerIdFromMessage;
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    return productSelected.client_id;
}

-(NSMutableArray*)getProductsIdFromMessage;
{
    NSMutableArray *selectedProductsArray = [[NSMutableArray alloc] init];
    
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    [selectedProductsArray addObject:productSelected.product_id];
    
    return selectedProductsArray;
}

-(NSString*)getMessageIdFromMessage;
{
    if (_selectedMessage.fb_msg_id)
    {
        return _selectedMessage.fb_msg_id;
    }
    else
    {
        return @"";
    }
}

-(void)messageSent:(NSString*)postType; // postType = (P)hoto (I)nbox (M)essage
{
    // Dismiss the popover view
    [self.sendMessagePopover dismissPopoverAnimated:YES];
    
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
        ClientModel *clientMethods = [[ClientModel alloc] init];
        Client *clientFrom = [[Client alloc] init];
        
        // Retrieve cell
        NSString *cellIdentifier = @"Cell";
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Get references to images and labels of cell
        UIImageView *clientImage = (UIImageView*)[myCell.contentView viewWithTag:1];
        UILabel *messageLabel = (UILabel*)[myCell.contentView viewWithTag:2];
        UILabel *datetimeLabel = (UILabel*)[myCell.contentView viewWithTag:4];
        UIImageView *bubbleImage = (UIImageView*)[myCell.contentView viewWithTag:5];
        
        
        // Get the message to be shown
        Message *myMessage = _myDataMessages[indexPath.row];
        
        clientFrom = [clientMethods getClientFromClientId:myMessage.client_id];
        
        // Set client picture
        if ([myMessage.recipient isEqualToString:@"G"])
        {
            //clientImage.image = [UIImage imageWithData:clientFrom.picture];
            clientImage.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:clientFrom]];
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
        messageLabelFrame.size.width = 240;

        if ([myMessage.recipient isEqualToString:@"G"])
        {
            messageLabel.text = [NSString stringWithFormat:@"%@ %@: %@", clientFrom.name, clientFrom.last_name, myMessage.message];
        }
        else
        {
            messageLabel.text = myMessage.message;
        }
        messageLabel.frame = messageLabelFrame;
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
            messageLabelFrame.origin.x = 40;
            messageLabelFrame.origin.y = 5;
            messageLabel.frame = messageLabelFrame;
            
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
            clientImageFrame.origin.x = 335;
            clientImageFrame.origin.y = 5;
            clientImageFrame.size.width = 30;
            clientImageFrame.size.height = 30;
            clientImage.frame = clientImageFrame;
            
            messageLabelFrame = messageLabel.frame;
            messageLabelFrame.origin.x = 330 - messageLabelFrame.size.width;
            messageLabelFrame.origin.y = 5;
            messageLabel.frame = messageLabelFrame;
            
            CGRect datetimeLabelFrame = datetimeLabel.frame;
            datetimeLabelFrame.origin.x = 330 - datetimeLabelFrame.size.width;
            datetimeLabelFrame.origin.y = messageLabelFrame.origin.y + messageLabelFrame.size.height + 5;
            datetimeLabel.frame = datetimeLabelFrame;
            
        }
        
        _messageRowHeight = messageLabelFrame.size.height + 30;
        
        
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
            if (datetimeLabel.frame.origin.x < messageLabel.frame.origin.x)
            {
                bubbleImageFrame.origin.x = datetimeLabel.frame.origin.x - 3;
            }
            else
            {
                bubbleImageFrame.origin.x = messageLabel.frame.origin.x - 3;
            }
            bubbleImageFrame.size.width = 343 - 10 - bubbleImageFrame.origin.x;
        }
        
        bubbleImage.frame = bubbleImageFrame;
        
        return myCell;
    }
    
    else // Opportunities Table
        
    {
        // Retrieve cell
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"CellOpp" forIndexPath:indexPath];
        
        // Get references to images and labels of cell
        UILabel *clientName = (UILabel*)[myCell.contentView viewWithTag:1];
        UILabel *opportunityDate = (UILabel*)[myCell.contentView viewWithTag:2];
        UILabel *opportunityStatus = (UILabel*)[myCell.contentView viewWithTag:3];
        UIImageView *clientImage = (UIImageView*)[myCell.contentView viewWithTag:4];
        UIImageView *clientStatus = (UIImageView*)[myCell.contentView viewWithTag:5];
        
        // Set image frames
        
        CGRect clientImageFrame = clientImage.frame;
        clientImageFrame.origin.x = 8;
        clientImageFrame.origin.y = 15;
        clientImageFrame.size.width = 40;
        clientImageFrame.size.height = 40;
        clientImage.frame = clientImageFrame;
        
        CGRect clientStatusFrame = clientStatus.frame;
        clientStatusFrame.origin.x = 56;
        clientStatusFrame.origin.y = 15;
        clientStatusFrame.size.width = 10;
        clientStatusFrame.size.height = 10;
        clientStatus.frame = clientStatusFrame;
        
        // Make client picture rounded
        clientImage.layer.cornerRadius = clientImage.frame.size.width / 2;
        clientImage.clipsToBounds = YES;
        
        // Get the information to be shown
        Opportunity *myOpportunity = _myDataOpportunities[indexPath.row];
        
        Client *clientRelatedToOpportunity = [[[ClientModel alloc] init] getClientFromClientId:myOpportunity.client_id];
        
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
    if (tableView == self.tableMessages) // Messages Table
    {
        _selectedMessage = _myDataMessages[indexPath.row];
    }
    else  // Opportunities Table
    {
        _selectedOpportunity = _myDataOpportunities[indexPath.row];
        
        self.buttonMessageToBuyer.enabled = YES;
    }
}


#pragma mark - FacebookMethods delegate methods

-(void)finishedGettingFBPhotoComments:(BOOL)succeed;
{
    if (succeed)
    {
        [_facebookMethods insertNewClientsFound];
    }
    else
    {
        [_refreshControl endRefreshing];
    }
}

-(void)finishedInsertingNewClientsFound:(BOOL)succeed;
{
    [_refreshControl endRefreshing];
    
    MessageModel *messageMethods = [[MessageModel alloc] init];
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    _myDataMessages = [messageMethods getMessagesArrayForProduct:productSelected.product_id];
    
    _myDataMessages = [messageMethods sortMessagesArrayConsideringParents:_myDataMessages];

    _selectedMessage = [[Message alloc] init];

    // Reload table
    [UIView transitionWithView:self.tableMessages
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [self.tableMessages reloadData];
                    } completion:NULL];

    if (_myDataMessages.count > 0)
    {
        int lastRowNumber = [self.tableMessages numberOfRowsInSection:0] - 1;
        NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.tableMessages scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        _selectedMessage = [_myDataMessages lastObject];
    }
}


-(void)newMessageAddedFromFB:(Message*)messageAdded;
{
    // No need to implement
}

-(void)finishedGettingFBpageNotifications:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedGettingFBInbox:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedGettingFBPageMessages:(BOOL)succeed;
{
    // No need to implement
}

-(void)finishedGettingFBPhotos:(BOOL)succeed;
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
