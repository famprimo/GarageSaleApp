//
//  MessagesDetailViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 06/02/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "MessageModel.h"
#import "ClientPickerViewController.h"
#import "SendMessageViewController.h"
#import "NewOpportunityViewController.h"

// Popover help  http://www.appcoda.com/uiactionsheet-uipopovercontroller-tutorial/

@interface MessagesDetailViewController : UIViewController <UIActionSheetDelegate, ClientPickerViewControllerDelegate, SendMessageViewControllerDelegate, NewOpportunityViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id detailItem;


@property (weak, nonatomic) IBOutlet UITableView *tableMessages;



@property (strong, nonatomic) IBOutlet UIButton *buttonReply;
@property (strong, nonatomic) IBOutlet UIButton *buttonAlreadyReplied;
@property (strong, nonatomic) IBOutlet UIButton *buttonRelateToOwner;
@property (strong, nonatomic) IBOutlet UIButton *buttonSeeInFacebook;
@property (strong, nonatomic) IBOutlet UIButton *buttonMessageToOwner;

@property (strong, nonatomic) IBOutlet UILabel *labelPublishedDateReference;
@property (strong, nonatomic) IBOutlet UILabel *labelMessageDate;
@property (strong, nonatomic) IBOutlet UILabel *labelClientPhone;
@property (strong, nonatomic) IBOutlet UILabel *labelClientDetails;
@property (strong, nonatomic) IBOutlet UILabel *labelClientName;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDetails;
@property (strong, nonatomic) IBOutlet UIImageView *imageClient;
@property (strong, nonatomic) IBOutlet UIImageView *imageClientStatus;
@property (strong, nonatomic) IBOutlet UIImageView *picClientPhone;


@property (strong, nonatomic) IBOutlet UILabel *LabelProductRelated;
@property (strong, nonatomic) IBOutlet UILabel *labelPublishedAgo;
@property (strong, nonatomic) IBOutlet UIImageView *imageProduct;
@property (strong, nonatomic) IBOutlet UIImageView *imageProductSold;
@property (strong, nonatomic) IBOutlet UILabel *labelOwnerName;
@property (strong, nonatomic) IBOutlet UILabel *labelOwnerZone;
@property (strong, nonatomic) IBOutlet UILabel *labelOwnerAddress;
@property (strong, nonatomic) IBOutlet UILabel *labelOwnerPhones;
@property (strong, nonatomic) IBOutlet UIImageView *imageOwner;
@property (strong, nonatomic) IBOutlet UIImageView *picOwnerZone;
@property (strong, nonatomic) IBOutlet UIImageView *picOwnerPhone;
@property (strong, nonatomic) IBOutlet UIImageView *imageOwnerStatus;

@property (strong, nonatomic) IBOutlet UILabel *labelOtherMessages;
@property (strong, nonatomic) IBOutlet UITableView *tableOtherMessages;
@property (strong, nonatomic) IBOutlet UIButton *buttonRelateToProduct;


@property (strong, nonatomic) IBOutlet UILabel *labelOpportunitiesForProduct;
@property (strong, nonatomic) IBOutlet UIButton *buttonNewOpportunity;
@property (strong, nonatomic) IBOutlet UITableView *tableOpportunities;

@end
