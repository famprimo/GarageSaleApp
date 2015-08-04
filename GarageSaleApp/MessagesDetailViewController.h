//
//  MessagesDetailViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 06/02/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesTableViewController.h"
#import "Message.h"
#import "MessageModel.h"
#import "ClientPickerViewController.h"
#import "ProductPickerViewController.h"
#import "SendMessageViewController.h"
#import "NewOpportunityViewController.h"
#import "EditClientViewController.h"


// Popover help  http://www.appcoda.com/uiactionsheet-uipopovercontroller-tutorial/

@interface MessagesDetailViewController : UIViewController <UIActionSheetDelegate, ClientPickerViewControllerDelegate, ProductPickerViewControllerDelegate, SendMessageViewControllerDelegate, NewOpportunityViewControllerDelegate, EditClientViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIButton *buttonReply;
@property (weak, nonatomic) IBOutlet UIButton *buttonMessageToRelatedClient;
@property (weak, nonatomic) IBOutlet UIButton *buttonRelateToProduct;
@property (weak, nonatomic) IBOutlet UIButton *buttonRelateToOwner;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeeInFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonReviewNewMessages;

@property (weak, nonatomic) IBOutlet UIImageView *imageClient;
@property (weak, nonatomic) IBOutlet UIImageView *imageClientStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelClientName;
@property (weak, nonatomic) IBOutlet UILabel *labelClientDetails;
@property (weak, nonatomic) IBOutlet UIImageView *picClientPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelClientPhone;


@property (weak, nonatomic) IBOutlet UITableView *tableMessages;

@property (weak, nonatomic) IBOutlet UIImageView *picProductBackground;
@property (weak, nonatomic) IBOutlet UILabel *LabelProductRelated;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelProductGSCode;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductDetails;

@property (weak, nonatomic) IBOutlet UILabel *labelProductReference;
@property (weak, nonatomic) IBOutlet UILabel *labelClient2Title;
@property (weak, nonatomic) IBOutlet UIImageView *imageClient2;
@property (weak, nonatomic) IBOutlet UIImageView *imageClient2Status;
@property (weak, nonatomic) IBOutlet UILabel *labelClient2Name;

@property (weak, nonatomic) IBOutlet UILabel *labelClient2Address;
@property (weak, nonatomic) IBOutlet UILabel *labelClient2Zone;
@property (weak, nonatomic) IBOutlet UILabel *labelClient2Phones;
@property (weak, nonatomic) IBOutlet UIImageView *picClient2Zone;
@property (weak, nonatomic) IBOutlet UIImageView *picClient2Phone;


@property (weak, nonatomic) IBOutlet UILabel *labelOpportunitiesRelated;
@property (weak, nonatomic) IBOutlet UIButton *buttonNewOpportunity;
@property (weak, nonatomic) IBOutlet UITableView *tableOpportunities;



@end
