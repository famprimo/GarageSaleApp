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

        CGRect imageProductFrame = self.imageProduct.frame;
        imageProductFrame.origin.x = 16;
        imageProductFrame.origin.y = 478;
        imageProductFrame.size.width = 70;
        imageProductFrame.size.height = 70;
        self.imageProduct.frame = imageProductFrame;

        CGRect imageProductSoldFrame = self.imageProductSold.frame;
        imageProductSoldFrame.origin.x = 16;
        imageProductSoldFrame.origin.y = 492;
        imageProductSoldFrame.size.width = 70;
        imageProductSoldFrame.size.height = 40;
        self.imageProductSold.frame = imageProductSoldFrame;

        CGRect imageOwnerFrame = self.imageOwner.frame;
        imageOwnerFrame.origin.x = 16;
        imageOwnerFrame.origin.y = 598;
        imageOwnerFrame.size.width = 70;
        imageOwnerFrame.size.height = 70;
        self.imageOwner.frame = imageOwnerFrame;
        
        CGRect buttonRelateToOwnerFrame = self.buttonRelateToOwner.frame;
        buttonRelateToOwnerFrame.origin.x = 70;
        buttonRelateToOwnerFrame.origin.y = 615;
        buttonRelateToOwnerFrame.size.width = 220;
        buttonRelateToOwnerFrame.size.height = 44;
        self.buttonRelateToOwner.frame = buttonRelateToOwnerFrame;

        // Set Message Data
        
        clientRelatedToMessage = [clientMethods getClientFromClientId:messageSelected.client_id];
        
        self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", clientRelatedToMessage.name, clientRelatedToMessage.last_name];
        
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
                
                self.imageOwner.image = [UIImage imageWithData:ownerRelatedToMessage.picture];
                self.labelOwnerName.text = [NSString stringWithFormat:@"%@ %@", ownerRelatedToMessage.name, ownerRelatedToMessage.last_name];
                self.labelOwnerZone.text = [NSString stringWithFormat:@"Vive en %@",ownerRelatedToMessage.zone];
                self.labelOwnerAddress.text = ownerRelatedToMessage.address;
                self.labelOwnerPhones.text = ownerRelatedToMessage.phone1;
                self.buttonRelateToOwner.hidden = YES;

            }
            else
            {
                self.imageOwner.image = [UIImage imageNamed:@"Blank"];
                self.labelOwnerName.text = @"";
                self.labelOwnerZone.text = @"";
                self.labelOwnerAddress.text = @"";
                self.labelOwnerPhones.text = @"";
                self.buttonRelateToOwner.hidden = NO;
            }
        }
        else
        {
            // Blank objects related to the product;
            
            self.imageProduct.image = [UIImage imageNamed:@"Blank"];
            self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
            self.imageOwner.image = [UIImage imageNamed:@"Blank"];

            self.labelProductDetails.text = @"";
            self.labelOwnerName.text = @"";
            self.labelOwnerZone.text = @"";
            self.labelOwnerAddress.text = @"";
            self.labelOwnerPhones.text = @"";

        }
        
    }
}

@end
