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

@protocol OpportunityModelDelegate

-(void)opportunitiesSyncedWithCoreData:(BOOL)succeed;
-(void)opportunityAddedOrUpdated:(BOOL)succeed;

@end

@interface OpportunityModel : NSObject

@property (nonatomic, strong) id<OpportunityModelDelegate> delegate;

- (void)saveInitialDataforOpportunities;
- (NSMutableArray*)getOpportunitiesFromCoreData;
- (void)syncCoreDataWithParse;
- (NSMutableArray*)getOpportunitiesArray;
- (NSString*)getNextOpportunityID;
- (void)addNewOpportunity:(Opportunity*)newOpportunity;
- (void)updateOpportunity:(Opportunity*)opportunityToUpdate;
- (NSMutableArray*)getOpportunitiesFromProduct:(NSString*)productFromID;
- (NSMutableArray*)getOpportunitiesRelatedToClient:(NSString*)clientID;
- (Client*)getClient:(Opportunity*)opportunitySelected;
- (Client*)getOwner:(Opportunity*)opportunitySelected;

@end
