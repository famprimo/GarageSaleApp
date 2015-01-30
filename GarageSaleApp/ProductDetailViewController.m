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
#import "NSDate+NVTimeAgo.h"


@interface ProductDetailViewController ()

{
    // Data for the table
    NSMutableArray *_myDataOpportunities;
    
    NSString *_templateTypeForPopover;
    NSString *_clientPickerOrigin;
    id _buttonOrigin;
    NSString *_buyerSelected;
    
    Opportunity *_selectedOpportunity;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *clientPickerPopover;
@property (nonatomic, strong) UIPopoverController *sendMessagePopover;
@property (nonatomic, strong) UIPopoverController *createOpportunityPopover;
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
    self.tableOpportunities.delegate = self;
    self.tableOpportunities.dataSource = self;

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
        
        // Setting frames for all pictures
        CGRect productImageFrame = self.imageProduct.frame;
        productImageFrame.origin.x = 90;
        productImageFrame.origin.y = 80;
        productImageFrame.size.width = 200;
        productImageFrame.size.height = 200;
        self.imageProduct.frame = productImageFrame;

        CGRect soldImageFrame = self.imageProductSold.frame;
        soldImageFrame.origin.x = 90;
        soldImageFrame.origin.y = 124;
        soldImageFrame.size.width = 200;
        soldImageFrame.size.height = 111;
        self.imageProductSold.frame = soldImageFrame;
        
        CGRect imageOwnerFrame = self.imageOwner.frame;
        imageOwnerFrame.origin.x = 383;
        imageOwnerFrame.origin.y = 148;
        imageOwnerFrame.size.width = 70;
        imageOwnerFrame.size.height = 70;
        self.imageOwner.frame = imageOwnerFrame;
        
        CGRect imageOwnerStatusFrame = self.imageOwnerStatus.frame;
        imageOwnerStatusFrame.origin.x = 466;
        imageOwnerStatusFrame.origin.y = 151;
        imageOwnerStatusFrame.size.width = 10;
        imageOwnerStatusFrame.size.height = 10;
        self.imageOwnerStatus.frame = imageOwnerStatusFrame;
        
        CGRect picOwnerZoneFrame = self.picOwnerZone.frame;
        picOwnerZoneFrame.origin.x = 466;
        picOwnerZoneFrame.origin.y = 177;
        picOwnerZoneFrame.size.width = 15;
        picOwnerZoneFrame.size.height = 15;
        self.picOwnerZone.frame = picOwnerZoneFrame;
        
        CGRect picOwnerPhoneFrame = self.picOwnerPhone.frame;
        picOwnerPhoneFrame.origin.x = 466;
        picOwnerPhoneFrame.origin.y = 249;
        picOwnerPhoneFrame.size.width = 15;
        picOwnerPhoneFrame.size.height = 15;
        self.picOwnerPhone.frame = picOwnerPhoneFrame;

        CGRect labelDescriptionFrame = self.labelDescription.frame;
        labelDescriptionFrame.origin.x = 32;
        labelDescriptionFrame.origin.y = 417;
        labelDescriptionFrame.size.width = 318;
        labelDescriptionFrame.size.height = 90;
        self.labelDescription.frame = labelDescriptionFrame;

        CGRect labelNotesFrame = self.labelNotes.frame;
        labelNotesFrame.origin.x = 32;
        labelNotesFrame.origin.y = 576;
        labelNotesFrame.size.width = 318;
        labelNotesFrame.size.height = 101;
        self.labelNotes.frame = labelNotesFrame;


        // Set data
        self.imageProduct.image = [UIImage imageWithData:productSelected.picture];
        self.labelProductName.text = productSelected.name;
        if ([productSelected.type isEqualToString:@"S"])
        {
            self.labelProductType.text = @"Venta";
        }
        else // @"A"
        {
            self.labelProductType.text = @"Publicidad";
        }
        
        self.labelGSCode.text = productSelected.GS_code;
        self.labelPrice.text = [NSString stringWithFormat:@"%@%.f", productSelected.currency, productSelected.published_price];
        self.labelInitialPrice.text = [NSString stringWithFormat:@"Precio inicial %@%.f", productSelected.currency, productSelected.initial_price];
        self.labelCreationDate.text = [productSelected.created_time formattedAsDateComplete];
        
        self.labelDescription.text = productSelected.desc;
        self.labelDescription.numberOfLines = 0;
        [self.labelDescription sizeToFit];

        labelDescriptionFrame = self.labelDescription.frame;
        if (labelDescriptionFrame.size.height > 90)
        {   labelDescriptionFrame.size.height = 90;
            self.labelDescription.frame = labelDescriptionFrame; }

        self.labelNotes.text = productSelected.notes;
        self.labelNotes.numberOfLines = 0;
        [self.labelNotes sizeToFit];

        labelNotesFrame = self.labelNotes.frame;
        if (labelNotesFrame.size.height > 101)
        {   labelNotesFrame.size.height = 101;
            self.labelNotes.frame = labelNotesFrame; }

        // Set button and sold image depending on message status
        if ([productSelected.status isEqualToString:@"N"])
        {
            self.buttonStatus.backgroundColor = [UIColor blueColor];
            self.buttonStatus.titleLabel.textColor = [UIColor whiteColor];
            //self.buttonStatus.titleLabel.text = @"Nuevo     ";
            [self.buttonStatus setTitle:@"Nuevo     " forState:UIControlStateNormal];
            self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
        }
        else if ([productSelected.status isEqualToString:@"S"])
        {
            self.buttonStatus.backgroundColor = [UIColor grayColor];
            self.buttonStatus.titleLabel.textColor = [UIColor blackColor];
            self.buttonStatus.titleLabel.text = @"Vendido     ";
            self.imageProductSold.image = [UIImage imageNamed:@"Sold"];
        }
        else if ([productSelected.status isEqualToString:@"D"])
        {
            self.buttonStatus.backgroundColor = [UIColor redColor];
            self.buttonStatus.titleLabel.textColor = [UIColor whiteColor];
            self.buttonStatus.titleLabel.text = @"Deshabilitado     ";
            self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
        }
        else // @"U"
        {
            self.buttonStatus.backgroundColor = [UIColor grayColor];
            self.buttonStatus.titleLabel.textColor = [UIColor blackColor];
            self.buttonStatus.titleLabel.text = @"Actualizado     ";
            self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
        }

        // Make owners picture rounded
        self.imageOwner.layer.cornerRadius = self.imageOwner.frame.size.width / 2;
        self.imageOwner.clipsToBounds = YES;
        
        // Set data for owner if assigned
        
        if ([productSelected.client_id length] > 0)
        {
            Client *ownerForProduct = [clientMethods getClientFromClientId:productSelected.client_id];
            
            self.labelPublishedAgo.text = @"Publicado hace ... por:";
            self.imageOwner.image = [UIImage imageWithData:ownerForProduct.picture];
            self.labelOwnerZone.text = [NSString stringWithFormat:@"Vive en %@",ownerForProduct.zone];
            self.labelOwnerAddress.text = ownerForProduct.address;
            self.labelOwnerPhones.text = ownerForProduct.phone1;
            
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
        
        // Ge opportunitie related to product
        _myDataOpportunities = [opportunityMethods getOpportunitiesFromProduct:productSelected.product_id];
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
    self.sendMessagePopover.popoverContentSize = CGSizeMake(600.0, 400.0);
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
    self.sendMessagePopover.popoverContentSize = CGSizeMake(600.0, 400.0);
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
    
    return _selectedOpportunity.buyer_id;
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _myDataOpportunities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    // Retrieve cell
    NSString *cellIdentifier = @"CellOpp";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Get the opportunity to be shown
    Opportunity *myOpportunity = _myDataOpportunities[indexPath.row];
    Client *clientRelatedToOpportunity = [clientMethods getClientFromClientId:myOpportunity.buyer_id];
    
    // Get references to images and labels of cell
    UILabel *clientName = (UILabel*)[myCell.contentView viewWithTag:1];
    UILabel *opportunityStatus = (UILabel*)[myCell.contentView viewWithTag:2];
    UILabel *opportunityDates = (UILabel*)[myCell.contentView viewWithTag:3];
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
    if ([myOpportunity.status isEqualToString:@"O"])
    {
        opportunityStatus.text = @"Abierta";
        opportunityDates.text = [NSString stringWithFormat:@"Datos enviados %@",[myOpportunity.created_time formattedAsTimeAgo]];
    }
    else if ([myOpportunity.status isEqualToString:@"C"])
    {
        opportunityStatus.text = @"Cerrada";
        opportunityDates.text = [NSString stringWithFormat:@"Datos enviados %@, cerrado %@",[myOpportunity.created_time formattedAsTimeAgo], [myOpportunity.closedsold_time formattedAsTimeAgo]];
    }
    else if ([myOpportunity.status isEqualToString:@"S"])
    {
        opportunityStatus.text = @"Vendido";
        opportunityDates.text = [NSString stringWithFormat:@"Datos enviados %@, vendido %@",[myOpportunity.created_time formattedAsTimeAgo], [myOpportunity.closedsold_time formattedAsTimeAgo]];
    }
    else if ([myOpportunity.status isEqualToString:@"P"])
    {
        opportunityStatus.text = @"Pagado";
        opportunityDates.text = [NSString stringWithFormat:@"Datos enviados %@, vendido %@, pagado %@",[myOpportunity.created_time formattedAsTimeAgo], [myOpportunity.closedsold_time formattedAsTimeAgo], [myOpportunity.paid_time formattedAsTimeAgo]];
    }
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedOpportunity = _myDataOpportunities[indexPath.row];
    
    self.buttonMessageToBuyer.enabled = YES;
}


@end
