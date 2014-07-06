//
//  Opportunity.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 6/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Opportunity : NSObject

@property (strong, nonatomic) NSString *opportunity_id;
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *client_id;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) float initial_price;
@property (nonatomic) float price_sold;
@property (strong, nonatomic) NSDate *date_sold;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *notes;
@property (nonatomic) float commision;
@property (strong, nonatomic) NSString *agent_id;

@end
