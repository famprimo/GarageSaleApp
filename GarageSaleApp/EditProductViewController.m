//
//  EditProductViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 31/01/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "EditProductViewController.h"
#import "NSDate+NVTimeAgo.h"

@interface EditProductViewController ()
{
    Product *_productToEdit;
    ProductModel *_productMethods;
}
@end

@implementation EditProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Initialize objects methods
    _productMethods = [[ProductModel alloc] init];
    _productMethods.delegate = self;
    
    _productToEdit = [self.delegate getProductforEdit];
    
    CGRect imageProductFrame = self.imageProduct.frame;
    imageProductFrame.origin.x = 10;
    imageProductFrame.origin.y = 10;
    imageProductFrame.size.width = 70;
    imageProductFrame.size.height = 70;
    self.imageProduct.frame = imageProductFrame;
    
    CGRect picBackgroundFrame = self.picBackground.frame;
    picBackgroundFrame.origin.x = 0;
    picBackgroundFrame.origin.y = 90;
    picBackgroundFrame.size.width = 800;
    picBackgroundFrame.size.height = 310;
    self.picBackground.frame = picBackgroundFrame;

    // self.imageProduct.image = [UIImage imageWithData:_productToEdit.picture];
    self.imageProduct.image = [UIImage imageWithData:[[[ProductModel alloc] init] getProductPhotoFrom:_productToEdit]];

    self.textName.text = _productToEdit.name;
    self.textGScode.text = _productToEdit.codeGS;
    self.textDesc.text = _productToEdit.desc;
    // self.textPublishedPrice.text = [NSString stringWithFormat:@"%.f", _productToEdit.price];
    self.textPublishedPrice.text = [NSString stringWithFormat:@"%@", _productToEdit.price];
    
    if ([_productToEdit.notes isEqualToString:@""])
    {
        self.textNotes.text = @"Ingrese aqui las notas";
    }
    else
    {
        self.textNotes.text = _productToEdit.notes;
    }
    
    if ([_productToEdit.type isEqualToString:@"S"])
    {
        [self.tabType setSelectedSegmentIndex:0];
    }
    else
    {
        [self.tabType setSelectedSegmentIndex:1];
    }
    
    if ([_productToEdit.currency isEqualToString:@"S/."])
    {
        [self.tabCurrency setSelectedSegmentIndex:0];
    }
    else
    {
        [self.tabCurrency setSelectedSegmentIndex:1];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveProductEdits:(id)sender
{
    // Create opportunity
    _productToEdit.name = self.textName.text;
    _productToEdit.codeGS = self.textGScode.text;
    _productToEdit.desc = self.textDesc.text;
    _productToEdit.notes = self.textNotes.text;
    _productToEdit.price = [NSNumber numberWithFloat:[self.textPublishedPrice.text intValue]];
    _productToEdit.updated_time = [NSDate date];

    if (self.tabType.selectedSegmentIndex == 0)
    {
        _productToEdit.type = @"S";
    }
    else
    {
        _productToEdit.type = @"A";
    }

    if (self.tabCurrency.selectedSegmentIndex == 0)
    {
        _productToEdit.currency = @"S/.";
    }
    else
    {
        _productToEdit.currency = @"USD";
    }
    
    if ([_productToEdit.status isEqualToString:@"N"])
    {
        _productToEdit.status = @"U";
    }
    
    [_productMethods updateProduct:_productToEdit];
}




#pragma mark methods for OpportunityModel

-(void)productsSyncedWithCoreData:(BOOL)succeed;
{
    // No need to implement
}

-(void)productAddedOrUpdated:(BOOL)succeed;
{
    if (succeed)
    {
        // SI HAY CAMBIOS DE DESCRIPCION CAMBIAR EN FACEBOOK!
        
        [self.delegate productEdited:_productToEdit];
    }
}

@end
