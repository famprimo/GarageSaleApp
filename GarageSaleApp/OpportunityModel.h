//
//  OpportunityModel.h
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Opportunity.h"
#import "Product.h"

@interface OpportunityModel : NSObject

- (NSMutableArray*)getOpportunities:(NSMutableArray*)clientList;

@end
