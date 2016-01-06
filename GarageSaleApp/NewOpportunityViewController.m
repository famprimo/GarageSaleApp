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


@interface NewOpportunityViewController ()
{
    Client *_clientBuyer;
    Product *_relatedProduct;
    
    OpportunityModel *_opportunityMethods;
    UIActivityIndicatorView *_indicator;
}
@end

@implementation NewOpportunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize objects methods
    _opportunityMethods = [[OpportunityModel alloc] init];
    _opportunityMethods.delegate = self;
    
    _clientBuyer = [[[ClientModel alloc] init] getClientFromClientId:[self.delegate getBuyerIdForOpportunity]];
    _relatedProduct = [[[ProductModel alloc] init] getProductFromProductId:[self.delegate getProductIdForOpportunity]];
    
    CGRect imageProductFrame = self.imageProduct.frame;
    imageProductFrame.origin.x = 13;
    imageProductFrame.origin.y = 85;
    imageProductFrame.size.width = 70;
    imageProductFrame.size.height = 70;
    self.imageProduct.frame = imageProductFrame;

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

    // self.imageProduct.image = [UIImage imageWithData:_relatedProduct.picture];
    self.imageProduct.image = [UIImage imageWithData:[[[ProductModel alloc] init] getProductPhotoFrom:_relatedProduct]];
    
    self.labelProductName.text = _relatedProduct.name;
    self.labelProductGSCode.text = _relatedProduct.codeGS;
    self.labelProductCurrency.text = _relatedProduct.currency;
    self.labelProductDesc.text = _relatedProduct.desc;
    self.labelProductPrice.text = [NSString stringWithFormat:@"%@%@", _relatedProduct.currency, _relatedProduct.price];
    self.textOpportunityPrice.text = [NSString stringWithFormat:@"%@", _relatedProduct.price];
    
    //self.imageClient.image = [UIImage imageWithData:_clientBuyer.picture];
    self.imageClient.image = [UIImage imageWithData:[[[ClientModel alloc] init] getClientPhotoFrom:_clientBuyer]];
    
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
    // Set spinner
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.center = CGPointMake((self.view.bounds.size.width / 2) , (self.view.bounds.size.height / 2));
    
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];

    // Create opportunity
    Opportunity *tempOpportunity = [[Opportunity alloc] init];
    
    tempOpportunity.opportunity_id = [_opportunityMethods getNextOpportunityID];
    tempOpportunity.product_id = _relatedProduct.product_id;
    tempOpportunity.client_id = _clientBuyer.client_id;
    tempOpportunity.initial_price = [NSNumber numberWithFloat:self.textOpportunityPrice.text.intValue];
    tempOpportunity.price_sold = tempOpportunity.initial_price;
    tempOpportunity.created_time = [NSDate date];
    tempOpportunity.closedsold_time = [dateFormat dateFromString:@"20000101"];
    tempOpportunity.paid_time = [dateFormat dateFromString:@"20000101"];
    tempOpportunity.status = @"O";
    tempOpportunity.notes = @"Notas";
    tempOpportunity.commision = [NSNumber numberWithFloat:(tempOpportunity.initial_price.floatValue * 0.1)];
    tempOpportunity.agent_id = @"00001";

    [_opportunityMethods addNewOpportunity:tempOpportunity];
}


#pragma mark methods for OpportunityModel

-(void)opportunitiesSyncedWithCoreData:(BOOL)succeed;
{
    // No need to implement
}

-(void)opportunityAddedOrUpdated:(BOOL)succeed;
{
    // Stop spinner
    [_indicator stopAnimating];
    
    if (succeed)
    {
        [self.delegate opportunityCreated];
    }
}

@end
