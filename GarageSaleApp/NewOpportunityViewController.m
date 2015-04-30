//
//  NewOpportunityViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 19/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "NewOpportunityViewController.h"
#import "Client.h"
#import "ClientModel.h"
#import "Product.h"
#import "ProductModel.h"
#import "Opportunity.h"
#import "OpportunityModel.h"


@interface NewOpportunityViewController ()
{
    Client *_clientBuyer;
    Product *_relatedProduct;

}
@end

@implementation NewOpportunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _clientBuyer = [[[ClientModel alloc] init] getClientFromClientId:[self.delegate GetBuyerIdForOpportunity]];
    _relatedProduct = [[[ProductModel alloc] init] getProductFromProductId:[self.delegate GetProductIdForOpportunity]];
    
    CGRect imageProductFrame = self.imageProduct.frame;
    imageProductFrame.origin.x = 13;
    imageProductFrame.origin.y = 85;
    imageProductFrame.size.width = 70;
    imageProductFrame.size.height = 70;
    self.imageProduct.frame = imageProductFrame;

    CGRect imageSoldFrame = self.imageSold.frame;
    imageSoldFrame.origin.x = 13;
    imageSoldFrame.origin.y = 100;
    imageSoldFrame.size.width = 70;
    imageSoldFrame.size.height = 40;
    self.imageSold.frame = imageSoldFrame;
    
    CGRect imageClientFrame = self.imageClient.frame;
    imageClientFrame.origin.x = 252;
    imageClientFrame.origin.y = 85;
    imageClientFrame.size.width = 40;
    imageClientFrame.size.height = 40;
    self.imageClient.frame = imageClientFrame;
    
    CGRect imageClientStatusFrame = self.imageClientStatus.frame;
    imageClientStatusFrame.origin.x = 299;
    imageClientStatusFrame.origin.y = 100;
    imageClientStatusFrame.size.width = 10;
    imageClientStatusFrame.size.height = 10;
    self.imageClientStatus.frame = imageClientStatusFrame;

    self.imageProduct.image = [UIImage imageWithData:_relatedProduct.picture];
    if ([_relatedProduct.status isEqualToString:@"S"])
    {
        self.imageSold.image = [UIImage imageNamed:@"Sold"];
    }
    else
    {
         self.imageSold.image = [UIImage imageNamed:@"Blank"];
    }
    self.labelProductName.text = _relatedProduct.name;
    self.labelProductGSCode.text = _relatedProduct.GS_code;
    self.labelProductCurrency.text = _relatedProduct.currency;
    self.labelProductDesc.text = _relatedProduct.desc;
    self.labelProductPrice.text = [NSString stringWithFormat:@"%@%.f", _relatedProduct.currency, _relatedProduct.price];
    self.textOpportunityPrice.text = [NSString stringWithFormat:@"%.f", _relatedProduct.price];
    
    self.imageClient.image = [UIImage imageWithData:_clientBuyer.picture];
    
    if ([_clientBuyer.status isEqualToString:@"V"])
    {
        self.labelClientName.text = [NSString stringWithFormat:@"    %@ %@", _clientBuyer.name, _clientBuyer.last_name];
        self.imageClientStatus.image = [UIImage imageNamed:@"Verified"];
    }
    else
    {
        self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", _clientBuyer.name, _clientBuyer.last_name];
        self.imageClientStatus.image = [UIImage imageNamed:@"Blank"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createOpportunity:(id)sender
{
    // Create opportunity
    OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];
    Opportunity *tempOpportunity = [[Opportunity alloc] init];
    
    tempOpportunity.opportunity_id = [opportunityMethods getNextOpportunityID];
    tempOpportunity.product_id = _relatedProduct.product_id;
    tempOpportunity.client_id = _clientBuyer.client_id;
    tempOpportunity.initial_price = self.textOpportunityPrice.text.intValue;
    tempOpportunity.price_sold = tempOpportunity.initial_price;
    tempOpportunity.created_time = [NSDate date];
    tempOpportunity.closedsold_time = nil;
    tempOpportunity.paid_time = nil;
    tempOpportunity.status = @"O";
    tempOpportunity.notes = @"Notas";
    tempOpportunity.commision = tempOpportunity.initial_price * 0.1;
    tempOpportunity.agent_id = @"00001";

    [opportunityMethods addNewOpportunity:tempOpportunity];
    
    [self.delegate OpportunityCreated];

}


@end
