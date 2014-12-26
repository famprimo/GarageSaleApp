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


@interface ProductDetailViewController ()


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
        
        Client *clientSelected = (Client *)[[[ProductModel alloc] init] getClient:productSelected];
        
        // Setting frames for all pictures
        CGRect productImageFrame = self.productImage.frame;
        productImageFrame.origin.x = 90;
        productImageFrame.origin.y = 80;
        productImageFrame.size.width = 200;
        productImageFrame.size.height = 200;
        self.productImage.frame = productImageFrame;

        CGRect soldImageFrame = self.soldImage.frame;
        soldImageFrame.origin.x = 90;
        soldImageFrame.origin.y = 124;
        soldImageFrame.size.width = 200;
        soldImageFrame.size.height = 111;
        self.soldImage.frame = soldImageFrame;

        // Set data
        self.productImage.image = [UIImage imageWithData:productSelected.picture];
        self.productNameLabel.text = productSelected.name;
        if ([productSelected.type isEqualToString:@"S"])
        {
            self.productTypeLabel.text = @"Venta";
        }
        else // @"A"
        {
            self.productTypeLabel.text = @"Publicidad";
        }
        
        // Set button and sold image depending on message status
        if ([productSelected.status isEqualToString:@"N"])
        {
            self.buttonStatus.backgroundColor = [UIColor blueColor];
            self.buttonStatus.titleLabel.textColor = [UIColor whiteColor];
            //self.buttonStatus.titleLabel.text = @"Nuevo     ";
            [self.buttonStatus setTitle:@"Nuevo     " forState:UIControlStateNormal];
            self.soldImage.image = [UIImage imageNamed:@"Blank"];
        }
        else if ([productSelected.status isEqualToString:@"S"])
        {
            self.buttonStatus.backgroundColor = [UIColor grayColor];
            self.buttonStatus.titleLabel.textColor = [UIColor blackColor];
            self.buttonStatus.titleLabel.text = @"Vendido     ";
            self.soldImage.image = [UIImage imageNamed:@"Sold"];
        }
        else if ([productSelected.status isEqualToString:@"D"])
        {
            self.buttonStatus.backgroundColor = [UIColor redColor];
            self.buttonStatus.titleLabel.textColor = [UIColor whiteColor];
            self.buttonStatus.titleLabel.text = @"Deshabilitado     ";
            self.soldImage.image = [UIImage imageNamed:@"Blank"];
        }
        else // @"U"
        {
            self.buttonStatus.backgroundColor = [UIColor grayColor];
            self.buttonStatus.titleLabel.textColor = [UIColor blackColor];
            self.buttonStatus.titleLabel.text = @"Actualizado     ";
            self.soldImage.image = [UIImage imageNamed:@"Blank"];
        }

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}




@end
