//
//  ProductDetailViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientPickerViewController.h"
#import "SendMessageViewController.h"
#import "NewOpportunityViewController.h"
#import "EditProductViewController.h"

@protocol ProductDetailViewControllerDelegate

-(void)productUpdated;

@end


@interface ProductDetailViewController : UIViewController <UIActionSheetDelegate, ClientPickerViewControllerDelegate, SendMessageViewControllerDelegate, NewOpportunityViewControllerDelegate, EditProductViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id detailItem;
@property (nonatomic, strong) id<ProductDetailViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *buttonChangeProductStatus;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeeInFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonMessageToOwner;
@property (weak, nonatomic) IBOutlet UIButton *buttonNewOpportunity;
@property (weak, nonatomic) IBOutlet UIButton *buttonRelateToOwner;
@property (weak, nonatomic) IBOutlet UIButton *buttonMessageToBuyer;
@property (weak, nonatomic) IBOutlet UIButton *buttonReply;
@property (weak, nonatomic) IBOutlet UIButton *buttonReviewNewMessages;

@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelGSCode;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelCreationDate;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;

@property (weak, nonatomic) IBOutlet UILabel *labelPublishedAgo;
@property (weak, nonatomic) IBOutlet UIImageView *imageOwner;
@property (weak, nonatomic) IBOutlet UIImageView *imageOwnerStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelOwnerName;
@property (weak, nonatomic) IBOutlet UILabel *labelOwnerZone;
@property (weak, nonatomic) IBOutlet UILabel *labelOwnerAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelOwnerPhones;
@property (weak, nonatomic) IBOutlet UIImageView *picOwnerZone;
@property (weak, nonatomic) IBOutlet UIImageView *picOwnerPhone;

@property (weak, nonatomic) IBOutlet UITableView *tableMessages;
@property (weak, nonatomic) IBOutlet UITableView *tableOpportunities;

/*
-(IBAction)relateToClient:(id)sender;
-(IBAction)showPopoverClientPicker:(id)sender;
-(IBAction)showPopoverSendMessageBuyer:(id)sender;
-(IBAction)showPopoverSendMessageOwner:(id)sender;
-(IBAction)CreateOpportunity:(id)sender;
//-(IBAction)newOpportunity:(id)sender;
*/

@end
