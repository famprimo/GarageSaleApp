//
//  Settings.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/06/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (strong, nonatomic) NSString *fb_user_id;
@property (strong, nonatomic) NSString *fb_user_name;
@property (strong, nonatomic) NSString *fb_page_id;
@property (strong, nonatomic) NSString *fb_page_name;
@property (strong, nonatomic) NSString *fb_page_token;
@property (strong, nonatomic) NSString *initial_data_loaded; // (Y)es (N)o
@property (strong, nonatomic) NSDate *template_last_update;
@property (strong, nonatomic) NSDate *product_last_update;
@property (strong, nonatomic) NSDate *client_last_update;
@property (strong, nonatomic) NSDate *opportunity_last_update;

@end
