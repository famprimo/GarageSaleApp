//
//  MessageDetailViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "MessageModel.h"

@interface MessageDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UIButton *buttonReply;
@property (strong, nonatomic) IBOutlet UIButton *buttonAlreadyReplied;
@property (strong, nonatomic) IBOutlet UIButton *buttonRelateToOwner;

@property (strong, nonatomic) IBOutlet UILabel *labelPublishedDateReference;
@property (strong, nonatomic) IBOutlet UILabel *labelMessageDate;
@property (strong, nonatomic) IBOutlet UILabel *labelClientPhone;
@property (strong, nonatomic) IBOutlet UILabel *labelClientDetails;
@property (strong, nonatomic) IBOutlet UILabel *labelClientName;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDetails;
@property (strong, nonatomic) IBOutlet UIImageView *imageClient;
@property (strong, nonatomic) IBOutlet UIImageView *imageClientStatus;

@property (strong, nonatomic) IBOutlet UIImageView *imageProduct;
@property (strong, nonatomic) IBOutlet UIImageView *imageProductSold;
@property (strong, nonatomic) IBOutlet UILabel *labelOwnerName;
@property (strong, nonatomic) IBOutlet UILabel *labelOwnerZone;
@property (strong, nonatomic) IBOutlet UILabel *labelOwnerAddress;
@property (strong, nonatomic) IBOutlet UILabel *labelOwnerPhones;
@property (strong, nonatomic) IBOutlet UIImageView *imageOwner;
@property (strong, nonatomic) IBOutlet UILabel *imageOwnerStatus;

@end
