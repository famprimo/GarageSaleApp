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
@property (strong, nonatomic) NSNumber *initial_price;
@property (strong, nonatomic) NSNumber *price_sold;
@property (strong, nonatomic) NSDate *created_time;
@property (strong, nonatomic) NSDate *closedsold_time;
@property (strong, nonatomic) NSDate *paid_time;
@property (strong, nonatomic) NSString *status; // (O)pen (C)losed (S)old (P)aid
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSNumber *commision;
@property (strong, nonatomic) NSString *agent_id;
@property (strong, nonatomic) NSDate *update_db;

@end
