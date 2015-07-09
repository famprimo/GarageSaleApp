//
//  ClientDetailViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ClientDetailViewController.h"
#import "Product.h"
#import "ProductModel.h"
#import "Client.h"
#import "NSDate+NVTimeAgo.h"


@interface ClientDetailViewController ()
{
    // Data for the tables
    NSMutableArray *_myDataProducts;
    
    Client *_selectedClient;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *productPickerPopover;
@property (nonatomic, strong) UIPopoverController *editClientPopover;

// @property (nonatomic, strong) UIPopoverController *sendMessagePopover;

@end

@implementation ClientDetailViewController

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
    
    self.tableProducts.delegate = self;
    self.tableProducts.dataSource = self;

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
        
        _selectedClient = (Client *)_detailItem;
       
        // Setting frames for all pictures
        CGRect imageClientFrame = self.imageClient.frame;
        imageClientFrame.origin.x = 33;
        imageClientFrame.origin.y = 28;
        imageClientFrame.size.width = 140;
        imageClientFrame.size.height = 140;
        self.imageClient.frame = imageClientFrame;
        
        CGRect imageClientStatusFrame = self.imageClientStatus.frame;
        imageClientStatusFrame.origin.x = 207;
        imageClientStatusFrame.origin.y = 31;
        imageClientStatusFrame.size.width = 15;
        imageClientStatusFrame.size.height = 15;
        self.imageClientStatus.frame = imageClientStatusFrame;

        CGRect imageClientSexFrame = self.imageClientSex.frame;
        imageClientSexFrame.origin.x = 181;
        imageClientSexFrame.origin.y = 29;
        imageClientSexFrame.size.width = 20;
        imageClientSexFrame.size.height = 20;
        self.imageClientSex.frame = imageClientSexFrame;

        CGRect picClientZoneFrame = self.picClientZone.frame;
        picClientZoneFrame.origin.x = 40;
        picClientZoneFrame.origin.y = 226;
        picClientZoneFrame.size.width = 15;
        picClientZoneFrame.size.height = 15;
        self.picClientZone.frame = picClientZoneFrame;
        
        CGRect picClientPhoneFrame = self.picClientPhone.frame;
        picClientPhoneFrame.origin.x = 40;
        picClientPhoneFrame.origin.y = 254;
        picClientPhoneFrame.size.width = 15;
        picClientPhoneFrame.size.height = 15;
        self.picClientPhone.frame = picClientPhoneFrame;
        
        CGRect picClientEmailFrame = self.picClientEmail.frame;
        picClientEmailFrame.origin.x = 40;
        picClientEmailFrame.origin.y = 282;
        picClientEmailFrame.size.width = 15;
        picClientEmailFrame.size.height = 15;
        self.picClientEmail.frame = picClientEmailFrame;
        
        
        // Make clients picture rounded
        // self.imageClient.layer.cornerRadius = self.imageClient.frame.size.width / 2;
        // self.imageClient.clipsToBounds = YES;
        
        // Client data

        self.imageClient.image = [UIImage imageWithData:_selectedClient.picture];

        if ([_selectedClient.status isEqualToString:@"V"])
        {
            self.labelClientName.text = [NSString stringWithFormat:@"    %@ %@", _selectedClient.name, _selectedClient.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", _selectedClient.name, _selectedClient.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Blank"];
        }

        if ([_selectedClient.sex isEqualToString:@"M"])
        {
            self.imageClientSex.image = [UIImage imageNamed:@"Male"];
        }
        else
        {
            self.imageClientSex.image = [UIImage imageNamed:@"Female"];
        }

        self.labelClientZone.text = _selectedClient.client_zone;
        self.labelClientPhones.text = [NSString stringWithFormat:@"%@ %@ %@", _selectedClient.phone1, _selectedClient.phone2, _selectedClient.phone3];
        self.labelClientEmail.text = _selectedClient.email;
        self.labelCreatedTime.text = [NSString stringWithFormat:@"Creado: %@", [_selectedClient.created_time formattedAsDateComplete]];
        self.labelLastInteractionTime.text = [NSString stringWithFormat:@"Última interacción: %@", [_selectedClient.last_interacted_time formattedAsTimeAgo]];
        self.labelClientLastInventaryTime.text = [NSString stringWithFormat:@"Último inventario %@", [_selectedClient.last_inventory_time formattedAsTimeAgo]];
        self.labelClientFBCode.text = _selectedClient.fb_client_id;
        
        
        // Load products from the client
        _myDataProducts = [[[ProductModel alloc] init] getProductsFromClientId:_selectedClient.client_id];
        
        [self.tableProducts reloadData];
        

    }
}

#pragma mark - Actions

- (IBAction)relateToProduct:(id)sender
{
    ProductPickerViewController *productPickerController = [[ProductPickerViewController alloc] initWithNibName:@"ProductPickerViewController" bundle:nil];
    productPickerController.delegate = self;
    
    
    self.productPickerPopover = [[UIPopoverController alloc] initWithContentViewController:productPickerController];
    self.productPickerPopover.popoverContentSize = CGSizeMake(500.0, 500.0);
    [self.productPickerPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
}

-(void)productSelectedfromProductPicker:(NSMutableArray *)selectedProductsArray;
{
    // Dismiss the popover view
    [self.productPickerPopover dismissPopoverAnimated:YES];
    
    ProductModel *productMethods = [[ProductModel alloc] init];
    Product *selectedProduct = [[Product alloc] init];
    
    for (int i=0; i<selectedProductsArray.count; i=i+1)
    {
        selectedProduct = selectedProductsArray[i];
        selectedProduct.client_id = _selectedClient.client_id;
    
        [productMethods updateProduct:selectedProduct];
    }
    
    // Load products from the client
    _myDataProducts = [[[ProductModel alloc] init] getProductsFromClientId:_selectedClient.client_id];
    
    [self.tableProducts reloadData];
}


-(BOOL)allowMultipleSelectionfromProductPicker
{
    return YES;
}

-(NSString*)getRelatedOwnerfromProductPicker
{
    return _selectedClient.client_id;
}


- (IBAction)editClientDetails:(id)sender
{
    EditClientViewController *editClientController = [[EditClientViewController alloc] initWithNibName:@"EditClientViewController" bundle:nil];
    editClientController.delegate = self;
    
    
    self.editClientPopover = [[UIPopoverController alloc] initWithContentViewController:editClientController];
    self.editClientPopover.popoverContentSize = CGSizeMake(800, 400);
    [self.editClientPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];

}

-(Client *)getClientforEdit;
{
    return _selectedClient;
}

-(void)clientEdited:(Client *)editedClient;
{
    // Dismiss the popover view
    [self.editClientPopover dismissPopoverAnimated:YES];

    [self configureView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myDataProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Retrieve cell
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"CellProd" forIndexPath:indexPath];
    
    // Get references to images and labels of cell
    UILabel *labelProductName = (UILabel*)[myCell.contentView viewWithTag:1];
    UILabel *labelProductCreatedTime = (UILabel*)[myCell.contentView viewWithTag:2];
    UIImageView *imageProduct = (UIImageView*)[myCell.contentView viewWithTag:3];
    UIImageView *imageProductSold = (UIImageView*)[myCell.contentView viewWithTag:4];
    
    CGRect imageProductFrame = imageProduct.frame;
    imageProductFrame.origin.x = 20;
    imageProductFrame.origin.y = 5;
    imageProductFrame.size.width = 40;
    imageProductFrame.size.height = 40;
    imageProduct.frame = imageProductFrame;
    
    CGRect imageProductSoldFrame = imageProductSold.frame;
    imageProductSoldFrame.origin.x = 20;
    imageProductSoldFrame.origin.y = 5;
    imageProductSoldFrame.size.width = 40;
    imageProductSoldFrame.size.height = 40;
    imageProductSold.frame = imageProductSoldFrame;
    
    
    // Get the information to be shown
    Product *myProduct = _myDataProducts[indexPath.row];
    
    
    // Set product data
    labelProductName.text = myProduct.name;
    labelProductCreatedTime.text = [myProduct.created_time formattedAsTimeAgo];
    
    imageProduct.image = [UIImage imageWithData:myProduct.picture];
    
    if ([myProduct.status isEqualToString:@"S"])
    {
        imageProductSold.image = [UIImage imageNamed:@"Sold"];
    }
    else
    {
        imageProductSold.image = [UIImage imageNamed:@"Blank"];
    }
    
    return myCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
