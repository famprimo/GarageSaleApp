//
//  SettingsModel.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 06/06/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "SettingsModel.h"
#import "AppDelegate.h"


@implementation SettingsModel

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)saveInitialDataforSettings;
{
    Settings *tempSettings = [[Settings alloc] init];
    tempSettings.fb_user_id = @"";
    tempSettings.fb_user_name = @"";
    tempSettings.fb_page_id = @"";
    tempSettings.fb_page_name = @"";
    tempSettings.fb_page_token = @"";
    tempSettings.initial_data_loaded = @"N";
    tempSettings.template_last_update = [NSDate date];
    tempSettings.product_last_update = [NSDate date];
    tempSettings.client_last_update = [NSDate date];
    tempSettings.opportunity_last_update = [NSDate date];
    
    [self addSettings:tempSettings];
}

- (Settings*)getSettingsFromCoreData;
{
    NSMutableArray *settingsArray = [[NSMutableArray alloc] init];
    Settings *settingsFromCoreData;
    
    // Fetch data from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Settings"];
    settingsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    if (settingsArray.count == 0)
    {
        settingsFromCoreData = nil;
    }
    else
    {
        settingsFromCoreData = (Settings*)[settingsArray objectAtIndex:0];
    }
    
    return settingsFromCoreData;
}

- (Settings*)getSharedSettings;
{
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    return mainDelegate.sharedSettings;
}

- (BOOL)addSettings:(Settings*)newSettings;
{
    BOOL updateSuccessful = YES;
    
    // Save object in Core Data
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:context];
    
    [coreDataObject setValue:newSettings.fb_user_id forKey:@"fb_user_id"];
    [coreDataObject setValue:newSettings.fb_user_name forKey:@"fb_user_name"];
    [coreDataObject setValue:newSettings.fb_page_id forKey:@"fb_page_id"];
    [coreDataObject setValue:newSettings.fb_page_name forKey:@"fb_page_name"];
    [coreDataObject setValue:newSettings.fb_page_token forKey:@"fb_page_token"];
    [coreDataObject setValue:newSettings.initial_data_loaded forKey:@"initial_data_loaded"];
    [coreDataObject setValue:newSettings.template_last_update forKey:@"template_last_update"];
    [coreDataObject setValue:newSettings.product_last_update forKey:@"product_last_update"];
    [coreDataObject setValue:newSettings.client_last_update forKey:@"client_last_update"];
    [coreDataObject setValue:newSettings.opportunity_last_update forKey:@"opportunity_last_update"];
    
    NSError *error = nil;
    // Save the object to Core Data
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        updateSuccessful = NO;
    }
    else // update successful!
    {
        // To have access to shared arrays from AppDelegate
        AppDelegate *mainDelegate;
        mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        mainDelegate.sharedSettings = [[Settings alloc] init];
        mainDelegate.sharedSettings.fb_user_id = newSettings.fb_user_id;
        mainDelegate.sharedSettings.fb_page_id = newSettings.fb_page_id;
        mainDelegate.sharedSettings.fb_page_token = newSettings.fb_page_token;
        mainDelegate.sharedSettings.initial_data_loaded = newSettings.initial_data_loaded;
        mainDelegate.sharedSettings.template_last_update = newSettings.template_last_update;
        mainDelegate.sharedSettings.product_last_update = newSettings.product_last_update;
        mainDelegate.sharedSettings.client_last_update = newSettings.client_last_update;
        mainDelegate.sharedSettings.opportunity_last_update = newSettings.opportunity_last_update;
    }
    
    return updateSuccessful;
}

- (BOOL)updateSettingsUser:(NSString*)userName withUserID:(NSString*)userID andPageID:(NSString*)pageID andPageName:(NSString*)pageName andPageTokenID:(NSString*)pageTokenID;
{
    BOOL updateSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

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

            [coreDataObject setValue:userID forKey:@"fb_user_id"];
            [coreDataObject setValue:userName forKey:@"fb_user_name"];
            [coreDataObject setValue:pageID forKey:@"fb_page_id"];
            [coreDataObject setValue:pageName forKey:@"fb_page_name"];
            [coreDataObject setValue:pageTokenID forKey:@"fb_page_token"];
            
            // Save object to Core Data
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

                mainDelegate.sharedSettings.fb_user_id = userID;
                mainDelegate.sharedSettings.fb_user_name = userName;
                mainDelegate.sharedSettings.fb_page_id = pageID;
                mainDelegate.sharedSettings.fb_page_name = pageName;
                mainDelegate.sharedSettings.fb_page_token = pageTokenID;
            }
        }
    }
    
    return updateSuccessful;
}

- (BOOL)updateSettingsInitialDataSaved;
{
    BOOL updateSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
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
            
            [coreDataObject setValue:@"Y" forKey:@"initial_data_loaded"];
            
            // Save object to Core Data
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

                mainDelegate.sharedSettings.initial_data_loaded = @"Y";
            }
        }
    }
    
    return updateSuccessful;
}

- (BOOL)updateSettingsTemplateDataUptaded:(NSDate*)lastUpdateDate;
{
    BOOL updateSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
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
            
            [coreDataObject setValue:lastUpdateDate forKey:@"template_last_update"];
            
            // Save object to Core Data
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
                
                mainDelegate.sharedSettings.template_last_update = lastUpdateDate;
            }
        }
    }
    
    return updateSuccessful;
}

- (BOOL)updateSettingsProductDataUptaded:(NSDate*)lastUpdateDate;
{
    BOOL updateSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
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
            
            [coreDataObject setValue:lastUpdateDate forKey:@"product_last_update"];
            
            // Save object to Core Data
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
                
                mainDelegate.sharedSettings.product_last_update = lastUpdateDate;
            }
        }
    }
    
    return updateSuccessful;
}

- (BOOL)updateSettingsClientDataUptaded:(NSDate*)lastUpdateDate;
{
    BOOL updateSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
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
            
            [coreDataObject setValue:lastUpdateDate forKey:@"client_last_update"];
            
            // Save object to Core Data
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
                
                mainDelegate.sharedSettings.client_last_update = lastUpdateDate;
            }
        }
    }
    
    return updateSuccessful;
}

- (BOOL)updateSettingsOpportunityDataUptaded:(NSDate*)lastUpdateDate;
{
    BOOL updateSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
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
            
            [coreDataObject setValue:lastUpdateDate forKey:@"opportunity_last_update"];
            
            // Save object to Core Data
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
                
                mainDelegate.sharedSettings.opportunity_last_update = lastUpdateDate;
            }
        }
    }
    
    return updateSuccessful;
}

@end
