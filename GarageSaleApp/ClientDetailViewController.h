//
//  ClientDetailViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"
#import "ProductPickerViewController.h"
#import "ClientPickerViewController.h"
#import "EditClientViewController.h"

// Popover help  http://www.appcoda.com/uiactionsheet-uipopovercontroller-tutorial/

@protocol ClientDetailViewControllerDelegate

-(void)clientUpdated;

@end

@interface ClientDetailViewController : UIViewController<UIActionSheetDelegate, UIAlertViewDelegate, ProductPickerViewControllerDelegate, EditClientViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, ClientPickerViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (nonatomic, strong) id<ClientDetailViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *labelClientName;
@property (weak, nonatomic) IBOutlet UILabel *labelCreatedTime;
@property (weak, nonatomic) IBOutlet UILabel *labelLastInteractionTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageClient;
@property (weak, nonatomic) IBOutlet UIImageView *imageClientStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imageClientSex;
@property (weak, nonatomic) IBOutlet UILabel *labelClientAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelClientZone;
@property (weak, nonatomic) IBOutlet UILabel *labelClientPhones;
@property (weak, nonatomic) IBOutlet UILabel *labelClientEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelClientLastInventaryTime;
@property (weak, nonatomic) IBOutlet UIImageView *picClientZone;
@property (weak, nonatomic) IBOutlet UIImageView *picClientPhone;
@property (weak, nonatomic) IBOutlet UIImageView *picClientEmail;

@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;
@property (weak, nonatomic) IBOutlet UIButton *buttonRelateProducts;
@property (weak, nonatomic) IBOutlet UITableView *tableProducts;
@property (weak, nonatomic) IBOutlet UIButton *buttonCombineProducts;

@end
