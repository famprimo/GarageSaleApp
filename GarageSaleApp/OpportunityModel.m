//
//  OpportunityModel.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "OpportunityModel.h"
#import "Opportunity.h"
#import "AppDelegate.h"

@implementation OpportunityModel

- (NSMutableArray*)getOpportunities:(NSMutableArray *)clientList
{
    // Array to hold the listing data
    NSMutableArray *opportunities = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    // Create opportunity #1
    Opportunity *tempOpportunity = [[Opportunity alloc] init];
    tempOpportunity.opportunity_id = @"0000001";
    tempOpportunity.product_id = @"0000001";
    tempOpportunity.buyer_id = @"00003";
    tempOpportunity.initial_price = 290.0;
    tempOpportunity.price_sold = 0;
    tempOpportunity.created_time = [dateFormat dateFromString:@"20140501"];
    tempOpportunity.closedsold_time = nil;
    tempOpportunity.paid_time = nil;
    tempOpportunity.status = @"O";
    tempOpportunity.notes = @"Notas";
    tempOpportunity.commision = 0;
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #1 to the array
    [opportunities addObject:tempOpportunity];

    // Create opportunity #2
    tempOpportunity = [[Opportunity alloc] init];
    tempOpportunity.opportunity_id = @"0000002";
    tempOpportunity.product_id = @"0000001";
    tempOpportunity.buyer_id = @"00004";
    tempOpportunity.initial_price = 290.0;
    tempOpportunity.price_sold = 0;
    tempOpportunity.created_time = [dateFormat dateFromString:@"20140530"];
    tempOpportunity.closedsold_time = nil;
    tempOpportunity.paid_time = nil;
    tempOpportunity.status = @"O";
    tempOpportunity.notes = @"Notas";
    tempOpportunity.commision = 0;
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #2 to the array
    [opportunities addObject:tempOpportunity];

    // Create opportunity #3
    tempOpportunity = [[Opportunity alloc] init];
    tempOpportunity.opportunity_id = @"0000003";
    tempOpportunity.product_id = @"0000002";
    tempOpportunity.buyer_id = @"00001";
    tempOpportunity.initial_price = 1100.0;
    tempOpportunity.price_sold = 0;
    tempOpportunity.created_time = [dateFormat dateFromString:@"20140302"];
    tempOpportunity.closedsold_time = nil;
    tempOpportunity.paid_time = nil;
    tempOpportunity.status = @"O";
    tempOpportunity.notes = @"Notas";
    tempOpportunity.commision = 0;
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #3 to the array
    [opportunities addObject:tempOpportunity];

    // Create opportunity #4
    tempOpportunity = [[Opportunity alloc] init];
    tempOpportunity.opportunity_id = @"0000004";
    tempOpportunity.product_id = @"0000004";
    tempOpportunity.buyer_id = @"00005";
    tempOpportunity.initial_price = 100000;
    tempOpportunity.price_sold = 990000;
    tempOpportunity.created_time = [dateFormat dateFromString:@"20131201"];
    tempOpportunity.closedsold_time = [dateFormat dateFromString:@"20131220"];
    tempOpportunity.paid_time = nil;
    tempOpportunity.status = @"S";
    tempOpportunity.notes = @"Vendido por el dueno";
    tempOpportunity.commision = 10000;
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #4 to the array
    [opportunities addObject:tempOpportunity];

    // Create opportunity #5
    tempOpportunity = [[Opportunity alloc] init];
    tempOpportunity.opportunity_id = @"0000005";
    tempOpportunity.product_id = @"0000002";
    tempOpportunity.buyer_id = @"00006";
    tempOpportunity.initial_price = 250.0;
    tempOpportunity.price_sold = 0;
    tempOpportunity.created_time = [dateFormat dateFromString:@"20140601"];
    tempOpportunity.closedsold_time = [dateFormat dateFromString:@"20140603"];
    tempOpportunity.paid_time = [dateFormat dateFromString:@"20140610"];
    tempOpportunity.status = @"P";
    tempOpportunity.notes = @"Vendido";
    tempOpportunity.commision = 0;
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #5 to the array
    [opportunities addObject:tempOpportunity];
    
    // Set last opportuniy ID
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastOpportunityID = 5;

    // Return the producct array as the return value
    return opportunities;
}

- (NSMutableArray*)getOpportunitiesArray; // Return an array with data
{
    NSMutableArray *opportunityArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    opportunityArray = mainDelegate.sharedArrayOpportunities;
    
    return opportunityArray;
}

- (NSString*)getNextOpportunityID;
{
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastOpportunityID = mainDelegate.lastOpportunityID + 1;
    
    NSString *nextID = [NSString stringWithFormat:@"%d", mainDelegate.lastOpportunityID];
    
    return nextID;
}

- (BOOL)addNewOpportunity:(Opportunity*)newOpportunity;
{
    BOOL updateSuccessful = YES;
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [mainDelegate.sharedArrayOpportunities addObject:newOpportunity];
    
    return updateSuccessful;
}

- (void)updateOpportunity:(Opportunity*)opportunityToUpdate;
{
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Opportunity *opportunityToReview = [[Opportunity alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayOpportunities.count; i=i+1)
    {
        opportunityToReview = [[Opportunity alloc] init];
        opportunityToReview = (Opportunity *)mainDelegate.sharedArrayOpportunities[i];
        
        if ([opportunityToReview.opportunity_id isEqual:opportunityToUpdate.opportunity_id])
        {
            [mainDelegate.sharedArrayOpportunities replaceObjectAtIndex:i withObject:opportunityToUpdate];
            break;
        }
    }
}

- (NSMutableArray*)getOpportunitiesFromProduct:(NSString*)productFromID;
{
    NSMutableArray *opportunitiesArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Opportunity *opportunityToReview = [[Opportunity alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayOpportunities.count; i=i+1)
    {
        opportunityToReview = [[Opportunity alloc] init];
        opportunityToReview = (Opportunity *)mainDelegate.sharedArrayOpportunities[i];
        
        if ([opportunityToReview.product_id isEqual:productFromID])
        {
            [opportunitiesArray addObject:opportunityToReview];
        }
    }
    
    // Sort array to be sure new messages are on top
    [opportunitiesArray sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Opportunity*)a created_time];
        NSDate *second = [(Opportunity*)b created_time];
        return [second compare:first];
        //return [first compare:second];
    }];

    return opportunitiesArray;

}


- (Client*)getClient:(Opportunity*)opportunitySelected;
{
    Client *clientFound = [[Client alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Look for the Client objetct
    for (int i = 0; i < mainDelegate.sharedArrayClients.count; i++)
    {
        Client* clientTemp = [mainDelegate.sharedArrayClients objectAtIndex: i];
        if (opportunitySelected.buyer_id == clientTemp.client_id)
        {
            clientFound = clientTemp;
            break;
        }
    }
    
    return clientFound;
}


- (Client*)getOwner:(Opportunity*)opportunitySelected;
{
    Client *ownerFound = [[Client alloc] init];
    NSString *clientId = [[NSString alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Look for client_id in the Product class
    for (int i = 0; i < mainDelegate.sharedArrayProducts.count; i++)
    {
        Product* productTemp = [mainDelegate.sharedArrayProducts objectAtIndex: i];
        if (opportunitySelected.product_id == productTemp.product_id)
        {
            clientId = productTemp.client_id;
            break;
        }
    }

    // Look for the Client objetct
    for (int i = 0; i < mainDelegate.sharedArrayClients.count; i++)
    {
        Client* clientTemp = [mainDelegate.sharedArrayClients objectAtIndex: i];
        if (clientId == clientTemp.client_id)
        {
            ownerFound = clientTemp;
            break;
        }
    }
    
    return ownerFound;

}

@end
