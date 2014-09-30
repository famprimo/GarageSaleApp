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
@property (strong, nonatomic) NSString *facebook_id;
@property (strong, nonatomic) NSString *album_id;
@property (strong, nonatomic) NSString *currency;
@property (nonatomic) float initial_price;
@property (nonatomic) float published_price;
@property (strong, nonatomic) NSDate *publishing_date;
@property (strong, nonatomic) NSDate *final_date;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *picture_link;
@property (strong, nonatomic) NSData *picture;
@property (strong, nonatomic) NSString *additional_pictures;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSDate *last_promotion_date;
@property (nonatomic) int promotion_piority;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSString *agent_id;

@end
