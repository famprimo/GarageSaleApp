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
        productImageFrame.origin.y = 90;
        productImageFrame.size.width = 180;
        productImageFrame.size.height = 180;
        self.imageProduct.frame = productImageFrame;

        CGRect soldImageFrame = self.imageProductSold.frame;
        soldImageFrame.origin.x = 15;
        soldImageFrame.origin.y = 90; //124
        soldImageFrame.size.width = 180;
        soldImageFrame.size.height = 180; // 111
        self.imageProductSold.frame = soldImageFrame;
        
        CGRect imageOwnerFrame = self.imageOwner.frame;
        imageOwnerFrame.origin.x = 410;
        imageOwnerFrame.origin.y = 90;
        imageOwnerFrame.size.width = 70;
        imageOwnerFrame.size.height = 70;
        self.imageOwner.frame = imageOwnerFrame;
        
        CGRect imageOwnerStatusFrame = self.imageOwnerStatus.frame;
        imageOwnerStatusFrame.origin.x = 489;
        imageOwnerStatusFrame.origin.y = 96;
        imageOwnerStatusFrame.size.width = 10;
        imageOwnerStatusFrame.size.height = 10;
        self.imageOwnerStatus.frame = imageOwnerStatusFrame;
        
        CGRect picOwnerPhoneFrame = self.picOwnerPhone.frame;
        picOwnerPhoneFrame.origin.x = 487;
        picOwnerPhoneFrame.origin.y = 117;
        picOwnerPhoneFrame.size.width = 15;
        picOwnerPhoneFrame.size.height = 15;
        self.picOwnerPhone.frame = picOwnerPhoneFrame;

        CGRect picOwnerZoneFrame = self.picOwnerZone.frame;
        picOwnerZoneFrame.origin.x = 487;
        picOwnerZoneFrame.origin.y = 145;
        picOwnerZoneFrame.size.width = 15;
        picOwnerZoneFrame.size.height = 15;
        self.picOwnerZone.frame = picOwnerZoneFrame;

        CGRect labelDescriptionFrame = self.labelDescription.frame;
        labelDescriptionFrame.origin.x = 205;
        labelDescriptionFrame.origin.y = 90;
        labelDescriptionFrame.size.width = 176;
        labelDescriptionFrame.size.height = 180;
        self.labelDescription.frame = labelDescriptionFrame;

        CGRect labelNotesFrame = self.labelNotes.frame;
        labelNotesFrame.origin.x = 410;
        labelNotesFrame.origin.y = 239;
        labelNotesFrame.size.width = 280;
        labelNotesFrame.size.height = 60;
        self.labelNotes.frame = labelNotesFrame;

        CGRect labelOwnerAddressFrame = self.labelOwnerAddress.frame;
        labelOwnerAddressFrame.origin.x = 489;
        labelOwnerAddressFrame.origin.y = 165;
        labelOwnerAddressFrame.size.width = 201;
        labelOwnerAddressFrame.size.height = 52;
        self.labelOwnerAddress.frame = labelOwnerAddressFrame;


        // Set data
        self.imageProduct.image = [UIImage imageWithData:productSelected.picture];
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
        else
        {
            self.buttonChangeProductStatus.backgroundColor = [UIColor darkGrayColor];
        }
        
        self.labelGSCode.text = productSelected.codeGS;
        self.labelCreationDate.text = [productSelected.created_time formattedAsDateComplete];
        
        self.labelDescription.text = productSelected.desc;
        self.labelDescription.numberOfLines = 0;
        [self.labelDescription sizeToFit];

        labelDescriptionFrame = self.labelDescription.frame;
        if (labelDescriptionFrame.size.height > 180)
        {   labelDescriptionFrame.size.height = 180;
            self.labelDescription.frame = labelDescriptionFrame; }

        self.labelNotes.text = productSelected.notes;
        self.labelNotes.numberOfLines = 0;
        [self.labelNotes sizeToFit];

        labelNotesFrame = self.labelNotes.frame;
        if (labelNotesFrame.size.height > 60)
        {   labelNotesFrame.size.height = 60;
            self.labelNotes.frame = labelNotesFrame; }

        // Set sold image depending on product status
        self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
        if ([productSelected.status isEqualToString:@"S"])
        {
            self.imageProductSold.image = [UIImage imageNamed:@"Sold"];
        }

        // Make owners picture rounded
        self.imageOwner.layer.cornerRadius = self.imageOwner.frame.size.width / 2;
        self.imageOwner.clipsToBounds = YES;
        
        self.buttonSeeInFacebook.imageView.image = [[UIImage imageNamed:@"Facebook"] makeThumbnailOfSize:CGSizeMake(40, 40)];

        
        // Set data for owner if assigned
        
        if ([productSelected.client_id length] > 0)
        {
            Client *ownerForProduct = [clientMethods getClientFromClientId:productSelected.client_id];
            
            self.labelPublishedAgo.text = @"Publicado por:";
            self.imageOwner.image = [UIImage imageWithData:ownerForProduct.picture];
            self.labelOwnerZone.text = [NSString stringWithFormat:@"Vive en %@",ownerForProduct.client_zone];
            self.labelOwnerPhones.text = ownerForProduct.phone1;
            
            // Owner Address
            self.labelOwnerAddress.text = ownerForProduct.address;
            self.labelOwnerAddress.numberOfLines = 0;
            [self.labelOwnerAddress sizeToFit];
            
            labelOwnerAddressFrame = self.labelOwnerAddress.frame;
            if (labelOwnerAddressFrame.size.height > 52)
            {   labelOwnerAddressFrame.size.height = 52;
                self.labelOwnerAddress.frame = labelOwnerAddressFrame; }

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
            self.labelOwnerAddress.text = @"";
            self.labelOwnerPhones.text = @"";
 
            self.buttonRelateToOwner.hidden = NO;
            self.buttonMessageToOwner.hidden = YES;
            self.picOwnerPhone.hidden = YES;
            self.picOwnerZone.hidden = YES;
        }
        
        
        // Load messsages related to the product
        _myDataMessages = [messageMethods getMessagesArrayForProduct:productSelected.product_id];
        [self.tableMessages reloadData];
        
        _selectedMessage = [[Message alloc] init];
        
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

        // Get opportunitie related to product
        _myDataOpportunities = [opportunityMethods getOpportunitiesFromProduct:productSelected.product_id];
        
        // Sort array to be sure new opportunities are on top
        [_myDataOpportunities sortUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(Opportunity*)a created_time];
            NSDate *second = [(Opportunity*)b created_time];
            return [second compare:first];
            //return [first compare:second];
        }];

        [self.tableOpportunities reloadData];
        
        self.buttonMessageToBuyer.enabled = NO;

    }
}

- (IBAction)changeProductStatus:(id)sender
{
    ProductModel *productMethods = [[ProductModel alloc] init];
    
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
    [productMethods updateProduct:productSelected];
    
    [self configureView];
    
}

- (IBAction)getPreviousMessages:(id)sender
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;

    NSString *url = [NSString stringWithFormat:@"%@/comments", productSelected.fb_photo_id];
    
    [self getFBPhotoComments:url forProduct:productSelected];
    
    [_refreshControl endRefreshing];
    
    [self.tableMessages reloadData];
    
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
        
        ProductModel *productMethods = [[ProductModel alloc] init];
        [productMethods updateProduct:productSelected];

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

-(NSString*)GetBuyerIdForOpportunity;
{
    return _buyerSelected;
}

-(NSString*)GetProductIdForOpportunity;
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    return productSelected.product_id;
}

-(void)OpportunityCreated;
{
    // Dismiss the popover view
    [self.createOpportunityPopover dismissPopoverAnimated:YES];
    
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];
    
    _myDataOpportunities = [opportunityMethods getOpportunitiesFromProduct:productSelected.product_id];
    [self.tableOpportunities reloadData];
    
}

-(IBAction)showPopoverSendMessageBuyer:(id)sender;
{
    _templateTypeForPopover = @"C";
    
    SendMessageViewController *sendMessageController = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
    sendMessageController.delegate = self;
    
    
    self.sendMessagePopover = [[UIPopoverController alloc] initWithContentViewController:sendMessageController];
    self.sendMessagePopover.popoverContentSize = CGSizeMake(800.0, 500.0);
    [self.sendMessagePopover presentPopoverFromRect:[(UIButton *)sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
}

-(IBAction)showPopoverSendMessageOwner:(id)sender;
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

-(NSString*)GetTemplateTypeFromMessage;
{
    return _templateTypeForPopover;
}

-(NSString*)GetBuyerIdFromMessage;
{
    
    return _selectedOpportunity.client_id;
}

-(NSString*)GetOwnerIdFromMessage;
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    return productSelected.client_id;
}

-(NSString*)GetProductIdFromMessage;
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    return productSelected.product_id;
}

-(void)MessageSent;
{
    // Dismiss the popover view
    [self.sendMessagePopover dismissPopoverAnimated:YES];
    
}

- (IBAction)editProductDetails:(id)sender
{
    EditProductViewController *editProductController = [[EditProductViewController alloc] initWithNibName:@"EditProductViewController" bundle:nil];
    editProductController.delegate = self;
    
    self.editProductPopover = [[UIPopoverController alloc] initWithContentViewController:editProductController];
    self.editProductPopover.popoverContentSize = CGSizeMake(800, 400);
    [self.editProductPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    
}

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
}

- (IBAction)goToFacebook:(id)sender
{
    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:productSelected.fb_link]];
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
            clientImage.image = [UIImage imageWithData:clientFrom.picture];
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
        
        // Product *relatedProduct = [[[ProductModel alloc] init] getProductFromProductId:myOpportunity.product_id];
        Client *clientRelatedToOpportunity = [[[ClientModel alloc] init] getClientFromClientId:myOpportunity.client_id];
        
        // Set client data
        clientImage.image = [UIImage imageWithData:clientRelatedToOpportunity.picture];
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



#pragma mark - Contact with Facebook

- (void) getFBPhotoComments:url forProduct:(Product *)forProduct;
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url
                                                                   parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
    {
        if (!error) {  // FB request was a success!
            
            if (result[@"data"]) {   // There is FB data!
                
                NSArray *commentsArray = result[@"data"];
                
                [self parseFBPhotoComments:commentsArray forProduct:forProduct];
                
                // Review if there are more comments for this photo
                NSString *next = result[@"paging"][@"next"];
                
                if (next && commentsArray.count>=25)
                {
                    [self getFBPhotoComments:[next substringFromIndex:32] forProduct:forProduct];
                }
            }
            else
            {
                [_refreshControl endRefreshing];
            }
            
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error getFBNotifications: %@", error.description);
        }
    }];
}

- (void) parseFBPhotoComments:(NSArray*)commentsArray forProduct:(Product *)forProduct;
{
    // Review each comment
    Message *tempMessage;
    Client *tempClient;
    
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    NSMutableArray *newClientsArray = [[NSMutableArray alloc] init];
    NSMutableArray *commentsIDArray = [[NSMutableArray alloc] init];
    
    for (int j=0; j<commentsArray.count; j=j+1)
    {
        NSDictionary *newMessage = commentsArray[j];
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
            
            tempMessage.fb_photo_id = forProduct.fb_photo_id;
            tempMessage.product_id = forProduct.product_id;
            tempMessage.agent_id = @"00001";
            tempMessage.type = @"P";
            
            if ([tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_user_id] || [tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_page_id])
            {
                // Message from GarageSale
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
        
        // Call method for getting sub comments
        [self makeFBRequestForSubComments:commentsIDArray];
    }
    
    if (newClientsArray.count>0)
    {
        [self makeFBRequestForClientsDetails:newClientsArray];
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
            tempMessage.agent_id = @"00001";
            tempMessage.type = @"P";
            
            if ([tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_user_id] || [tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_page_id])
            {
                // Message from GarageSale
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
        
        /*
        if ([newClient.fb_client_id isEqualToString:_tmpSettings.fb_user_id] || [newClient.fb_client_id isEqualToString:_tmpSettings.fb_page_id]) {
            // Garage Sale
            
            newClient.name = @"Garage";
            newClient.last_name = @"Sale";
            newClient.sex = @"F";
            newClient.picture_link = @"";
            newClient.picture = [NSData dataWithContentsOfFile:@"Garage Sale"];

        }
        */
        
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
                
                // Reload table to include new client details
                [self.tableMessages reloadData];
                
            }
            else {
                // An error occurred, we need to handle the error
                // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                NSLog(@"error makeFBRequestForClientsDetails: %@", error.description);
            }
        }];
    }
}

- (void) addNewMessage:(Message*)newMessage;
{
    MessageModel *messageMethods = [[MessageModel alloc] init];
    
    // Insert message to messages table array
    
    [_myDataMessages insertObject:newMessage atIndex:0];
    
    // Update database
    [messageMethods addNewMessage:newMessage];
    
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
    
}


@end
