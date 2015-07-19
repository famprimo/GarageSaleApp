//
//  SendMessageViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 18/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"
#import "Product.h"

@protocol SendMessageViewControllerDelegate

-(void)messageSent:(NSString*)postType; // postType = (P)hoto (I)nbox (M)essage
-(NSString*)getTemplateTypeFromMessage;
-(NSString*)getBuyerIdFromMessage;
-(NSString*)getOwnerIdFromMessage;
-(NSString*)getProductIdFromMessage;
-(NSString*)getMessageIdFromMessage;

@end

@interface SendMessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<SendMessageViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIImageView *imageBuyer;
@property (weak, nonatomic) IBOutlet UIImageView *imageBuyerStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelBuyerName;
@property (weak, nonatomic) IBOutlet UIImageView *imageOwner;
@property (weak, nonatomic) IBOutlet UIImageView *imageOwnerStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelOwnerName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UIImageView *imageProductSold;
@property (weak, nonatomic) IBOutlet UILabel *labelProductDesc;

@property (strong, nonatomic) IBOutlet UIButton *buttonSend;
@property (weak, nonatomic) IBOutlet UIButton *buttonPostInPhoto;
@property (strong, nonatomic) IBOutlet UITextView *labelTemplateText;


@property (weak, nonatomic) IBOutlet UISegmentedControl *filterTabs;
@property (strong, nonatomic) IBOutlet UITableView *tableTemplates;
@property (strong, nonatomic) IBOutlet UIImageView *imageClient;
@property (strong, nonatomic) IBOutlet UIImageView *imageClientStatus;
@property (strong, nonatomic) IBOutlet UILabel *labelClientName;

-(IBAction)sendMessage:(id)sender;

@end
