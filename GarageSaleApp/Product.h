//
//  Product.h
//  GarageSale
//
//  Created by Federico Amprimo on 24/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *client_id;
@property (strong, nonatomic) NSString *GS_code;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *fb_photo_id;
@property (strong, nonatomic) NSString *currency; // (S/.) (USD)
@property (nonatomic) float initial_price;
@property (nonatomic) float published_price;
@property (strong, nonatomic) NSDate *created_time;
@property (strong, nonatomic) NSDate *updated_time;
@property (strong, nonatomic) NSDate *solddisabled_time;
@property (strong, nonatomic) NSDate *fb_updated_time;
@property (strong, nonatomic) NSString *type; // (S)ales (A)dvertising
@property (strong, nonatomic) NSString *picture_link;
@property (strong, nonatomic) NSData *picture;
@property (strong, nonatomic) NSString *additional_pictures;
@property (strong, nonatomic) NSString *status; // (N)ew (U)pdated (S)old (D)isabled
@property (strong, nonatomic) NSDate *last_promotion_time;
@property (nonatomic) int promotion_piority; // 1,2,3 (default is 2)
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSString *agent_id;

@end
