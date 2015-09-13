//
//  OpportunityDetailViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 21/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "OpportunityDetailViewController.h"
#import "Opportunity.h"
#import "OpportunityModel.h"
#import "Client.h"
#import "ClientModel.h"
#import "Product.h"
#import "ProductModel.h"
#import "NSDate+NVTimeAgo.h"


@interface OpportunityDetailViewController ()
{
    Opportunity *_selectedOpportunity;
    Product *_selectedProduct;
    Client *_selectedClientOwner;
    Client *_selectedClientBuyer;
    
    NSString *_templateTypeForPopover;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *sendMessagePopover;
@property (nonatomic, strong) UIPopoverController *editOpportunityPopover;

@end

@implementation OpportunityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectedOpportunity = [[Opportunity alloc] init];
    
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
    
    ClientModel *clientMethods = [[ClientModel alloc] init];
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    if (self.detailItem) {
        // Asign values to objects in View
        
        _selectedOpportunity = (Opportunity *)_detailItem;
        
        _selectedProduct = [productMethods getProductFromProductId:_selectedOpportunity.product_id];
        _selectedClientBuyer = [clientMethods getClientFromClientId:_selectedOpportunity.client_id];
        _selectedClientOwner = [clientMethods getClientFromClientId:_selectedProduct.client_id];

        CGRect imageProductFrame = self.imageProduct.frame;
        imageProductFrame.origin.x = 31;
        imageProductFrame.origin.y = 128;
        imageProductFrame.size.width = 140;
        imageProductFrame.size.height = 140;
        self.imageProduct.frame = imageProductFrame;
        
        CGRect labelDescriptionFrame = self.labelDescription.frame;
        labelDescriptionFrame.origin.x = 186;
        labelDescriptionFrame.origin.y = 128;
        labelDescriptionFrame.size.width = 203;
        labelDescriptionFrame.size.height = 140;
        self.labelDescription.frame = labelDescriptionFrame;

        CGRect imageOwnerFrame = self.imageOwner.frame;
        imageOwnerFrame.origin.x = 31;
        imageOwnerFrame.origin.y = 396;
        imageOwnerFrame.size.width = 70;
        imageOwnerFrame.size.height = 70;
        self.imageOwner.frame = imageOwnerFrame;
        
        CGRect imageOwnerStatusFrame = self.imageOwnerStatus.frame;
        imageOwnerStatusFrame.origin.x = 109;
        imageOwnerStatusFrame.origin.y = 402;
        imageOwnerStatusFrame.size.width = 10;
        imageOwnerStatusFrame.size.height = 10;
        self.imageOwnerStatus.frame = imageOwnerStatusFrame;
        
        CGRect picOwnerZoneFrame = self.picOwnerZone.frame;
        picOwnerZoneFrame.origin.x = 109;
        picOwnerZoneFrame.origin.y = 477;
        picOwnerZoneFrame.size.width = 15;
        picOwnerZoneFrame.size.height = 15;
        self.picOwnerZone.frame = picOwnerZoneFrame;

        CGRect picOwnerPhoneFrame = self.picOwnerPhone.frame;
        picOwnerPhoneFrame.origin.x = 109;
        picOwnerPhoneFrame.origin.y = 500;
        picOwnerPhoneFrame.size.width = 15;
        picOwnerPhoneFrame.size.height = 15;
        self.picOwnerPhone.frame = picOwnerPhoneFrame;

        CGRect labelOwnerAddressFrame = self.labelOwnerAddress.frame;
        labelOwnerAddressFrame.origin.x = 109;
        labelOwnerAddressFrame.origin.y = 420;
        labelOwnerAddressFrame.size.width = 212;
        labelOwnerAddressFrame.size.height = 46;
        self.labelOwnerAddress.frame = labelOwnerAddressFrame;

        CGRect imageBuyerFrame = self.imageBuyer.frame;
        imageBuyerFrame.origin.x = 374;
        imageBuyerFrame.origin.y = 396;
        imageBuyerFrame.size.width = 70;
        imageBuyerFrame.size.height = 70;
        self.imageBuyer.frame = imageBuyerFrame;
        
        CGRect imageBuyerStatusFrame = self.imageBuyerStatus.frame;
        imageBuyerStatusFrame.origin.x = 452;
        imageBuyerStatusFrame.origin.y = 402;
        imageBuyerStatusFrame.size.width = 10;
        imageBuyerStatusFrame.size.height = 10;
        self.imageBuyerStatus.frame = imageBuyerStatusFrame;
        
        CGRect picBuyerZoneFrame = self.picBuyerZone.frame;
        picBuyerZoneFrame.origin.x = 452;
        picBuyerZoneFrame.origin.y = 477;
        picBuyerZoneFrame.size.width = 15;
        picBuyerZoneFrame.size.height = 15;
        self.picBuyerZone.frame = picBuyerZoneFrame;
        
        CGRect picBuyerPhoneFrame = self.picBuyerPhone.frame;
        picBuyerPhoneFrame.origin.x = 452;
        picBuyerPhoneFrame.origin.y = 500;
        picBuyerPhoneFrame.size.width = 15;
        picBuyerPhoneFrame.size.height = 15;
        self.picBuyerPhone.frame = picBuyerPhoneFrame;
        
        CGRect labelBuyerAddressFrame = self.labelBuyerAddress.frame;
        labelBuyerAddressFrame.origin.x = 452;
        labelBuyerAddressFrame.origin.y = 420;
        labelBuyerAddressFrame.size.width = 212;
        labelBuyerAddressFrame.size.height = 46;
        self.labelBuyerAddress.frame = labelBuyerAddressFrame;
        
        CGRect labelOpportunityNotesFrame = self.labelOpportunityNotes.frame;
        labelOpportunityNotesFrame.origin.x = 95;
        labelOpportunityNotesFrame.origin.y = 607;
        labelOpportunityNotesFrame.size.width = 564;
        labelOpportunityNotesFrame.size.height = 83;
        self.labelOpportunityNotes.frame = labelOpportunityNotesFrame;


        // Set Opportunity Data
        
        if ([_selectedOpportunity.status isEqualToString:@"S"])
        {
            self.labelOpportunityPrice.text = [NSString stringWithFormat:@"%@%@", _selectedProduct.currency, _selectedOpportunity.price_sold];
        }
        else
        {
            self.labelOpportunityPrice.text = [NSString stringWithFormat:@"%@%@", _selectedProduct.currency, _selectedOpportunity.initial_price];
        }
        self.labelOpportunityCommision.text = [NSString stringWithFormat:@"%@%@", _selectedProduct.currency, _selectedOpportunity.commision];
        
        self.labelOpportunityCreatedDate.text = [NSString stringWithFormat:@"Creada el %@", [_selectedOpportunity.created_time formattedAsDateComplete]];
        
        if ([_selectedOpportunity.status isEqualToString:@"O"])
        {
            self.labelOpportunityStatus.text = @"ABIERTA";
            self.labelOpportunityStatus.textColor = [UIColor whiteColor];
            self.buttonUpdate.backgroundColor = [UIColor blueColor];
            
            self.labelOpportunityClosedDate.text = @"";
            self.labelOpportunitySoldDate.text = @"";
            self.labelOpportunityPaidDate.text = @"";
        }
        else if ([_selectedOpportunity.status isEqualToString:@"C"])
        {
            self.labelOpportunityStatus.text = @"CERRADA";
            self.labelOpportunityStatus.textColor = [UIColor blackColor];
            self.buttonUpdate.backgroundColor = [UIColor grayColor];

            self.labelOpportunityClosedDate.text = [NSString stringWithFormat:@"Cerrada el %@", [_selectedOpportunity.closedsold_time formattedAsDateComplete]];
            self.labelOpportunitySoldDate.text = @"";
            self.labelOpportunityPaidDate.text = @"";
        }
        else if ([_selectedOpportunity.status isEqualToString:@"S"])
        {
            self.labelOpportunityStatus.text = @"VENDIDA";
            self.labelOpportunityStatus.textColor = [UIColor whiteColor];
            self.buttonUpdate.backgroundColor = [UIColor redColor];

            self.labelOpportunityClosedDate.text = @"";
            self.labelOpportunitySoldDate.text = [NSString stringWithFormat:@"Vendida el %@", [_selectedOpportunity.closedsold_time formattedAsDateComplete]];
            self.labelOpportunityPaidDate.text = @"";
        }
        else
        {
            self.labelOpportunityStatus.text = @"PAGADA";
            self.labelOpportunityStatus.textColor = [UIColor blackColor];
            self.buttonUpdate.backgroundColor = [UIColor greenColor];
            
            self.labelOpportunityClosedDate.text = @"";
            self.labelOpportunitySoldDate.text = [NSString stringWithFormat:@"Vendida el %@", [_selectedOpportunity.closedsold_time formattedAsDateComplete]];
            self.labelOpportunityPaidDate.text = [NSString stringWithFormat:@"Comisión pagada el %@", [_selectedOpportunity.paid_time formattedAsDateComplete]];
        }

        self.labelOpportunityNotes.text = _selectedOpportunity.notes;
        self.labelOpportunityNotes.numberOfLines = 0;
        [self.labelOpportunityNotes sizeToFit];
        
        // Set Product Data
        
        // self.imageProduct.image = [UIImage imageWithData:_selectedProduct.picture];
        self.imageProduct.image = [UIImage imageWithData:[productMethods getProductPhotoFrom:_selectedProduct]];
        
        self.labelProductName.text = _selectedProduct.name;
        if ([_selectedProduct.type isEqualToString:@"S"])
        {
            self.labelPrice.text = [NSString stringWithFormat:@"%@%@", _selectedProduct.currency, _selectedProduct.price];
        }
        else // @"A"
        {
            self.labelPrice.text = @"Publicidad";
        }
        
        self.labelGSCode.text = _selectedProduct.codeGS;
        
        self.labelDescription.text = _selectedProduct.desc;
        self.labelDescription.numberOfLines = 0;
        [self.labelDescription sizeToFit];
        
        labelDescriptionFrame = self.labelDescription.frame;
        if (labelDescriptionFrame.size.height > 180)
        {   labelDescriptionFrame.size.height = 180;
            self.labelDescription.frame = labelDescriptionFrame; }
        
        // Set Owner Data
        
        if ([_selectedClientOwner.sex isEqualToString:@"M"])
        {
            self.labelOwnerIntro.text = @"Dueño:";
        }
        else
        {
            self.labelOwnerIntro.text = @"Dueña:";
        }

        // Make owners picture rounded
        self.imageOwner.layer.cornerRadius = self.imageOwner.frame.size.width / 2;
        self.imageOwner.clipsToBounds = YES;
        
        //self.imageOwner.image = [UIImage imageWithData:_selectedClientOwner.picture];
        self.imageOwner.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:_selectedClientOwner]];
        self.labelOwnerZone.text = [NSString stringWithFormat:@"Vive en %@",_selectedClientOwner.client_zone];
        self.labelOwnerPhones.text = _selectedClientOwner.phone1;
        
        // Owner Address
        self.labelOwnerAddress.text = _selectedClientOwner.address;
        self.labelOwnerAddress.numberOfLines = 0;
        [self.labelOwnerAddress sizeToFit];
        
        labelOwnerAddressFrame = self.labelOwnerAddress.frame;
        if (labelOwnerAddressFrame.size.height > 52)
        {   labelOwnerAddressFrame.size.height = 52;
            self.labelOwnerAddress.frame = labelOwnerAddressFrame; }
        
        // Owner name and status
        if ([_selectedClientOwner.status isEqualToString:@"V"])
        {
            self.labelOwnerName.text = [NSString stringWithFormat:@"    %@ %@", _selectedClientOwner.name, _selectedClientOwner.last_name];
            self.imageOwnerStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            self.labelOwnerName.text = [NSString stringWithFormat:@"%@ %@", _selectedClientOwner.name, _selectedClientOwner.last_name];
            self.imageOwnerStatus.image = [UIImage imageNamed:@"Blank"];
        }
        
        // Set Buyer Data
        
        if ([_selectedClientBuyer.sex isEqualToString:@"M"])
        {
            self.labelBuyerIntro.text = @"Comprador:";
        }
        else
        {
            self.labelBuyerIntro.text = @"Compradora:";
        }

        // Make buyer picture rounded
        self.imageBuyer.layer.cornerRadius = self.imageBuyer.frame.size.width / 2;
        self.imageBuyer.clipsToBounds = YES;
        
        //self.imageBuyer.image = [UIImage imageWithData:_selectedClientBuyer.picture];
        self.imageBuyer.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:_selectedClientBuyer]];
        self.labelBuyerZone.text = [NSString stringWithFormat:@"Vive en %@",_selectedClientBuyer.client_zone];
        self.labelBuyerPhones.text = _selectedClientBuyer.phone1;
        
        // Buyer Address
        self.labelBuyerAddress.text = _selectedClientBuyer.address;
        self.labelBuyerAddress.numberOfLines = 0;
        [self.labelBuyerAddress sizeToFit];
        
        labelBuyerAddressFrame = self.labelBuyerAddress.frame;
        if (labelBuyerAddressFrame.size.height > 52)
        {   labelBuyerAddressFrame.size.height = 52;
            self.labelBuyerAddress.frame = labelBuyerAddressFrame; }
        
        // Buyer name and status
        if ([_selectedClientBuyer.status isEqualToString:@"V"])
        {
            self.labelBuyerName.text = [NSString stringWithFormat:@"    %@ %@", _selectedClientBuyer.name, _selectedClientBuyer.last_name];
            self.imageBuyerStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            self.labelBuyerName.text = [NSString stringWithFormat:@"%@ %@", _selectedClientBuyer.name, _selectedClientBuyer.last_name];
            self.imageBuyerStatus.image = [UIImage imageNamed:@"Blank"];
        }
        
        
    }
}


#pragma mark - Managing button actions

- (IBAction)updateOpportunityStatus:(id)sender
{
    EditOpportunityViewController *editOpportunityController = [[EditOpportunityViewController alloc] initWithNibName:@"EditOpportunityViewController" bundle:nil];
    editOpportunityController.delegate = self;
    
    self.editOpportunityPopover = [[UIPopoverController alloc] initWithContentViewController:editOpportunityController];
    self.editOpportunityPopover.popoverContentSize = CGSizeMake(700.0, 380.0);
    [self.editOpportunityPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];

}

- (IBAction)sendMessageToOwner:(id)sender
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

- (IBAction)sendMessageToBuyer:(id)sender
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


#pragma mark - Delegate methods for EditOpportunity

-(Opportunity *)getOpportunityforEdit;
{
    return _selectedOpportunity;
}

-(void)opportunityEdited:(Opportunity *)editedOpportunity;
{
    // Dismiss the popover view
    [self.editOpportunityPopover dismissPopoverAnimated:YES];
    
    [self configureView];
    [self.delegate opportunityUpdated];
}


#pragma mark - Delegate methods for SendMessages

-(NSString*)getTemplateTypeFromMessage;
{
    return _templateTypeForPopover;
}

-(NSString*)getBuyerIdFromMessage;
{
    return _selectedClientBuyer.client_id;
}

-(NSString*)getOwnerIdFromMessage;
{
    return _selectedClientOwner.client_id;
}

-(NSString*)getProductIdFromMessage;
{
    return _selectedProduct.product_id;
}

-(NSString*)getMessageIdFromMessage;
{
    return @"";
}


-(void)messageSent:(NSString*)postType; // postType = (P)hoto (I)nbox (M)essage
{
    // Dismiss the popover view
    [self.sendMessagePopover dismissPopoverAnimated:YES];
    
}


@end
