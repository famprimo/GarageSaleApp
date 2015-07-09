//
//  OpportunityModel.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "OpportunityModel.h"
#import "Opportunity.h"
#import "Product.h"
#import "ProductModel.h"
#import "AppDelegate.h"

@implementation OpportunityModel

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)saveInitialDataforOpportunities;
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    // Create opportunity #1
    Opportunity *tempOpportunity = [[Opportunity alloc] init];
    tempOpportunity.opportunity_id = @"0000001";
    tempOpportunity.product_id = @"0000001";
    tempOpportunity.client_id = @"00003";
    tempOpportunity.initial_price = [NSNumber numberWithFloat:290.0];
    tempOpportunity.price_sold = [NSNumber numberWithFloat:0];
    tempOpportunity.created_time = [dateFormat dateFromString:@"20140501"];
    tempOpportunity.closedsold_time = nil;
    tempOpportunity.paid_time = nil;
    tempOpportunity.status = @"O";
    tempOpportunity.notes = @"Notas";
    tempOpportunity.commision = [NSNumber numberWithFloat:0];;
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #1 to the array
    [self addNewOpportunity:tempOpportunity];

    // Create opportunity #2
    tempOpportunity = [[Opportunity alloc] init];
    tempOpportunity.opportunity_id = @"0000002";
    tempOpportunity.product_id = @"0000001";
    tempOpportunity.client_id = @"00004";
    tempOpportunity.initial_price = [NSNumber numberWithFloat:290.0];
    tempOpportunity.price_sold = [NSNumber numberWithFloat:0];
    tempOpportunity.created_time = [dateFormat dateFromString:@"20140530"];
    tempOpportunity.closedsold_time = [dateFormat dateFromString:@"20140620"];
    tempOpportunity.paid_time = nil;
    tempOpportunity.status = @"C";
    tempOpportunity.notes = @"Notas";
    tempOpportunity.commision = [NSNumber numberWithFloat:0];;
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #2 to the array
    [self addNewOpportunity:tempOpportunity];

    // Create opportunity #3
    tempOpportunity = [[Opportunity alloc] init];
    tempOpportunity.opportunity_id = @"0000003";
    tempOpportunity.product_id = @"0000002";
    tempOpportunity.client_id = @"00002";
    tempOpportunity.initial_price = [NSNumber numberWithFloat:1100.0];
    tempOpportunity.price_sold = [NSNumber numberWithFloat:0];
    tempOpportunity.created_time = [dateFormat dateFromString:@"20140302"];
    tempOpportunity.closedsold_time = nil;
    tempOpportunity.paid_time = nil;
    tempOpportunity.status = @"O";
    tempOpportunity.notes = @"Notas";
    tempOpportunity.commision = [NSNumber numberWithFloat:0];;
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #3 to the array
    [self addNewOpportunity:tempOpportunity];

    // Create opportunity #4
    tempOpportunity = [[Opportunity alloc] init];
    tempOpportunity.opportunity_id = @"0000004";
    tempOpportunity.product_id = @"0000004";
    tempOpportunity.client_id = @"00005";
    tempOpportunity.initial_price = [NSNumber numberWithFloat:100000];
    tempOpportunity.price_sold = [NSNumber numberWithFloat:990000];
    tempOpportunity.created_time = [dateFormat dateFromString:@"20131201"];
    tempOpportunity.closedsold_time = [dateFormat dateFromString:@"20131220"];
    tempOpportunity.paid_time = nil;
    tempOpportunity.status = @"S";
    tempOpportunity.notes = @"Vendido por el dueno";
    tempOpportunity.commision = [NSNumber numberWithFloat:10000];
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #4 to the array
    [self addNewOpportunity:tempOpportunity];

    // Create opportunity #5
    tempOpportunity = [[Opportunity alloc] init];
    tempOpportunity.opportunity_id = @"0000005";
    tempOpportunity.product_id = @"0000002";
    tempOpportunity.client_id = @"00006";
    tempOpportunity.initial_price = [NSNumber numberWithFloat:250.0];
    tempOpportunity.price_sold = 0;
    tempOpportunity.created_time = [dateFormat dateFromString:@"20140601"];
    tempOpportunity.closedsold_time = [dateFormat dateFromString:@"20140603"];
    tempOpportunity.paid_time = [dateFormat dateFromString:@"20140610"];
    tempOpportunity.status = @"P";
    tempOpportunity.notes = @"Vendido";
    tempOpportunity.commision = [NSNumber numberWithFloat:0];;
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #5 to the array
    [self addNewOpportunity:tempOpportunity];
    
}

- (NSMutableArray*)getOpportunitiesFromCoreData;
{
    NSMutableArray *opportunitiesArray = [[NSMutableArray alloc] init];
    
    // Fetch data from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Opportunities"];
    opportunitiesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    // Set last product ID
    Opportunity *opportunityToReview = [[Opportunity alloc] init];
    int lastID = 0;
    
    for (int i=0; i<opportunitiesArray.count; i=i+1)
    {
        opportunityToReview = [[Opportunity alloc] init];
        opportunityToReview = (Opportunity *)opportunitiesArray[i];
        
        if ([opportunityToReview.opportunity_id intValue] > lastID)
        {
            lastID = [opportunityToReview.opportunity_id intValue];
        }
    }
    
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastOpportunityID = lastID;
    
    return opportunitiesArray;
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
    
    // Save object in persistent data store
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Opportunities" inManagedObjectContext:context];
    
    [coreDataObject setValue:newOpportunity.opportunity_id forKey:@"opportunity_id"];
    [coreDataObject setValue:newOpportunity.product_id forKey:@"product_id"];
    [coreDataObject setValue:newOpportunity.client_id forKey:@"client_id"];
    [coreDataObject setValue:newOpportunity.initial_price forKey:@"initial_price"];
    [coreDataObject setValue:newOpportunity.price_sold forKey:@"price_sold"];
    [coreDataObject setValue:newOpportunity.created_time forKey:@"created_time"];
    [coreDataObject setValue:newOpportunity.closedsold_time forKey:@"closedsold_time"];
    [coreDataObject setValue:newOpportunity.paid_time forKey:@"paid_time"];
    [coreDataObject setValue:newOpportunity.status forKey:@"status"];
    [coreDataObject setValue:newOpportunity.notes forKey:@"notes"];
    [coreDataObject setValue:newOpportunity.commision forKey:@"commision"];
    [coreDataObject setValue:newOpportunity.agent_id forKey:@"agent_id"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        updateSuccessful = NO;
    }
    else // update successful!
    {
        // To have access to shared arrays from AppDelegate
        AppDelegate *mainDelegate;
        mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        [mainDelegate.sharedArrayOpportunities addObject:newOpportunity];
    }
    
    return updateSuccessful;
}

- (BOOL)updateOpportunity:(Opportunity*)opportunityToUpdate;
{
    BOOL updateSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Opportunities" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"opportunity_id", opportunityToUpdate.opportunity_id];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request");
        NSLog(@"%@, %@", error, error.localizedDescription);
        updateSuccessful = NO;
    }
    else
    {
        if (result.count == 0)
        {
            NSLog(@"No records retrieved");
            updateSuccessful = NO;
        }
        else
        {
            // Set updated values
            NSManagedObject *coreDataObject = (NSManagedObject *)[result objectAtIndex:0];
            
            [coreDataObject setValue:opportunityToUpdate.opportunity_id forKey:@"opportunity_id"];
            [coreDataObject setValue:opportunityToUpdate.product_id forKey:@"product_id"];
            [coreDataObject setValue:opportunityToUpdate.client_id forKey:@"client_id"];
            [coreDataObject setValue:opportunityToUpdate.initial_price forKey:@"initial_price"];
            [coreDataObject setValue:opportunityToUpdate.price_sold forKey:@"price_sold"];
            [coreDataObject setValue:opportunityToUpdate.created_time forKey:@"created_time"];
            [coreDataObject setValue:opportunityToUpdate.closedsold_time forKey:@"closedsold_time"];
            [coreDataObject setValue:opportunityToUpdate.paid_time forKey:@"paid_time"];
            [coreDataObject setValue:opportunityToUpdate.status forKey:@"status"];
            [coreDataObject setValue:opportunityToUpdate.notes forKey:@"notes"];
            [coreDataObject setValue:opportunityToUpdate.commision forKey:@"commision"];
            [coreDataObject setValue:opportunityToUpdate.agent_id forKey:@"agent_id"];
            
            // Save object to persistent store
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", error, error.localizedDescription);
                updateSuccessful = NO;
            }
            else // update successful!
            {
                // To have access to shared arrays from AppDelegate
                AppDelegate *mainDelegate;
                mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                
                // Replace object in Shared Array
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
        }
    }
    
    return updateSuccessful;
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
    
    return opportunitiesArray;

}

- (NSMutableArray*)getOpportunitiesRelatedToClient:(NSString*)clientID;
{
    NSMutableArray *opportunitiesArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Opportunity *opportunityToReview = [[Opportunity alloc] init];
    Product *tmpProduct = [[Product alloc] init];
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayOpportunities.count; i=i+1)
    {
        opportunityToReview = [[Opportunity alloc] init];
        opportunityToReview = (Opportunity *)mainDelegate.sharedArrayOpportunities[i];
        
        tmpProduct = [productMethods getProductFromProductId:opportunityToReview.product_id];
        
        if ([opportunityToReview.client_id isEqualToString:clientID] || [tmpProduct.client_id isEqualToString:clientID])
        {
            [opportunitiesArray addObject:opportunityToReview];
        }
    }
        
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
        if (opportunitySelected.client_id == clientTemp.client_id)
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
