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
#import "ClientModel.h"
#import "NSDate+NVTimeAgo.h"


@interface ClientDetailViewController ()
{
    // Data for the tables
    NSMutableArray *_myDataProducts;
    NSMutableArray *_selectedProductsArray;
    
    Client *_selectedClient;
    
    id _combineButtonId;
}

// For Popover
@property (nonatomic, strong) UIPopoverController *productPickerPopover;
@property (nonatomic, strong) UIPopoverController *clientPickerPopover;
@property (nonatomic, strong) UIPopoverController *editClientPopover;
@property (nonatomic, strong) UIPopoverController *sendMessagePopover;

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
        imageClientFrame.origin.y = 71;
        imageClientFrame.size.width = 140;
        imageClientFrame.size.height = 140;
        self.imageClient.frame = imageClientFrame;
        
        CGRect imageClientStatusFrame = self.imageClientStatus.frame;
        imageClientStatusFrame.origin.x = 61;
        imageClientStatusFrame.origin.y = 29;
        imageClientStatusFrame.size.width = 15;
        imageClientStatusFrame.size.height = 15;
        self.imageClientStatus.frame = imageClientStatusFrame;

        CGRect imageClientSexFrame = self.imageClientSex.frame;
        imageClientSexFrame.origin.x = 33;
        imageClientSexFrame.origin.y = 26;
        imageClientSexFrame.size.width = 20;
        imageClientSexFrame.size.height = 20;
        self.imageClientSex.frame = imageClientSexFrame;

        CGRect picClientZoneFrame = self.picClientZone.frame;
        picClientZoneFrame.origin.x = 40;
        picClientZoneFrame.origin.y = 269;
        picClientZoneFrame.size.width = 15;
        picClientZoneFrame.size.height = 15;
        self.picClientZone.frame = picClientZoneFrame;
        
        CGRect picClientPhoneFrame = self.picClientPhone.frame;
        picClientPhoneFrame.origin.x = 40;
        picClientPhoneFrame.origin.y = 295;
        picClientPhoneFrame.size.width = 15;
        picClientPhoneFrame.size.height = 15;
        self.picClientPhone.frame = picClientPhoneFrame;
        
        CGRect picClientEmailFrame = self.picClientEmail.frame;
        picClientEmailFrame.origin.x = 40;
        picClientEmailFrame.origin.y = 319;
        picClientEmailFrame.size.width = 15;
        picClientEmailFrame.size.height = 15;
        self.picClientEmail.frame = picClientEmailFrame;
        
        
        // Make clients picture rounded
        // self.imageClient.layer.cornerRadius = self.imageClient.frame.size.width / 2;
        // self.imageClient.clipsToBounds = YES;
        
        // Client data

        //self.imageClient.image = [UIImage imageWithData:_selectedClient.picture];
        self.imageClient.image = [UIImage imageWithData:[[[ClientModel alloc] init] getClientPhotoFrom:_selectedClient]];
        
        if ([_selectedClient.status isEqualToString:@"V"])
        {
            self.labelClientName.text = [NSString stringWithFormat:@"     %@ %@", _selectedClient.name, _selectedClient.last_name];
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

        if (_selectedClient.client_zone == nil || [_selectedClient.client_zone isEqualToString:@""])
        {
            self.labelClientZone.text = @"Sin zona registrada";
            self.labelClientZone.textColor = [UIColor grayColor];
        }
        else
        {
            self.labelClientZone.text = [NSString stringWithFormat:@"Vive en %@", _selectedClient.client_zone];
            self.labelClientZone.textColor = [UIColor blackColor];
        }
        
        if (_selectedClient.phone1 == nil || [_selectedClient.phone1 isEqualToString:@""])
        {
            if (_selectedClient.phone2 == nil || [_selectedClient.phone2 isEqualToString:@""])
            {
                self.labelClientPhones.text = @"Sin telefonos registrados";
                self.labelClientPhones.textColor = [UIColor grayColor];
            }
            else
            {
                self.labelClientPhones.text = _selectedClient.phone2;
                self.labelClientPhones.textColor = [UIColor blackColor];
            }
        }
        else
        {
            if (_selectedClient.phone2 == nil || [_selectedClient.phone2 isEqualToString:@""])
            {
                self.labelClientPhones.text = _selectedClient.phone1;
            }
            else
            {
                self.labelClientPhones.text = [NSString stringWithFormat:@"%@, %@", _selectedClient.phone1, _selectedClient.phone2];
            }
            self.labelClientPhones.textColor = [UIColor blackColor];
        }
        
        if (_selectedClient.codeGS == nil || [_selectedClient.codeGS isEqualToString:@""])
        {
            self.labelClientCodeGS.text = @"Sin código GS";
            self.labelClientCodeGS.textColor = [UIColor grayColor];
        }
        else
        {
            self.labelClientCodeGS.text = _selectedClient.codeGS;
            self.labelClientCodeGS.textColor = [UIColor blackColor];
        }
        
        if ([_selectedClient.status isEqualToString:@"N"])
        {
            self.buttonUpdateStatus.backgroundColor = [UIColor blueColor];
        }
        else
        {
            self.buttonUpdateStatus.backgroundColor = [UIColor darkGrayColor];
        }

        self.labelClientEmail.text = _selectedClient.email;
        self.labelCreatedTime.text = [NSString stringWithFormat:@"%@", [_selectedClient.created_time formattedAsDateComplete]];
        self.labelLastInteractionTime.text = [NSString stringWithFormat:@"%@", [_selectedClient.last_interacted_time formattedAsTimeAgo]];
        
        // Load products from the client
        _myDataProducts = [[[ProductModel alloc] init] getProductsFromClientId:_selectedClient.client_id];
        
        [self.tableProducts reloadData];
        
        self.tableProducts.allowsMultipleSelection = YES;
        _selectedProductsArray = [[NSMutableArray alloc] init];
    }
}


#pragma mark - Managing button actions

- (IBAction)changeClientStatus:(id)sender
{
    if ([_selectedClient.status isEqualToString:@"N"])
    {
        _selectedClient.status = @"U";
    }
    else if ([_selectedClient.status isEqualToString:@"U"])
    {
        _selectedClient.status = @"N";
    }
    
    if ([_selectedClient.status isEqualToString:@"U"] || [_selectedClient.status isEqualToString:@"N"])
    {
        // Update only if there were changes (not for status V, B or D)
        [[[ClientModel alloc] init] updateClient:_selectedClient];
        
        [self configureView];
        [self.delegate clientUpdated];
    }
}

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

- (IBAction)editClientDetails:(id)sender
{
    EditClientViewController *editClientController = [[EditClientViewController alloc] initWithNibName:@"EditClientViewController" bundle:nil];
    editClientController.delegate = self;
    
    
    self.editClientPopover = [[UIPopoverController alloc] initWithContentViewController:editClientController];
    self.editClientPopover.popoverContentSize = CGSizeMake(800, 300);
    [self.editClientPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];

}

- (IBAction)combineProducts:(id)sender
{
    _combineButtonId = sender;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cuidado" message:@"Esta acción combinará todos los mensajes y productos del cliente seleccionado con el cliente actual. ¿Estas seguro? " delegate:self cancelButtonTitle:@"Continuar" otherButtonTitles:@"Cancelar", nil];
    [alert show];
}

- (IBAction)validateInventory:(id)sender
{
    SendMessageViewController *sendMessageController = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
    sendMessageController.delegate = self;
    
    
    self.sendMessagePopover = [[UIPopoverController alloc] initWithContentViewController:sendMessageController];
    self.sendMessagePopover.popoverContentSize = CGSizeMake(800.0, 500.0);
    [self.sendMessagePopover presentPopoverFromRect:[(UIButton *)sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        ClientPickerViewController *clientPickerController = [[ClientPickerViewController alloc] initWithNibName:@"ClientPickerViewController" bundle:nil];
        clientPickerController.delegate = self;
        
        self.clientPickerPopover = [[UIPopoverController alloc] initWithContentViewController:clientPickerController];
        self.clientPickerPopover.popoverContentSize = CGSizeMake(350.0, 400.0);
        [self.clientPickerPopover presentPopoverFromRect:[(UIButton *)_combineButtonId frame]
                                                  inView:self.view
                                permittedArrowDirections:UIPopoverArrowDirectionAny
                                                animated:YES];
    }
}


#pragma mark - Delegate methods for ProductPicker

-(void)productSelectedfromProductPicker:(NSMutableArray *)selectedProductsArray;
{
    // Dismiss the popover view
    [self.productPickerPopover dismissPopoverAnimated:YES];
    
    ProductModel *productMethods = [[ProductModel alloc] init];
    Product *selectedProduct = [[Product alloc] init];
    
    BOOL clientUpdated = NO;
    
    for (int i=0; i<selectedProductsArray.count; i=i+1)
    {
        selectedProduct = selectedProductsArray[i];
        selectedProduct.client_id = _selectedClient.client_id;
        
        [productMethods updateProduct:selectedProduct];
    }
    
    // Load products from the client
    _myDataProducts = [[[ProductModel alloc] init] getProductsFromClientId:_selectedClient.client_id];
    
    if (clientUpdated)
    {
        [[[ClientModel alloc] init] updateClient:_selectedClient];
        
        [self configureView];
    }
    else
    {
        [self.tableProducts reloadData];
    }
}

-(BOOL)allowMultipleSelectionfromProductPicker
{
    return YES;
}

-(NSString*)getRelatedOwnerfromProductPicker
{
    return _selectedClient.client_id;
}


#pragma mark - Delegate methods for ClientPicker

-(void)clientSelectedfromClientPicker:(NSString *)clientIDSelected;
{
    // Dismiss the popover view
    [self.clientPickerPopover dismissPopoverAnimated:YES];
    
}


#pragma mark - Delegate methods for EditClient

-(Client *)getClientforEdit;
{
    return _selectedClient;
}

-(void)clientEdited:(Client *)editedClient;
{
    // Dismiss the popover view
    [self.editClientPopover dismissPopoverAnimated:YES];

    [self configureView];
    [self.delegate clientUpdated];
}


#pragma mark - Delegate methods for SendMessage

-(NSString*)getTemplateTypeFromMessage;
{
    return @"O";
}

-(NSString*)getBuyerIdFromMessage;
{
    return @"";
}

-(NSString*)getOwnerIdFromMessage;
{
    return _selectedClient.client_id;
}

-(NSMutableArray*)getProductsIdFromMessage;
{
    return _selectedProductsArray;
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
    UILabel *labelProductInventoryTime = (UILabel*)[myCell.contentView viewWithTag:2];
    UIImageView *imageProduct = (UIImageView*)[myCell.contentView viewWithTag:3];
    
    CGRect imageProductFrame = imageProduct.frame;
    imageProductFrame.origin.x = 20;
    imageProductFrame.origin.y = 5;
    imageProductFrame.size.width = 40;
    imageProductFrame.size.height = 40;
    imageProduct.frame = imageProductFrame;
    
    // Get the information to be shown
    Product *myProduct = _myDataProducts[indexPath.row];
    
    // Set product data
    labelProductName.text = myProduct.name;
    labelProductInventoryTime.text = [NSString stringWithFormat:@"Ultimo inventario en %@", [myProduct.last_inventory_time formattedAsTimeAgo]];
    
    // imageProduct.image = [UIImage imageWithData:myProduct.picture];
    imageProduct.image = [UIImage imageWithData:[[[ProductModel alloc] init] getProductPhotoFrom:myProduct]];
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *productSelected = [[Product alloc] init];
    
    productSelected = _myDataProducts[indexPath.row];

    [_selectedProductsArray addObject:productSelected.product_id];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *productSelected = [[Product alloc] init];
    NSString *tmpProductID;
    
    productSelected = _myDataProducts[indexPath.row];
    
    // Review if selected item is already on the array
    for (int i=0; i<_selectedProductsArray.count; i=i+1)
    {
        tmpProductID = _selectedProductsArray[i];
        if ([tmpProductID isEqualToString:productSelected.product_id])
        {
            [_selectedProductsArray removeObjectAtIndex:i];
            break;
        }
    }
}

@end
