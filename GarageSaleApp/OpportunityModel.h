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
#import "Client.h"

@interface OpportunityModel : NSObject

- (void)saveInitialDataforOpportunities;
- (NSMutableArray*)getOpportunitiesFromCoreData;
- (NSMutableArray*)getOpportunitiesArray;
- (NSString*)getNextOpportunityID;
- (BOOL)addNewOpportunity:(Opportunity*)newOpportunity;
- (BOOL)updateOpportunity:(Opportunity*)opportunityToUpdate;
- (NSMutableArray*)getOpportunitiesFromProduct:(NSString*)productFromID;
- (NSMutableArray*)getOpportunitiesRelatedToClient:(NSString*)clientID;
- (Client*)getClient:(Opportunity*)opportunitySelected;
- (Client*)getOwner:(Opportunity*)opportunitySelected;

@end
