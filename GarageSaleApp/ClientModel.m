//
//  ClientModel.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ClientModel.h"
#import "AppDelegate.h"

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
    tempClient.picture_link = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/v/t1.0-1/p160x160/13227_10154822754980034_3516905964764442388_n.jpg?oh=ec5c9467d94a78fd8c33a85bd0eb0a82&oe=55087E5B&__gda__=1426066228_4f50ac543640da7bea4a89f6bfd7353e";
    // tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Viking.png"];
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
    tempClient.picture_link = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p160x160/10177352_10152306607879355_3463040953093391515_n.jpg?oh=4ba670df935912f9dce6e0a5a151a1d3&oe=551CEBAA&__gda__=1423084861_dc45ddcedfa5fa77850e4e241840ab7b";
    //tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Viking.png"];
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
    tempClient.picture_link = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/v/t1.0-1/p160x160/10343013_10152545434713487_289713323910298441_n.jpg?oh=5e643c07a9d10ef1d61d17e7d8c312fa&oe=550CA916&__gda__=1427863572_60212911c0480e4b78f345ba994f6431";
    //tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Viking.png"];
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
    tempClient.picture_link = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn2/v/t1.0-1/c7.0.160.160/p160x160/65036_10151780886293183_681281220_n.jpg?oh=fc125deb814768604a31f045dcf72883&oe=5557E56C&__gda__=1430826886_e893e670def3748195212ef3c7ee3b2d";
    //tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Viking.png"];
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
    tempClient.picture_link = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p100x100/10511237_10152645380304306_8224228609259690732_n.jpg?oh=9f8678b442f63fa897d72cb59515805b&oe=5515A7CD&__gda__=1427114842_e102a1ee5b6fa91558a3860061290846";
    //tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Viking.png"];
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
    tempClient.picture_link = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn2/v/t1.0-1/c170.50.621.621/s100x100/534197_483266975032862_774796863_n.jpg?oh=210d0b95aea49f4295413e99db77324e&oe=55128B4D&__gda__=1426615286_87328eba86c85ceac37239096b249a00";
    //tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.picture = [NSData dataWithContentsOfFile:@"/Users/famprimo/Downloads/Viking.png"];
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

    // Fetch data from persistent data store
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


- (BOOL)addNewClient:(Client*)newClient;
{
    BOOL updateSuccessful = YES;
    
    // Save object in persistent data store
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
    [coreDataObject setValue:newClient.picture forKey:@"picture"];
    [coreDataObject setValue:newClient.status forKey:@"status"];
    [coreDataObject setValue:newClient.created_time forKey:@"created_time"];
    [coreDataObject setValue:newClient.last_interacted_time forKey:@"last_interacted_time"];
    [coreDataObject setValue:newClient.last_inventory_time forKey:@"last_inventory_time"];
    [coreDataObject setValue:newClient.notes forKey:@"notes"];
    [coreDataObject setValue:newClient.agent_id forKey:@"agent_id"];
    
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
        
        [mainDelegate.sharedArrayClients addObject:newClient];
    }

    return updateSuccessful;
}


- (BOOL)updateClient:(Client*)clientToUpdate;
{
    BOOL updateSuccessful = YES;
    
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
            [coreDataObject setValue:clientToUpdate.picture forKey:@"picture"];
            [coreDataObject setValue:clientToUpdate.status forKey:@"status"];
            [coreDataObject setValue:clientToUpdate.created_time forKey:@"created_time"];
            [coreDataObject setValue:clientToUpdate.last_interacted_time forKey:@"last_interacted_time"];
            [coreDataObject setValue:clientToUpdate.last_inventory_time forKey:@"last_inventory_time"];
            [coreDataObject setValue:clientToUpdate.notes forKey:@"notes"];
            [coreDataObject setValue:clientToUpdate.agent_id forKey:@"agent_id"];
            
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
            }
        }
    }

    return updateSuccessful;
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


- (UIImage*)getImageFromClientId:(NSString*)clientIDtoSearch;
{
    // Review the array of clients and return the related picture
    
    UIImage *clientImage = nil;
    
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
            clientImage = [UIImage imageWithData:clientToReview.picture];
            break;
        }
    }
    return clientImage;
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
