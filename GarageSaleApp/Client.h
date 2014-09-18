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
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *zone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *phone1;
@property (strong, nonatomic) NSString *phone2;
@property (strong, nonatomic) NSString *phone3;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *preference;
//@property (nonatomic) Boolean *owner;
@property (strong, nonatomic) NSString *facebook_id;
@property (strong, nonatomic) NSString *picture_link;
@property (strong, nonatomic) NSData *picture;
@property (strong, nonatomic) NSDate *last_inventory;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSString *agent_id;

@end
