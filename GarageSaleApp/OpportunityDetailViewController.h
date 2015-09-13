//
//  OpportunityDetailViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 21/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opportunity.h"
#import "SendMessageViewController.h"
#import "EditOpportunityViewController.h"

@protocol OpportunityDetailViewControllerDelegate

-(void)opportunityUpdated;

@end


@interface OpportunityDetailViewController : UIViewController <UIActionSheetDelegate, SendMessageViewControllerDelegate, EditOpportunityViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (nonatomic, strong) id<OpportunityDetailViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelGSCode;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;


@property (weak, nonatomic) IBOutlet UILabel *labelIntroPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelIntroComission;

@property (weak, nonatomic) IBOutlet UILabel *labelOpportunityStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelOpportunityPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelOpportunityCommision;
@property (weak, nonatomic) IBOutlet UILabel *labelOpportunityCreatedDate;
@property (weak, nonatomic) IBOutlet UILabel *labelOpportunityClosedDate;
@property (weak, nonatomic) IBOutlet UILabel *labelOpportunitySoldDate;
@property (weak, nonatomic) IBOutlet UILabel *labelOpportunityPaidDate;
@property (weak, nonatomic) IBOutlet UILabel *labelOpportunityNotes;



@property (weak, nonatomic) IBOutlet UILabel *labelOwnerIntro;
@property (weak, nonatomic) IBOutlet UIImageView *imageOwner;
@property (weak, nonatomic) IBOutlet UIImageView *imageOwnerStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelOwnerName;
@property (weak, nonatomic) IBOutlet UILabel *labelOwnerAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelOwnerZone;
@property (weak, nonatomic) IBOutlet UILabel *labelOwnerPhones;
@property (weak, nonatomic) IBOutlet UIImageView *picOwnerZone;
@property (weak, nonatomic) IBOutlet UIImageView *picOwnerPhone;

@property (weak, nonatomic) IBOutlet UILabel *labelBuyerIntro;
@property (weak, nonatomic) IBOutlet UIImageView *imageBuyer;
@property (weak, nonatomic) IBOutlet UIImageView *imageBuyerStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelBuyerName;
@property (weak, nonatomic) IBOutlet UILabel *labelBuyerAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelBuyerZone;
@property (weak, nonatomic) IBOutlet UILabel *labelBuyerPhones;
@property (weak, nonatomic) IBOutlet UIImageView *picBuyerZone;
@property (weak, nonatomic) IBOutlet UIImageView *picBuyerPhone;

@property (weak, nonatomic) IBOutlet UIButton *buttonUpdate;
@property (weak, nonatomic) IBOutlet UIButton *buttonMessageToOwner;
@property (weak, nonatomic) IBOutlet UIButton *buttonMessageToBuyer;


@end
