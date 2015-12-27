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
#import <Parse/Parse.h>
#import "SettingsModel.h"
#import "CommonMethods.h"

@interface OpportunityModel ()
{
    // Data for temp objects
    NSMutableArray *allObjects;
    NSUInteger skipValue;
    NSUInteger limitValue;
}
@end

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
    tempOpportunity.closedsold_time = [dateFormat dateFromString:@"20000101"];
    tempOpportunity.paid_time = [dateFormat dateFromString:@"20000101"];
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
    tempOpportunity.paid_time = [dateFormat dateFromString:@"20000101"];
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
    tempOpportunity.closedsold_time = [dateFormat dateFromString:@"20000101"];
    tempOpportunity.paid_time = [dateFormat dateFromString:@"20000101"];
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
    tempOpportunity.paid_time = [dateFormat dateFromString:@"20000101"];
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
    tempOpportunity.price_sold = [NSNumber numberWithFloat:0];;
    tempOpportunity.created_time = [dateFormat dateFromString:@"20140601"];
    tempOpportunity.closedsold_time = [dateFormat dateFromString:@"20140603"];
    tempOpportunity.paid_time = [dateFormat dateFromString:@"20140610"];
    tempOpportunity.status = @"P";
    tempOpportunity.notes = @"Vendido";
    tempOpportunity.commision = [NSNumber numberWithFloat:0];
    tempOpportunity.agent_id = @"00001";
    
    // Add opportunity #5 to the array
    [self addNewOpportunity:tempOpportunity];
    
}

- (NSMutableArray*)getOpportunitiesFromCoreData;
{
    NSMutableArray *opportunitiesArray = [[NSMutableArray alloc] init];
    
    // Fetch data from Core Data
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

- (void)syncCoreDataWithParse;
{
    allObjects = [[NSMutableArray alloc] init];
    limitValue = 1000;
    skipValue = 0;
    
    [self recursiveSyncCoreDataWithParse];
}

- (void)recursiveSyncCoreDataWithParse;
{
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Get latest information from Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Opportunity"];
    [query setLimit: limitValue];
    [query setSkip: skipValue];
    [query whereKey:@"updatedAt" greaterThan:mainDelegate.sharedSettings.opportunity_last_update];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find from Parse succeeded
            [allObjects addObjectsFromArray:objects];
            if (objects.count >= limitValue)
            {
                // There might be more objects in the table. Update the skip value and execute the query again.
                skipValue = skipValue + limitValue;
                [self recursiveSyncCoreDataWithParse];
            }
            else
            {
                // There are no more objects in the tables. Process it!
                [self processSyncCoreDataWithParse];
            }
        }
        else
        {
            // Log details of the failure
            NSLog(@"Failed to retrieve the Opportunity object from Parse. Error: %@ %@", error, [error userInfo]);
            [self.delegate opportunitiesSyncedWithCoreData:NO];
        }
    }];
}

- (void)processSyncCoreDataWithParse;
{
    for (PFObject *parseObject in allObjects)
    {
        Opportunity *opportunityFromParse = [[Opportunity alloc] init];
        
        opportunityFromParse.opportunity_id = [parseObject valueForKey:@"opportunity_id"];
        opportunityFromParse.product_id = [parseObject valueForKey:@"product_id"];
        opportunityFromParse.client_id = [parseObject valueForKey:@"client_id"];
        opportunityFromParse.initial_price = [parseObject valueForKey:@"initial_price"];
        opportunityFromParse.price_sold = [parseObject valueForKey:@"price_sold"];
        opportunityFromParse.created_time = [parseObject valueForKey:@"created_time"];
        opportunityFromParse.closedsold_time = [parseObject valueForKey:@"closedsold_time"];
        opportunityFromParse.paid_time = [parseObject valueForKey:@"paid_time"];
        opportunityFromParse.status = [parseObject valueForKey:@"status"];
        opportunityFromParse.notes = [parseObject valueForKey:@"notes"];
        opportunityFromParse.commision = [parseObject valueForKey:@"commision"];
        opportunityFromParse.agent_id = [parseObject valueForKey:@"agent_id"];
        opportunityFromParse.update_db = [parseObject valueForKey:@"update_db"];
        
        // Update object in CoreData
        NSString *results = [self updateOpportunityToCoreData:opportunityFromParse];
        
        if ([results isEqualToString:@"NOT FOUND"])
        {
            // Object is new! Add to CoreData;
            [self addNewOpportunityToCoreData:opportunityFromParse];
        }
        else if (![results isEqualToString:@"OK"])
        {
            NSLog(@"Failed to update the Opportunity object in CoreData");
            [self.delegate opportunitiesSyncedWithCoreData:NO];
        }
    }
    
    // Send messages to delegates
    [self.delegate opportunitiesSyncedWithCoreData:YES];
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

- (void)addNewOpportunity:(Opportunity*)newOpportunity;
{
    CommonMethods *commonMethods = [[CommonMethods alloc] init];
    
    // Save object in Parse
    PFObject *parseObject = [PFObject objectWithClassName:@"Opportunity"];
    
    parseObject[@"opportunity_id"] = [commonMethods stringNotNil:newOpportunity.opportunity_id];
    parseObject[@"product_id"] = [commonMethods stringNotNil:newOpportunity.product_id];
    parseObject[@"client_id"] = [commonMethods stringNotNil:newOpportunity.client_id];
    parseObject[@"initial_price"] = [commonMethods numberNotNil:newOpportunity.initial_price];
    parseObject[@"price_sold"] = [commonMethods numberNotNil:newOpportunity.price_sold];
    parseObject[@"created_time"] = [commonMethods dateNotNil:newOpportunity.created_time];
    parseObject[@"closedsold_time"] = [commonMethods dateNotNil:newOpportunity.closedsold_time];
    parseObject[@"paid_time"] = [commonMethods dateNotNil:newOpportunity.paid_time];
    parseObject[@"status"] = [commonMethods stringNotNil:newOpportunity.status];
    parseObject[@"notes"] = [commonMethods stringNotNil:newOpportunity.notes];
    parseObject[@"commision"] = [commonMethods numberNotNil:newOpportunity.commision];
    parseObject[@"agent_id"] = [commonMethods stringNotNil:newOpportunity.agent_id];

    newOpportunity.update_db = [NSDate date]; // Set update time to DB to now
    parseObject[@"update_db"] = newOpportunity.update_db;
    
    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            // The object has been saved to Parse! ... Add to CoreData
            
            if ([self addNewOpportunityToCoreData:newOpportunity])
            {
                [self.delegate opportunityAddedOrUpdated:YES];
            }
            else
            {
                [self.delegate opportunityAddedOrUpdated:NO];
            }
        }
        else
        {
            // There was a problem, check error.description
            NSLog(@"Can't Save Opportunity in Parse! %@", error.description);
            [self.delegate opportunityAddedOrUpdated:NO];
        }
    }];
}

- (BOOL)addNewOpportunityToCoreData:(Opportunity*)newOpportunity;
{
    BOOL updateSucceed = YES;
    
    // Save object in Core Data
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
    [coreDataObject setValue:newOpportunity.update_db forKey:@"update_db"];
    
    NSError *error = nil;
    // Save the object to Core Data
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        updateSucceed = NO;
    }
    else // update successful!
    {
        // To have access to shared arrays from AppDelegate
        AppDelegate *mainDelegate;
        mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        [mainDelegate.sharedArrayOpportunities addObject:newOpportunity];
        
        // Update last update time
        [[[SettingsModel alloc] init] updateSettingsOpportunityDataUptaded:newOpportunity.update_db];
        
        // Update last opportunity ID if needed
        if ([newOpportunity.opportunity_id intValue] > mainDelegate.lastOpportunityID)
        {
            mainDelegate.lastOpportunityID = [newOpportunity.opportunity_id intValue];
        }
    }
    
    return updateSucceed;
}

- (void)updateOpportunity:(Opportunity*)opportunityToUpdate;
{
    // Update object in Parse
    
    PFQuery *query = [PFQuery queryWithClassName:@"Opportunity"];
    [query whereKey:@"opportunity_id" equalTo:opportunityToUpdate.opportunity_id];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseObject, NSError *error) {
        if (!parseObject)
        {
            NSLog(@"Failed to retrieve the Opportunity object from Parse");
            [self.delegate opportunityAddedOrUpdated:NO];
        }
        else
        {
            // The find from Parse succeeded... Update values
            parseObject[@"opportunity_id"] = opportunityToUpdate.opportunity_id;
            parseObject[@"product_id"] = opportunityToUpdate.product_id;
            parseObject[@"client_id"] = opportunityToUpdate.client_id;
            parseObject[@"initial_price"] = opportunityToUpdate.initial_price;
            parseObject[@"price_sold"] = opportunityToUpdate.price_sold;
            parseObject[@"created_time"] = opportunityToUpdate.created_time;
            parseObject[@"closedsold_time"] = opportunityToUpdate.closedsold_time;
            parseObject[@"paid_time"] = opportunityToUpdate.paid_time;
            parseObject[@"status"] = opportunityToUpdate.status;
            parseObject[@"notes"] = opportunityToUpdate.notes;
            parseObject[@"commision"] = opportunityToUpdate.commision;
            parseObject[@"agent_id"] = opportunityToUpdate.agent_id;

            opportunityToUpdate.update_db = [NSDate date]; // Set update time to DB to now
            parseObject[@"update_db"] = opportunityToUpdate.update_db;
            
            [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    // The object has been saved to Parse! ... Update CoreData
                    
                    if ([[self updateOpportunityToCoreData:opportunityToUpdate] isEqualToString:@"OK"])
                    {
                        [self.delegate opportunityAddedOrUpdated:YES];
                    }
                    else
                    {
                        [self.delegate opportunityAddedOrUpdated:NO];
                    }
                }
                else
                {
                    // There was a problem, check error.description
                    NSLog(@"Can't Save Opportunity in Parse! %@", error.description);
                    [self.delegate opportunityAddedOrUpdated:NO];
                }
            }];
        }
    }];
}

- (NSString*)updateOpportunityToCoreData:(Opportunity*)opportunityToUpdate;
{
    NSString *updateResults = @"OK";

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
        updateResults = @"ERROR";
    }
    else
    {
        if (result.count == 0)
        {
            NSLog(@"No records retrieved");
            updateResults = @"NOT FOUND";
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
            [coreDataObject setValue:opportunityToUpdate.update_db forKey:@"update_db"];
            
            // Save object to Core Data
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", error, error.localizedDescription);
                updateResults = @"ERROR";
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

                //Update last update time
                [[[SettingsModel alloc] init] updateSettingsOpportunityDataUptaded:opportunityToUpdate.update_db];
            }
        }
    }
    return updateResults;
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
