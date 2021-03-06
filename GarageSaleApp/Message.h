//
//  Message.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, nonatomic) NSString *fb_inbox_id;
@property (strong, nonatomic) NSString *fb_msg_id;
@property (strong, nonatomic) NSString *fb_from_id;
@property (strong, nonatomic) NSString *fb_from_name;
@property (strong, nonatomic) NSString *parent_fb_msg_id;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *fb_created_time;
@property (strong, nonatomic) NSDate *datetime;
@property (strong, nonatomic) NSString *fb_photo_id;
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *client_id;
@property (strong, nonatomic) NSString *attachments; // (Y)es (N)o
@property (strong, nonatomic) NSString *agent_id;
@property (strong, nonatomic) NSString *status; // (N)ew (R)ead
@property (strong, nonatomic) NSString *type; // (P)hoto comment (I)nbox for user (M)essage to page
@property (strong, nonatomic) NSString *recipient; // (G)arageSale (C)lient


@end
