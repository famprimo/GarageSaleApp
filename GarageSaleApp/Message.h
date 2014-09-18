//
//  Message.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, nonatomic) NSString *message_main_id;
@property (strong, nonatomic) NSString *message_detail_id;
@property (strong, nonatomic) NSString *from_facebook_id;
@property (strong, nonatomic) NSString *from_facebook_name;
@property (strong, nonatomic) NSString *facebook_link;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *time;
@property (strong, nonatomic) NSString *from_client_id;
@property (strong, nonatomic) NSString *agent_id;
@property (nonatomic) Boolean *done;

@end
