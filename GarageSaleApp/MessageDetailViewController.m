//
//  MessageDetailViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "Message.h"
#import "Product.h"
#import "ProductModel.h"
#import "Client.h"
#import "ClientModel.h"
#import "NSDate+NVTimeAgo.h"


@interface MessageDetailViewController ()

// For Popover
@property (nonatomic, strong) UIPopoverController *clientPickerPopover;

@end

@implementation MessageDetailViewController

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
        
        Message *messageSelected = [[Message alloc] init];
        messageSelected = (Message *)_detailItem;

        
        ProductModel *productMethods = [[ProductModel alloc] init];
        Product *productRelatedToMessage = [[Product alloc] init];

        ClientModel *clientMethods = [[ClientModel alloc] init];
        Client *clientRelatedToMessage = [[Client alloc] init];
        Client *ownerRelatedToMessage = [[Client alloc] init];

        // Setting frames for all pictures
        CGRect imageClientFrame = self.imageClient.frame;
        imageClientFrame.origin.x = 49;
        imageClientFrame.origin.y = 55;
        imageClientFrame.size.width = 70;
        imageClientFrame.size.height = 70;
        self.imageClient.frame = imageClientFrame;

        CGRect imageClientStatusFrame = self.imageClientStatus.frame;
        imageClientStatusFrame.origin.x = 134;
        imageClientStatusFrame.origin.y = 60;
        imageClientStatusFrame.size.width = 10;
        imageClientStatusFrame.size.height = 10;
        self.imageClientStatus.frame = imageClientStatusFrame;

        CGRect picClientPhoneFrame = self.picClientPhone.frame;
        picClientPhoneFrame.origin.x = 134;
        picClientPhoneFrame.origin.y = 121;
        picClientPhoneFrame.size.width = 15;
        picClientPhoneFrame.size.height = 15;
        self.picClientPhone.frame = picClientPhoneFrame;

        CGRect imageProductFrame = self.imageProduct.frame;
        imageProductFrame.origin.x = 16;
        imageProductFrame.origin.y = 517;
        imageProductFrame.size.width = 70;
        imageProductFrame.size.height = 70;
        self.imageProduct.frame = imageProductFrame;

        CGRect imageProductSoldFrame = self.imageProductSold.frame;
        imageProductSoldFrame.origin.x = 16;
        imageProductSoldFrame.origin.y = 531;
        imageProductSoldFrame.size.width = 70;
        imageProductSoldFrame.size.height = 40;
        self.imageProductSold.frame = imageProductSoldFrame;

        CGRect imageOwnerFrame = self.imageOwner.frame;
        imageOwnerFrame.origin.x = 16;
        imageOwnerFrame.origin.y = 661;
        imageOwnerFrame.size.width = 70;
        imageOwnerFrame.size.height = 70;
        self.imageOwner.frame = imageOwnerFrame;
        
        CGRect imageOwnerStatusFrame = self.imageOwnerStatus.frame;
        imageOwnerStatusFrame.origin.x = 99;
        imageOwnerStatusFrame.origin.y = 664;
        imageOwnerStatusFrame.size.width = 10;
        imageOwnerStatusFrame.size.height = 10;
        self.imageOwnerStatus.frame = imageOwnerStatusFrame;
        
        CGRect picOwnerZoneFrame = self.picOwnerZone.frame;
        picOwnerZoneFrame.origin.x = 99;
        picOwnerZoneFrame.origin.y = 690;
        picOwnerZoneFrame.size.width = 15;
        picOwnerZoneFrame.size.height = 15;
        self.picOwnerZone.frame = picOwnerZoneFrame;
        
        CGRect picOwnerPhoneFrame = self.picOwnerPhone.frame;
        picOwnerPhoneFrame.origin.x = 99;
        picOwnerPhoneFrame.origin.y = 736;
        picOwnerPhoneFrame.size.width = 15;
        picOwnerPhoneFrame.size.height = 15;
        self.picOwnerPhone.frame = picOwnerPhoneFrame;
        
        CGRect buttonRelateToOwnerFrame = self.buttonRelateToOwner.frame;
        buttonRelateToOwnerFrame.origin.x = 70;
        buttonRelateToOwnerFrame.origin.y = 615;
        buttonRelateToOwnerFrame.size.width = 220;
        buttonRelateToOwnerFrame.size.height = 44;
        self.buttonRelateToOwner.frame = buttonRelateToOwnerFrame;

        // Set Message Data
        
        clientRelatedToMessage = [clientMethods getClientFromClientId:messageSelected.client_id];
        
        // Client name and status
        if ([clientRelatedToMessage.status isEqualToString:@"V"])
        {
            self.labelClientName.text = [NSString stringWithFormat:@"    %@ %@", clientRelatedToMessage.name, clientRelatedToMessage.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", clientRelatedToMessage.name, clientRelatedToMessage.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Blank"];
        }
        
        self.labelMessage.text = messageSelected.message;
        // [self.labelMessage sizeToFit];
        
        self.labelClientPhone.text = clientRelatedToMessage.phone1;
        self.imageClient.image = [UIImage imageWithData:clientRelatedToMessage.picture];
        self.labelMessageDate.text = [messageSelected.datetime formattedAsTimeAgo];
        
        
        self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
        
        // Set data for product related to the message if any
        if ([messageSelected.product_id length] > 0)
        {
            productRelatedToMessage = [productMethods getProductFromProductId:messageSelected.product_id];
            self.imageProduct.image = [UIImage imageWithData:productRelatedToMessage.picture];
            
            // Set sold image if product is sold
            if ([productRelatedToMessage.status isEqualToString:@"S"])
            {
                self.imageProductSold.image = [UIImage imageNamed:@"Sold"];
            }

            self.labelProductDetails.text = productRelatedToMessage.desc;

            // Set data for owner if assigned
            
            if ([productRelatedToMessage.client_id length] > 0)
            {
                ownerRelatedToMessage = [clientMethods getClientFromClientId:productRelatedToMessage.client_id];
                
                self.LabelProductRelated.text = @"Producto al que hace referencia:";
                self.labelPublishedAgo.text = @"Publicado hace ... por:";
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
                self.picOwnerPhone.hidden = NO;
                self.picOwnerZone.hidden = NO;
            }
            else
            {
                self.imageOwner.image = [UIImage imageNamed:@"Blank"];
                self.LabelProductRelated.text = @"";
                self.labelPublishedAgo.text = @"";
                self.labelOwnerName.text = @"";
                self.imageOwnerStatus.image = [UIImage imageNamed:@"Blank"];
                self.labelOwnerZone.text = @"";
                self.labelOwnerAddress.text = @"";
                self.labelOwnerPhones.text = @"";
                self.buttonRelateToOwner.hidden = NO;
                self.buttonSeeInFacebook.hidden = YES;
                self.buttonMessageToOwner.hidden = YES;
                self.picOwnerPhone.hidden = YES;
                self.picOwnerZone.hidden = YES;
            }
        }
        else
        {
            // Blank objects related to the product;
            
            self.imageProduct.image = [UIImage imageNamed:@"Blank"];
            self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
            self.imageOwner.image = [UIImage imageNamed:@"Blank"];

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
            self.picOwnerPhone.hidden = YES;
            self.picOwnerZone.hidden = YES;
        }
        
    }
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


@end
