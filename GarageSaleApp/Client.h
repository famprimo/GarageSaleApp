//
//  Client.h
//  GarageSale
//
//  Created by Federico Amprimo on 14/06/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject

@property (strong, nonatomic) NSString *client_id;
@property (strong, nonatomic) NSString *fb_client_id;
@property (strong, nonatomic) NSString *fb_inbox_id;
@property (strong, nonatomic) NSString *fb_page_message_id;
@property (strong, nonatomic) NSString *codeGS;
@property (strong, nonatomic) NSString *type; // (F)acebook (O)ffline
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *sex; // (M)ale (F)emale
@property (strong, nonatomic) NSString *client_zone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *phone1;
@property (strong, nonatomic) NSString *phone2;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *preference; // (E)mail (F)acebook
@property (strong, nonatomic) NSString *picture_link;
@property (strong, nonatomic) NSString *status; // (N)ew (U)pdated (V)erified (B)anned (D)eleted
@property (strong, nonatomic) NSDate *created_time;
@property (strong, nonatomic) NSDate *last_interacted_time;
@property (strong, nonatomic) NSDate *last_inventory_time;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSString *agent_id;
@property (strong, nonatomic) NSDate *update_db;

@end
