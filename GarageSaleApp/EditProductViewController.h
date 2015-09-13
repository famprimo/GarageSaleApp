//
//  EditProductViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 31/01/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ProductModel.h"


@protocol EditProductViewControllerDelegate

-(Product *)getProductforEdit;
-(void)productEdited:(Product *)editedProduct;

@end

@interface EditProductViewController : UIViewController <ProductModelDelegate>

@property (nonatomic, strong) id<EditProductViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductCreationDate;

@property (weak, nonatomic) IBOutlet UITextField *textGScode;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextView *textDesc;
@property (weak, nonatomic) IBOutlet UITextField *textPublishedPrice;
@property (weak, nonatomic) IBOutlet UITextView *textNotes;

@property (weak, nonatomic) IBOutlet UISegmentedControl *tabType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tabCurrency;

@property (weak, nonatomic) IBOutlet UIImageView *picBackground;

@property (weak, nonatomic) IBOutlet UIButton *buttonSave;

/*
 @property (weak, nonatomic) IBOutlet UIImageView *imageClient;
 @property (weak, nonatomic) IBOutlet UILabel *labelClientName;
 @property (weak, nonatomic) IBOutlet UILabel *labelClientCreationDate;
 
 @property (weak, nonatomic) IBOutlet UIImageView *picMale;
 @property (weak, nonatomic) IBOutlet UIImageView *picFemale;
 @property (weak, nonatomic) IBOutlet UIImageView *picEmail;
 @property (weak, nonatomic) IBOutlet UIImageView *picPhone1;
 @property (weak, nonatomic) IBOutlet UIImageView *picPhone2;
 @property (weak, nonatomic) IBOutlet UIImageView *picZone;
 
 @property (weak, nonatomic) IBOutlet UITextField *textName;
 @property (weak, nonatomic) IBOutlet UITextField *textLastName;
 @property (weak, nonatomic) IBOutlet UITextField *textEmail;
 @property (weak, nonatomic) IBOutlet UITextField *textPhone1;
 @property (weak, nonatomic) IBOutlet UITextField *textPhone2;
 @property (weak, nonatomic) IBOutlet UITextField *textZone;
 @property (weak, nonatomic) IBOutlet UITextView *textAddress;
 @property (weak, nonatomic) IBOutlet UITextView *textNotes;
 
 @property (weak, nonatomic) IBOutlet UISegmentedControl *tabSex;
 @property (weak, nonatomic) IBOutlet UISwitch *switchStatus;
 
 @property (weak, nonatomic) IBOutlet UIImageView *picBackground;
 
 @property (weak, nonatomic) IBOutlet UIButton *buttonSave;

 */

@end
