//
//  ClientModel.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ClientModel.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SettingsModel.h"
#import "CommonMethods.h"

@implementation ClientModel

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)saveInitialDataforClients;
{
    // Array to hold the listing data
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
    
    // Create client #1
    Client *tempClient = [[Client alloc] init];
    tempClient.client_id = @"00001";
    tempClient.fb_client_id = @"10152779700000001";
    tempClient.fb_inbox_id = @"";
    tempClient.fb_page_message_id = @"";
    tempClient.type = @"F";
    tempClient.name = @"Georghette";
    tempClient.last_name = @"Juliette Sutta";
    tempClient.sex = @"F";
    tempClient.client_zone = @"San Isidro";
    tempClient.address = @"Camino Real 234 Dpto 102";
    tempClient.phone1 = @"98-133-1313";
    tempClient.phone2 = @"443-2414";
    tempClient.phone3 = @"";
    tempClient.email = @"georghette@hotmail.com";
    tempClient.preference = @"F";
    tempClient.picture_link = @"http://www.mpibpc.mpg.de/9488052/profile_image.jpg";
    tempClient.status = @"U";
    tempClient.created_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_inventory_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_interacted_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    
    // Add client #1 to the array
    [self addNewClient:tempClient];
    
    // Create client #2
    tempClient = [[Client alloc] init];
    tempClient.client_id = @"00002";
    tempClient.fb_client_id = @"10152779700000002";
    tempClient.fb_inbox_id = @"";
    tempClient.fb_page_message_id = @"";
    tempClient.type = @"F";
    tempClient.name = @"Natalia";
    tempClient.last_name = @"Gallardo";
    tempClient.sex = @"F";
    tempClient.client_zone = @"Surco";
    tempClient.address = @"Av. Benavides 3213";
    tempClient.phone1 = @"97-123-5113";
    tempClient.phone2 = @"225-1515";
    tempClient.phone3 = @"";
    tempClient.email = @"ngallardo@hotmail.com";
    tempClient.preference = @"F";
    tempClient.picture_link = @"http://www.cambridgewhoswho.com/Images/Site/ImageManager/cf582880-74cc-4262-91ef-f70964e21ed4.JPG";
    tempClient.status = @"V";
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    tempClient.created_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_inventory_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_interacted_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    
    // Add client #2 to the array
    [self addNewClient:tempClient];
    
    // Create client #3
    tempClient = [[Client alloc] init];
    tempClient.client_id = @"00003";
    tempClient.fb_client_id = @"10152779700000003";
    tempClient.fb_inbox_id = @"";
    tempClient.fb_page_message_id = @"";
    tempClient.type = @"F";
    tempClient.name = @"Melisa";
    tempClient.last_name = @"Celi";
    tempClient.sex = @"F";
    tempClient.client_zone = @"Miraflores";
    tempClient.address = @"Av. Pardo 413";
    tempClient.phone1 = @"98-233-5113";
    tempClient.phone2 = @"444-1515";
    tempClient.phone3 = @"";
    tempClient.email = @"mceli@hotmail.com";
    tempClient.preference = @"F";
    tempClient.picture_link = @"http://www.modelscout.com/images/media_storage/1191/profile.jpg";
    tempClient.status = @"U";
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    tempClient.created_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_inventory_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_interacted_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    
    // Add client #3 to the array
    [self addNewClient:tempClient];
    
    // Create client #4
    tempClient = [[Client alloc] init];
    tempClient.client_id = @"00004";
    tempClient.fb_client_id = @"10152779700000004";
    tempClient.fb_inbox_id = @"";
    tempClient.fb_page_message_id = @"";
    tempClient.type = @"F";
    tempClient.name = @"Amparo";
    tempClient.last_name = @"Gonzalez";
    tempClient.sex = @"F";
    tempClient.client_zone = @"San Isidro";
    tempClient.address = @"Barcelona 433";
    tempClient.phone1 = @"97-233-1513";
    tempClient.phone2 = @"222-1515";
    tempClient.phone3 = @"";
    tempClient.email = @"agonzalez@hotmail.com";
    tempClient.preference = @"F";
    tempClient.picture_link = @"http://cdn.niketalk.com/8/80/175x400px-LM-80a1f338_speaker_20120329160049.jpeg";
    tempClient.status = @"U";
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    tempClient.created_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_inventory_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_interacted_time = [formatFBdates dateFromString:@"2015-01-20T18:45:38+0000"];
    
    // Add client #4 to the array
    [self addNewClient:tempClient];
    
    // Create client #5
    tempClient = [[Client alloc] init];
    tempClient.client_id = @"00005";
    tempClient.fb_client_id = @"10152779700000005";
    tempClient.fb_inbox_id = @"";
    tempClient.fb_page_message_id = @"";
    tempClient.type = @"F";
    tempClient.name = @"Ivan";
    tempClient.last_name = @"Rosado";
    tempClient.sex = @"M";
    tempClient.client_zone = @"Magdalena";
    tempClient.address = @"La Mar 414";
    tempClient.phone1 = @"98-589-4819";
    tempClient.phone2 = @"445-2566";
    tempClient.phone3 = @"";
    tempClient.email = @"irosado@hotmail.com";
    tempClient.preference = @"F";
    tempClient.picture_link = @"http://www.changemakers.com/sites/default/files/imagecache/changeshops_profile_picture_large/pictures/picture-95545.jpg";
    tempClient.status = @"B";
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    tempClient.created_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_inventory_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_interacted_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    
    // Add client #5 to the array
    [self addNewClient:tempClient];
    
    // Create client #6
    tempClient = [[Client alloc] init];
    tempClient.client_id = @"00006";
    tempClient.fb_client_id = @"10152779700000006";
    tempClient.fb_inbox_id = @"";
    tempClient.fb_page_message_id = @"";
    tempClient.type = @"F";
    tempClient.name = @"Mily";
    tempClient.last_name = @"de la Cruz";
    tempClient.sex = @"F";
    tempClient.client_zone = @"Surco";
    tempClient.address = @"La Castellana 2342";
    tempClient.phone1 = @"99-144-1515";
    tempClient.phone2 = @"725-2666";
    tempClient.phone3 = @"";
    tempClient.email = @"mdelacruz@gmail.com";
    tempClient.preference = @"F";
    tempClient.picture_link = @"http://www.cutechoice.com/celeb/Marilyn_Monroe/profile.jpg";
    tempClient.status = @"V";
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    tempClient.created_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_inventory_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempClient.last_interacted_time = [formatFBdates dateFromString:@"2014-09-20T18:45:38+0000"];
    
    // Add client #6 to the array
    [self addNewClient:tempClient];
    
}

- (NSMutableArray*)getClientsFromCoreData;
{
    NSMutableArray *clientsArray = [[NSMutableArray alloc] init];

    // Fetch data from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Clients"];
    clientsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

    // Set last product ID
    Client *clientToReview = [[Client alloc] init];
    int lastID = 0;
    
    for (int i=0; i<clientsArray.count; i=i+1)
    {
        clientToReview = [[Client alloc] init];
        clientToReview = (Client *)clientsArray[i];
        
        if ([clientToReview.client_id intValue] > lastID)
        {
            lastID = [clientToReview.client_id intValue];
        }
    }
    
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastCientID = lastID;
    
    return clientsArray;
}

- (void)syncCoreDataWithParse;
{
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Get latest information from Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Client"];
    [query whereKey:@"updatedAt" greaterThan:mainDelegate.sharedSettings.client_last_update];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find from Parse succeeded
            for (PFObject *parseObject in objects)
            {
                Client *clientFromParse = [[Client alloc] init];
                
                clientFromParse.client_id = [parseObject valueForKey:@"client_id"];
                clientFromParse.fb_client_id = [parseObject valueForKey:@"fb_client_id"];
                clientFromParse.fb_inbox_id = [parseObject valueForKey:@"fb_inbox_id"];
                clientFromParse.fb_page_message_id = [parseObject valueForKey:@"fb_page_message_id"];
                clientFromParse.type = [parseObject valueForKey:@"type"];
                clientFromParse.name = [parseObject valueForKey:@"name"];
                clientFromParse.last_name = [parseObject valueForKey:@"last_name"];
                clientFromParse.sex = [parseObject valueForKey:@"sex"];
                clientFromParse.client_zone = [parseObject valueForKey:@"client_zone"];
                clientFromParse.address = [parseObject valueForKey:@"address"];
                clientFromParse.phone1 = [parseObject valueForKey:@"phone1"];
                clientFromParse.phone2 = [parseObject valueForKey:@"phone2"];
                clientFromParse.phone3 = [parseObject valueForKey:@"phone3"];
                clientFromParse.email = [parseObject valueForKey:@"email"];
                clientFromParse.preference = [parseObject valueForKey:@"preference"];
                clientFromParse.picture_link = [parseObject valueForKey:@"picture_link"];
                clientFromParse.status = [parseObject valueForKey:@"status"];
                clientFromParse.created_time = [parseObject valueForKey:@"created_time"];
                clientFromParse.last_interacted_time = [parseObject valueForKey:@"last_interacted_time"];
                clientFromParse.last_inventory_time = [parseObject valueForKey:@"last_inventory_time"];
                clientFromParse.notes = [parseObject valueForKey:@"notes"];
                clientFromParse.agent_id = [parseObject valueForKey:@"agent_id"];
                clientFromParse.update_db = [parseObject valueForKey:@"update_db"];
                
                // Update object in CoreData
                NSString *results = [self updateClientToCoreData:clientFromParse];
                
                if ([results isEqualToString:@"NOT FOUND"])
                {
                    // Object is new! Add to CoreData;
                    [self addNewClientToCoreData:clientFromParse];
                }
                else if (![results isEqualToString:@"OK"])
                {
                    NSLog(@"Failed to update the Client object in CoreData");
                    [self.delegate clientsSyncedWithCoreData:NO];
                }
            }
            
            // Send messages to delegates
            [self.delegate clientsSyncedWithCoreData:YES];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Failed to retrieve the Client object from Parse. Error: %@ %@", error, [error userInfo]);
            [self.delegate clientsSyncedWithCoreData:NO];
        }
    }];
}

- (NSMutableArray*)getClientArray; // Return an array with all clients
{
    NSMutableArray *clientsArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    clientsArray = mainDelegate.sharedArrayClients;
    
    return clientsArray;
}

- (NSString*)getNextClientID;
{
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastCientID = mainDelegate.lastCientID + 1;

    NSString *nextID = [NSString stringWithFormat:@"00000000%d", mainDelegate.lastCientID];
    nextID = [nextID substringFromIndex:[nextID length] - 7];
    
    return nextID;
}

- (void)addNewClient:(Client*)newClient;
{
    CommonMethods *commonMethods = [[CommonMethods alloc] init];
    
    // Save object in Parse
    PFObject *parseObject = [PFObject objectWithClassName:@"Client"];
    
    parseObject[@"client_id"] = [commonMethods stringNotNil:newClient.client_id];
    parseObject[@"fb_client_id"] = [commonMethods stringNotNil:newClient.fb_client_id];
    parseObject[@"fb_inbox_id"] = [commonMethods stringNotNil:newClient.fb_inbox_id];
    parseObject[@"fb_page_message_id"] = [commonMethods stringNotNil:newClient.fb_page_message_id];
    parseObject[@"type"] = [commonMethods stringNotNil:newClient.type];
    parseObject[@"name"] = [commonMethods stringNotNil:newClient.name];
    parseObject[@"last_name"] = [commonMethods stringNotNil:newClient.last_name];
    parseObject[@"sex"] = [commonMethods stringNotNil:newClient.sex];
    parseObject[@"client_zone"] = [commonMethods stringNotNil:newClient.client_zone];
    parseObject[@"address"] = [commonMethods stringNotNil:newClient.address];
    parseObject[@"phone1"] = [commonMethods stringNotNil:newClient.phone1];
    parseObject[@"phone2"] = [commonMethods stringNotNil:newClient.phone2];
    parseObject[@"phone3"] = [commonMethods stringNotNil:newClient.phone3];
    parseObject[@"email"] = [commonMethods stringNotNil:newClient.email];
    parseObject[@"preference"] = [commonMethods stringNotNil:newClient.preference];
    parseObject[@"picture_link"] = [commonMethods stringNotNil:newClient.picture_link];
    parseObject[@"status"] = [commonMethods stringNotNil:newClient.status];
    parseObject[@"created_time"] = [commonMethods dateNotNil:newClient.created_time];
    parseObject[@"last_interacted_time"] = [commonMethods dateNotNil:newClient.last_interacted_time];
    parseObject[@"last_inventory_time"] = [commonMethods dateNotNil:newClient.last_inventory_time];
    parseObject[@"notes"] = [commonMethods stringNotNil:newClient.notes];
    parseObject[@"agent_id"] = [commonMethods stringNotNil:newClient.agent_id];
    
    newClient.update_db = [NSDate date]; // Set update time to DB to now
    parseObject[@"update_db"] = newClient.update_db;

    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            // The object has been saved to Parse! ... Add to CoreData
            
            if ([self addNewClientToCoreData:newClient])
            {
                [self.delegate clientAddedOrUpdated:YES];
            }
            else
            {
                [self.delegate clientAddedOrUpdated:NO];
            }
        }
        else
        {
            // There was a problem, check error.description
            NSLog(@"Can't Save Client in Parse! %@", error.description);
            [self.delegate clientAddedOrUpdated:NO];
        }
    }];
}

- (BOOL)addNewClientToCoreData:(Client*)newClient;
{
    BOOL updateSucceed = YES;
    
    // Save object in Core Data
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Clients" inManagedObjectContext:context];
    
    [coreDataObject setValue:newClient.client_id forKey:@"client_id"];
    [coreDataObject setValue:newClient.fb_client_id forKey:@"fb_client_id"];
    [coreDataObject setValue:newClient.fb_inbox_id forKey:@"fb_inbox_id"];
    [coreDataObject setValue:newClient.fb_page_message_id forKey:@"fb_page_message_id"];
    [coreDataObject setValue:newClient.type forKey:@"type"];
    [coreDataObject setValue:newClient.name forKey:@"name"];
    [coreDataObject setValue:newClient.last_name forKey:@"last_name"];
    [coreDataObject setValue:newClient.sex forKey:@"sex"];
    [coreDataObject setValue:newClient.client_zone forKey:@"client_zone"];
    [coreDataObject setValue:newClient.address forKey:@"address"];
    [coreDataObject setValue:newClient.client_id forKey:@"client_id"];
    [coreDataObject setValue:newClient.phone1 forKey:@"phone1"];
    [coreDataObject setValue:newClient.phone2 forKey:@"phone2"];
    [coreDataObject setValue:newClient.phone3 forKey:@"phone3"];
    [coreDataObject setValue:newClient.email forKey:@"email"];
    [coreDataObject setValue:newClient.preference forKey:@"preference"];
    [coreDataObject setValue:newClient.picture_link forKey:@"picture_link"];
    [coreDataObject setValue:newClient.status forKey:@"status"];
    [coreDataObject setValue:newClient.created_time forKey:@"created_time"];
    [coreDataObject setValue:newClient.last_interacted_time forKey:@"last_interacted_time"];
    [coreDataObject setValue:newClient.last_inventory_time forKey:@"last_inventory_time"];
    [coreDataObject setValue:newClient.notes forKey:@"notes"];
    [coreDataObject setValue:newClient.agent_id forKey:@"agent_id"];
    [coreDataObject setValue:newClient.update_db forKey:@"update_db"];

    NSError *error = nil;
    // Save the object to Core Data
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        updateSucceed = NO;
    }
    else // update successful!
    {
        // Add object to Shared Array
        AppDelegate *mainDelegate;
        mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        [mainDelegate.sharedArrayClients addObject:newClient];
        
        // Update last update time
        [[[SettingsModel alloc] init] updateSettingsClientDataUptaded:newClient.update_db];

        // Update last client ID if needed
        if ([newClient.client_id intValue] > mainDelegate.lastCientID)
        {
            mainDelegate.lastCientID = [newClient.client_id intValue];
        }

    }
    
    return updateSucceed;
}

- (void)updateClient:(Client*)clientToUpdate;
{
    // Update object in Parse
    
    PFQuery *query = [PFQuery queryWithClassName:@"Client"];
    [query whereKey:@"client_id" equalTo:clientToUpdate.client_id];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseObject, NSError *error) {
        if (!parseObject)
        {
            NSLog(@"Failed to retrieve the Client object from Parse");
            [self.delegate clientAddedOrUpdated:NO];
        }
        else
        {
            // The find from Parse succeeded... Update values
            parseObject[@"fb_client_id"] = clientToUpdate.fb_client_id;
            parseObject[@"fb_inbox_id"] = clientToUpdate.fb_inbox_id;
            parseObject[@"fb_page_message_id"] = clientToUpdate.fb_page_message_id;
            parseObject[@"type"] = clientToUpdate.type;
            parseObject[@"name"] = clientToUpdate.name;
            parseObject[@"last_name"] = clientToUpdate.last_name;
            parseObject[@"sex"] = clientToUpdate.sex;
            parseObject[@"client_zone"] = clientToUpdate.client_zone;
            parseObject[@"address"] = clientToUpdate.address;
            parseObject[@"phone1"] = clientToUpdate.phone1;
            parseObject[@"phone2"] = clientToUpdate.phone2;
            parseObject[@"phone3"] = clientToUpdate.phone3;
            parseObject[@"email"] = clientToUpdate.email;
            parseObject[@"preference"] = clientToUpdate.preference;
            parseObject[@"picture_link"] = clientToUpdate.picture_link;
            parseObject[@"status"] = clientToUpdate.status;
            parseObject[@"created_time"] = clientToUpdate.created_time;
            parseObject[@"last_interacted_time"] = clientToUpdate.last_interacted_time;
            parseObject[@"last_inventory_time"] = clientToUpdate.last_inventory_time;
            parseObject[@"notes"] = clientToUpdate.notes;
            parseObject[@"agent_id"] = clientToUpdate.agent_id;
            
            clientToUpdate.update_db = [NSDate date]; // Set update time to DB to now
            parseObject[@"update_db"] = clientToUpdate.update_db;
            
            [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    // The object has been saved to Parse! ... Update CoreData
                    
                    if ([[self updateClientToCoreData:clientToUpdate] isEqualToString:@"OK"])
                    {
                        [self.delegate clientAddedOrUpdated:YES];
                    }
                    else
                    {
                        [self.delegate clientAddedOrUpdated:NO];
                    }
                }
                else
                {
                    // There was a problem, check error.description
                    NSLog(@"Can't Save Client in Parse! %@", error.description);
                    [self.delegate clientAddedOrUpdated:NO];
                }
            }];
        }
    }];
}

- (NSString*)updateClientToCoreData:(Client*)clientToUpdate;
{
    NSString *updateResults = @"OK";

    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Clients" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"client_id", clientToUpdate.client_id];
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

            // Get original picture_link value

            [coreDataObject setValue:clientToUpdate.client_id forKey:@"client_id"];
            [coreDataObject setValue:clientToUpdate.fb_client_id forKey:@"fb_client_id"];
            [coreDataObject setValue:clientToUpdate.fb_inbox_id forKey:@"fb_inbox_id"];
            [coreDataObject setValue:clientToUpdate.fb_page_message_id forKey:@"fb_page_message_id"];
            [coreDataObject setValue:clientToUpdate.type forKey:@"type"];
            [coreDataObject setValue:clientToUpdate.name forKey:@"name"];
            [coreDataObject setValue:clientToUpdate.last_name forKey:@"last_name"];
            [coreDataObject setValue:clientToUpdate.sex forKey:@"sex"];
            [coreDataObject setValue:clientToUpdate.client_zone forKey:@"client_zone"];
            [coreDataObject setValue:clientToUpdate.address forKey:@"address"];
            [coreDataObject setValue:clientToUpdate.client_id forKey:@"client_id"];
            [coreDataObject setValue:clientToUpdate.phone1 forKey:@"phone1"];
            [coreDataObject setValue:clientToUpdate.phone2 forKey:@"phone2"];
            [coreDataObject setValue:clientToUpdate.phone3 forKey:@"phone3"];
            [coreDataObject setValue:clientToUpdate.email forKey:@"email"];
            [coreDataObject setValue:clientToUpdate.preference forKey:@"preference"];
            [coreDataObject setValue:clientToUpdate.picture_link forKey:@"picture_link"];
            [coreDataObject setValue:clientToUpdate.status forKey:@"status"];
            [coreDataObject setValue:clientToUpdate.created_time forKey:@"created_time"];
            [coreDataObject setValue:clientToUpdate.last_interacted_time forKey:@"last_interacted_time"];
            [coreDataObject setValue:clientToUpdate.last_inventory_time forKey:@"last_inventory_time"];
            [coreDataObject setValue:clientToUpdate.notes forKey:@"notes"];
            [coreDataObject setValue:clientToUpdate.agent_id forKey:@"agent_id"];
            [coreDataObject setValue:clientToUpdate.update_db forKey:@"update_db"];
            
            // Save object to Core Data
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", error, error.localizedDescription);
                updateResults = @"ERROR";
           }
            else // update successful!
            {
                // Replace object in Shared Array
                AppDelegate *mainDelegate;
                mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                
                Client *clientToReview = [[Client alloc] init];
                
                for (int i=0; i<mainDelegate.sharedArrayClients.count; i=i+1)
                {
                    clientToReview = [[Client alloc] init];
                    clientToReview = (Client *)mainDelegate.sharedArrayClients[i];
                    
                    if ([clientToReview.client_id isEqual:clientToUpdate.client_id])
                    {
                        [mainDelegate.sharedArrayClients replaceObjectAtIndex:i withObject:clientToUpdate];
                        break;
                    }
                }
                
                //Update last update time
                [[[SettingsModel alloc] init] updateSettingsClientDataUptaded:clientToUpdate.update_db];
            }
        }
    }
    return updateResults;
}

- (NSData*)getClientPhotoFrom:(Client*)clientSelected;
{
    NSData *clientPhoto;
    BOOL fetchSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ClientPhotos" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"client_id", clientSelected.client_id];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request");
        NSLog(@"%@, %@", error, error.localizedDescription);
        fetchSuccessful = NO;
    }
    else
    {
        if (result.count == 0)
        {
            fetchSuccessful = NO;
        }
        else
        {
            NSManagedObject *coreDataObject = (NSManagedObject *)[result objectAtIndex:0];
            
            // Get data for picture
            clientPhoto = [coreDataObject valueForKey:@"picture"];
        }
    }
    
    if (!fetchSuccessful)
    {
        // Use a generic Picture
        clientPhoto = UIImagePNGRepresentation([UIImage imageNamed:@"GenericClient"]);
        
        // Ask for photo in background
        if (clientSelected.picture_link)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:clientSelected.picture_link]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // Save photo on Core Data
                    NSManagedObjectContext *context = [self managedObjectContext];
                    NSManagedObject *coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"ClientPhotos" inManagedObjectContext:context];
                    
                    [coreDataObject setValue:clientSelected.client_id forKey:@"client_id"];
                    [coreDataObject setValue:picture forKey:@"picture"];
                    
                    NSError *error = nil;
                    // Save the object to Core Data
                    if (![context save:&error]) {
                        NSLog(@"Can't Save Client Photo! %@ %@", error, [error localizedDescription]);
                    }
                });
            });
        }
    }
    
    return clientPhoto;
}

- (NSString*)getClientIDfromFbId:(NSString*)clientFbIdToValidate;
{
    // Review an array of Messages to check if a given Message ID exists
    
    NSString *clientID = @"Not Found";
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Client *clientToReview = [[Client alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayClients.count; i=i+1)
    {
        clientToReview = [[Client alloc] init];
        clientToReview = (Client *)mainDelegate.sharedArrayClients[i];
        
        if ([clientToReview.fb_client_id isEqual:clientFbIdToValidate])
        {
            clientID = clientToReview.client_id;
            break;
        }
    }
    return clientID;
}

- (Client*)getClientFromClientId:(NSString*)clientIDtoSearch;
{
    // Review the array of clients and return the related object
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Client *clientToReview = [[Client alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayClients.count; i=i+1)
    {
        clientToReview = [[Client alloc] init];
        clientToReview = (Client *)mainDelegate.sharedArrayClients[i];
        
        if ([clientToReview.client_id isEqual:clientIDtoSearch])
        {
            break;
        }
    }
    return clientToReview;
}

@end
