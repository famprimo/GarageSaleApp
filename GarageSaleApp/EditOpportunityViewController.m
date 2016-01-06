//
//  EditOpportunityViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/05/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "EditOpportunityViewController.h"
#import "Client.h"
#import "ClientModel.h"
#import "Product.h"
#import "ProductModel.h"
#import "OpportunityModel.h"


@interface EditOpportunityViewController ()
{
    Opportunity *_opportunityToEdit;
    Client *_clientBuyer;
    Product *_relatedProduct;
    Client *_clientOwner;
    
    OpportunityModel *_opportunityMethods;
    UIActivityIndicatorView *_indicator;
}
@end

@implementation EditOpportunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize objects methods
    _opportunityMethods = [[OpportunityModel alloc] init];
    _opportunityMethods.delegate = self;

    ClientModel *clientMethods = [[ClientModel alloc] init];
    ProductModel *productMethods = [[ProductModel alloc] init];

    _opportunityToEdit = [self.delegate getOpportunityforEdit];
    
    _clientBuyer = [clientMethods getClientFromClientId:_opportunityToEdit.client_id];
    _relatedProduct = [productMethods getProductFromProductId:_opportunityToEdit.product_id];
    _clientOwner = [clientMethods getClientFromClientId:_relatedProduct.client_id];
    
    CGRect imageProductFrame = self.imageProduct.frame;
    imageProductFrame.origin.x = 15;
    imageProductFrame.origin.y = 94;
    imageProductFrame.size.width = 90;
    imageProductFrame.size.height = 90;
    self.imageProduct.frame = imageProductFrame;
    
    CGRect imageClientFrame = self.imageClient.frame;
    imageClientFrame.origin.x = 15;
    imageClientFrame.origin.y = 234;
    imageClientFrame.size.width = 40;
    imageClientFrame.size.height = 40;
    self.imageClient.frame = imageClientFrame;
    
    CGRect imageClientStatusFrame = self.imageClientStatus.frame;
    imageClientStatusFrame.origin.x = 67;
    imageClientStatusFrame.origin.y = 249;
    imageClientStatusFrame.size.width = 10;
    imageClientStatusFrame.size.height = 10;
    self.imageClientStatus.frame = imageClientStatusFrame;

    CGRect imageOwnerFrame = self.imageOwner.frame;
    imageOwnerFrame.origin.x = 15;
    imageOwnerFrame.origin.y = 317;
    imageOwnerFrame.size.width = 40;
    imageOwnerFrame.size.height = 40;
    self.imageOwner.frame = imageOwnerFrame;
    
    CGRect imageOwnerStatusFrame = self.imageOwnerStatus.frame;
    imageOwnerStatusFrame.origin.x = 67;
    imageOwnerStatusFrame.origin.y = 332;
    imageOwnerStatusFrame.size.width = 10;
    imageOwnerStatusFrame.size.height = 10;
    self.imageOwnerStatus.frame = imageOwnerStatusFrame;

    
    // self.imageProduct.image = [UIImage imageWithData:_relatedProduct.picture];
    self.imageProduct.image = [UIImage imageWithData:[productMethods getProductPhotoFrom:_relatedProduct]];
    
    self.labelProductName.text = _relatedProduct.name;
    self.labelProductCurrency.text = _relatedProduct.currency;
    self.labelProductCurrency2.text = _relatedProduct.currency;
    self.labelProductDesc.text = _relatedProduct.desc;
    
    self.textOpportunityPrice.text = [NSString stringWithFormat:@"%@", _opportunityToEdit.price_sold];
    self.textOpportunityCommision.text = [NSString stringWithFormat:@"%@", _opportunityToEdit.commision];
    self.textOpportunityNotes.text = _opportunityToEdit.notes;
    
    //self.imageClient.image = [UIImage imageWithData:_clientBuyer.picture];
    self.imageClient.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:_clientBuyer]];
    
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

    //self.imageOwner.image = [UIImage imageWithData:_clientOwner.picture];
    self.imageOwner.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:_clientOwner]];
    
    if ([_clientOwner.status isEqualToString:@"V"])
    {
        self.labelOwnerName.text = [NSString stringWithFormat:@"    %@ %@", _clientOwner.name, _clientOwner.last_name];
        self.imageOwnerStatus.image = [UIImage imageNamed:@"Verified"];
    }
    else
    {
        self.labelOwnerName.text = [NSString stringWithFormat:@"%@ %@", _clientOwner.name, _clientOwner.last_name];
        self.imageOwnerStatus.image = [UIImage imageNamed:@"Blank"];
    }
    
    // Buttons actions
    
    if ([_opportunityToEdit.status isEqualToString:@"O"])
    {
        [self.buttonOption1 setTitle:@"Cerrar" forState:UIControlStateNormal];
        [self.buttonOption2 setTitle:@"Vendido!" forState:UIControlStateNormal];
        
        self.textOpportunityPrice.text = [NSString stringWithFormat:@"%@", _opportunityToEdit.initial_price];
        self.textOpportunityCommision.text = [NSString stringWithFormat:@"%f", (self.textOpportunityPrice.text.intValue * 0.1)];
    }
    else if ([_opportunityToEdit.status isEqualToString:@"C"])
    {
        self.buttonOption1.hidden = YES;
        [self.buttonOption2 setTitle:@"Reabrir" forState:UIControlStateNormal];
        self.textOpportunityPrice.enabled = NO;
        self.textOpportunityCommision.enabled = NO;
        self.textOpportunityNotes.editable = NO;
    }
    else if ([_opportunityToEdit.status isEqualToString:@"S"])
    {
        self.buttonOption1.hidden = YES;
        [self.buttonOption2 setTitle:@"Pagada!" forState:UIControlStateNormal];
        self.textOpportunityPrice.enabled = NO;
        self.textOpportunityCommision.enabled = NO;
        self.textOpportunityNotes.editable = NO;
    }
    else // @"P"
    {
        self.buttonOption1.hidden = YES;
        [self.buttonOption2 setTitle:@"Reabrir" forState:UIControlStateNormal];
        self.textOpportunityPrice.enabled = NO;
        self.textOpportunityCommision.enabled = NO;
        self.textOpportunityNotes.editable = NO;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionOption1:(id)sender
{
    OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];

    if ([_opportunityToEdit.status isEqualToString:@"O"])
    {
        // Close opportunity
        _opportunityToEdit.status = @"C";
        _opportunityToEdit.closedsold_time = [NSDate date];
        _opportunityToEdit.notes = self.textOpportunityNotes.text;
    }
    
    // Set spinner
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.center = CGPointMake((self.view.bounds.size.width / 2) , (self.view.bounds.size.height / 2));
    
    [self.view addSubview:_indicator];
    [_indicator startAnimating];

    [opportunityMethods updateOpportunity:_opportunityToEdit];
}


- (IBAction)actionOption2:(id)sender
{
    // Set spinner
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.center = CGPointMake((self.view.bounds.size.width / 2) , (self.view.bounds.size.height / 2));
    
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    
    OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    if ([_opportunityToEdit.status isEqualToString:@"O"])
    {
        // Change opportunity to Sold
        _opportunityToEdit.status = @"S";
        _opportunityToEdit.closedsold_time = [NSDate date];
        _opportunityToEdit.notes = self.textOpportunityNotes.text;
        _opportunityToEdit.price_sold = [NSNumber numberWithFloat:self.textOpportunityPrice.text.intValue];
        _opportunityToEdit.commision = [NSNumber numberWithFloat:self.textOpportunityCommision.text.intValue];
        
        // Update product status!
        _relatedProduct.status = @"S";
        [productMethods updateProduct:_relatedProduct];
    }
    else if ([_opportunityToEdit.status isEqualToString:@"C"])
    {
        // Reopen opportunity
        _opportunityToEdit.status = @"O";
        _opportunityToEdit.closedsold_time = nil;
        _opportunityToEdit.paid_time = nil;
    }
    else if ([_opportunityToEdit.status isEqualToString:@"S"])
    {
        // Mark opportunity as Paid
        _opportunityToEdit.status = @"P";
        _opportunityToEdit.paid_time = [NSDate date];
    }
    else // @"P"
    {
        // Reopen opportunity
        _opportunityToEdit.status = @"O";
        _opportunityToEdit.closedsold_time = nil;
        _opportunityToEdit.paid_time = nil;
    }

    [opportunityMethods updateOpportunity:_opportunityToEdit];
}

- (IBAction)priceEdited:(id)sender
{
    // Price changed... estimates new commision
    
    self.textOpportunityCommision.text = [NSString stringWithFormat:@"%f", (self.textOpportunityPrice.text.intValue * 0.1)];
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
        [self.delegate opportunityEdited:_opportunityToEdit];
    }
}

@end
