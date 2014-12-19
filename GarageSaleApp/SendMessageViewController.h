//
//  SendMessageViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 18/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@protocol SendMessageViewControllerDelegate

-(void)MessageSent;
-(NSString*)GetTemplateTypeFromSendMessage;
-(NSString*)GetBuyerIdFromSendMessage;
-(NSString*)GetOwnerIdFromSendMessage;

@end

@interface SendMessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<SendMessageViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *buttonSend;
@property (strong, nonatomic) IBOutlet UITextView *labelTemplateText;
@property (strong, nonatomic) IBOutlet UITableView *tableTemplates;

-(IBAction)sendMessage:(id)sender;

@end
