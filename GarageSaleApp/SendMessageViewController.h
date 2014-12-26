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

-(void)MessageSent;
-(NSString*)GetTemplateTypeFromMessage;
-(NSString*)GetBuyerIdFromMessage;
-(NSString*)GetOwnerIdFromMessage;
-(NSString*)GetProductIdFromMessage;

@end

@interface SendMessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<SendMessageViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *buttonSend;
@property (strong, nonatomic) IBOutlet UITextView *labelTemplateText;
@property (strong, nonatomic) IBOutlet UITableView *tableTemplates;
@property (strong, nonatomic) IBOutlet UIImageView *imageClient;
@property (strong, nonatomic) IBOutlet UIImageView *imageClientStatus;
@property (strong, nonatomic) IBOutlet UILabel *labelClientName;

-(IBAction)sendMessage:(id)sender;

@end
