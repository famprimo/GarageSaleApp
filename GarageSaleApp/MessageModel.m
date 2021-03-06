//
//  MessageModel.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "MessageModel.h"
#import "AppDelegate.h"

@implementation MessageModel

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)saveInitialDataforMessages;
{
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000

    // Create message #1
    Message *tempMessage = [[Message alloc] init];
    tempMessage.fb_inbox_id = @"153344961539458";
    tempMessage.fb_msg_id = @"153344961539458_1378402423";
    tempMessage.fb_from_id = @"10203554768023190";
    tempMessage.fb_from_name = @"Mily de la Cruz";
    tempMessage.parent_fb_msg_id = nil;
    tempMessage.message = @"Me interesa. Enviar datos al inbox";
    tempMessage.fb_created_time = @"2014-09-20T18:45:38+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"0000001";
    tempMessage.client_id = @"00006";
    tempMessage.attachments = @"N";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"N";
    tempMessage.type = @"P";
    tempMessage.datetime = [formatFBdates dateFromString:@"2014-06-20T16:41:15+0000"];
    tempMessage.recipient = @"G";
   
    // Add message #1 to the array
    [self addNewMessage:tempMessage];
    
    // Create message #2
    tempMessage = [[Message alloc] init];
    tempMessage.fb_inbox_id = @"1469889866608936";
    tempMessage.fb_msg_id = @"1469889866608936_1408489028";
    tempMessage.fb_from_id = @"10152156045491377";
    tempMessage.fb_from_name = @"Amparo Gonzalez";
    tempMessage.parent_fb_msg_id = nil;
    tempMessage.message = @"Cuales son las medidas?";
    tempMessage.fb_created_time = @"2015-01-20T18:45:38+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"";
    tempMessage.client_id = @"00004";
    tempMessage.attachments = @"N";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"R";
    tempMessage.type = @"I";
    tempMessage.datetime = [formatFBdates dateFromString:@"2014-05-10T16:41:15+0000"];
    tempMessage.recipient = @"G";
    
    // Add message #2 to the array
    [self addNewMessage:tempMessage];
    
    // Create message #3
    tempMessage = [[Message alloc] init];
    tempMessage.fb_inbox_id = @"1469889866608936";
    tempMessage.fb_msg_id = @"1469889866608936_143534523426";
    tempMessage.fb_from_id = @"10152156045491377";
    tempMessage.fb_from_name = @"Amparo Gonzalez";
    tempMessage.parent_fb_msg_id = nil;
    tempMessage.message = @"Me gusta el perfume. Como lo consigo?";
    tempMessage.fb_created_time = @"2014-06-10T09:41:15+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"0000002";
    tempMessage.client_id = @"00004";
    tempMessage.attachments = @"N";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"R";
    tempMessage.type = @"P";
    tempMessage.datetime = [formatFBdates dateFromString:@"2014-06-10T09:41:15+0000"];
    tempMessage.recipient = @"G";
    
    // Add message #3 to the array
    [self addNewMessage:tempMessage];

    // Create message #4
    tempMessage = [[Message alloc] init];
    tempMessage.fb_inbox_id = @"1469889866608936";
    tempMessage.fb_msg_id = @"1469889866608936_143534523426";
    tempMessage.fb_from_id = @"10152156045491377";
    tempMessage.fb_from_name = @"Amparo Gonzalez";
    tempMessage.parent_fb_msg_id = nil;
    tempMessage.message = @"Amparo te envio los datos al inbox";
    tempMessage.fb_created_time = @"2014-07-10T09:41:15+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"0000002";
    tempMessage.client_id = @"00004";
    tempMessage.attachments = @"N";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"R";
    tempMessage.type = @"P";
    tempMessage.datetime = [formatFBdates dateFromString:@"2014-07-10T09:41:15+0000"];
    tempMessage.recipient = @"C";
    
    // Add message #4 to the array
    [self addNewMessage:tempMessage];

    // Create message #5
    tempMessage = [[Message alloc] init];
    tempMessage.fb_inbox_id = @"1469889866608936";
    tempMessage.fb_msg_id = @"1469889866608936_143534523426";
    tempMessage.fb_from_id = @"10152779700000003";
    tempMessage.fb_from_name = @"Melisa Celi";
    tempMessage.parent_fb_msg_id = nil;
    tempMessage.message = @"Melisa fuiste a ver el coche?";
    tempMessage.fb_created_time = @"2015-02-23T09:41:15+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"";
    tempMessage.client_id = @"00003";
    tempMessage.attachments = @"N";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"R";
    tempMessage.type = @"I";
    tempMessage.datetime = [formatFBdates dateFromString:@"2015-02-23T09:41:15+0000"];
    tempMessage.recipient = @"C";
    
    // Add message #5 to the array
    [self addNewMessage:tempMessage];

    // Create message #6
    tempMessage = [[Message alloc] init];
    tempMessage.fb_inbox_id = @"1469889866608936";
    tempMessage.fb_msg_id = @"1469889866608936_143534523426";
    tempMessage.fb_from_id = @"10152779700000003";
    tempMessage.fb_from_name = @"Melisa Celi";
    tempMessage.parent_fb_msg_id = nil;
    tempMessage.message = @"Si fui pero no lo compre";
    tempMessage.fb_created_time = @"2015-02-24T09:41:15+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"";
    tempMessage.client_id = @"00003";
    tempMessage.attachments = @"N";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"N";
    tempMessage.type = @"I";
    tempMessage.datetime = [formatFBdates dateFromString:@"2015-02-24T09:41:15+0000"];
    tempMessage.recipient = @"G";
    
    // Add message #6 to the array
    [self addNewMessage:tempMessage];

    // Create message #7
    tempMessage = [[Message alloc] init];
    tempMessage.fb_inbox_id = @"1469889866608936";
    tempMessage.fb_msg_id = @"1469889866608936_143534523426";
    tempMessage.fb_from_id = @"10152779700000005";
    tempMessage.fb_from_name = @"Ivan Rosado";
    tempMessage.parent_fb_msg_id = nil;
    tempMessage.message = @"Ok";
    tempMessage.fb_created_time = @"2015-02-20T10:45:15+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"";
    tempMessage.client_id = @"00005";
    tempMessage.attachments = @"N";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"N";
    tempMessage.type = @"I";
    tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time ];
    tempMessage.recipient = @"C";
    
    // Add message #7 to the array
    [self addNewMessage:tempMessage];

    // Create message #8
    tempMessage = [[Message alloc] init];
    tempMessage.fb_inbox_id = @"1469889866608936";
    tempMessage.fb_msg_id = @"1469889866608936_143534523426";
    tempMessage.fb_from_id = @"10152779700000005";
    tempMessage.fb_from_name = @"Ivan Rosado";
    tempMessage.parent_fb_msg_id = nil;
    tempMessage.message = @"Ivan te explico el sistema de GarageSale en el inbox";
    tempMessage.fb_created_time = @"2015-02-20T10:50:15+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"";
    tempMessage.client_id = @"00005";
    tempMessage.attachments = @"N";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"N";
    tempMessage.type = @"I";
    tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time ];
    tempMessage.recipient = @"C";
    
    // Add message #8 to the array
    [self addNewMessage:tempMessage];

    for (int i=0; i<20; i=i+1) {
        
        // Create message #?
        tempMessage = [[Message alloc] init];
        tempMessage.fb_inbox_id = @"1469889866608936";
        tempMessage.fb_msg_id = @"1469889866608936_143534523426";
        tempMessage.fb_from_id = @"10152779700000005";
        tempMessage.fb_from_name = @"Ivan Rosado";
        tempMessage.parent_fb_msg_id = nil;
        tempMessage.message = [NSString stringWithFormat:@"Mensaje de prueba #%i", i];
        tempMessage.fb_created_time = @"2015-02-19T09:41:15+0000";
        tempMessage.fb_photo_id = @"XXXXX";
        tempMessage.product_id = @"";
        tempMessage.client_id = @"00005";
        tempMessage.attachments = @"N";
        tempMessage.agent_id = @"00001";
        tempMessage.status = @"N";
        tempMessage.type = @"I";
        tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time ];
        tempMessage.recipient = @"G";
        
        // Add message #? to the array
        [self addNewMessage:tempMessage];

    }
}

- (NSMutableArray*)getMessagesFromCoreData; // Return an array with all messages
{
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    
    // Fetch data from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Messages"];
    messagesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return messagesArray;
}

- (NSMutableArray*)getMessagesArrayFromClient:(NSString*)clientFromID; // Return an array with all messages from a client
{
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
   
    // Fetch data from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Messages"];
    
    NSPredicate *predicateFetch = [NSPredicate predicateWithFormat:@"client_id like[c] %@", clientFromID];
    [fetchRequest setPredicate:predicateFetch];
    
    messagesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

    return messagesArray;
}

- (NSMutableArray*)getMessagesArrayForProduct:(NSString*)productForID; // Return an array with all messages for a product
{
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    
    // Fetch data from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Messages"];
    
    NSPredicate *predicateFetch = [NSPredicate predicateWithFormat:@"product_id like[c] %@", productForID];
    [fetchRequest setPredicate:predicateFetch];
    
    messagesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return messagesArray;
}

- (Message*)getLastMessageFromClient:(NSString*)clientFromID; // Return the last message for a specific client
{
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    Message *lastMessage;
    Message *messageToReview = [[Message alloc] init];
    int indexLastMessage = 0;
    BOOL lastMessageExists = NO;
    
    messagesArray = [self getMessagesArrayFromClient:clientFromID];

    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
    NSDate *lastMessageDate = [formatFBdates dateFromString:@"2000-01-01T10:00:00+0000"];
    
    for (int i=0; i<messagesArray.count; i=i+1)
    {
        messageToReview = [[Message alloc] init];
        messageToReview = (Message *)messagesArray[i];
        
        if ([messageToReview.client_id isEqual:clientFromID])
        {
            if ([lastMessageDate compare:messageToReview.datetime] == NSOrderedAscending) {
                lastMessageDate = messageToReview.datetime;
                indexLastMessage = i;
                lastMessageExists = YES;
            }
        }
    }

    if (lastMessageExists)
    {
        lastMessage = (Message *)messagesArray[indexLastMessage];
    }
    else
    {
        lastMessage = nil;
    }
    
    return lastMessage;
}

- (BOOL)addNewMessage:(Message*)newMessage;
{
    BOOL updateSuccessful = YES;
    
    // Save object in persistent data store
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:context];
    
    [coreDataObject setValue:newMessage.fb_inbox_id forKey:@"fb_inbox_id"];
    [coreDataObject setValue:newMessage.fb_msg_id forKey:@"fb_msg_id"];
    [coreDataObject setValue:newMessage.fb_from_id forKey:@"fb_from_id"];
    [coreDataObject setValue:newMessage.fb_from_name forKey:@"fb_from_name"];
    [coreDataObject setValue:newMessage.parent_fb_msg_id forKey:@"parent_fb_msg_id"];
    [coreDataObject setValue:newMessage.message forKey:@"message"];
    [coreDataObject setValue:newMessage.fb_created_time forKey:@"fb_created_time"];
    [coreDataObject setValue:newMessage.datetime forKey:@"datetime"];
    [coreDataObject setValue:newMessage.fb_photo_id forKey:@"fb_photo_id"];
    [coreDataObject setValue:newMessage.product_id forKey:@"product_id"];
    [coreDataObject setValue:newMessage.client_id forKey:@"client_id"];
    [coreDataObject setValue:newMessage.attachments forKey:@"attachments"];
    [coreDataObject setValue:newMessage.agent_id forKey:@"agent_id"];
    [coreDataObject setValue:newMessage.status forKey:@"status"];
    [coreDataObject setValue:newMessage.type forKey:@"type"];
    [coreDataObject setValue:newMessage.recipient forKey:@"recipient"];
   
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        updateSuccessful = NO;
    }
    
    return updateSuccessful;
}

- (BOOL)updateMessage:(Message*)messageToUpdate; // Update a message
{
    BOOL updateSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"fb_msg_id", messageToUpdate.fb_msg_id];
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
            
            [coreDataObject setValue:messageToUpdate.fb_inbox_id forKey:@"fb_inbox_id"];
            [coreDataObject setValue:messageToUpdate.fb_msg_id forKey:@"fb_msg_id"];
            [coreDataObject setValue:messageToUpdate.fb_from_id forKey:@"fb_from_id"];
            [coreDataObject setValue:messageToUpdate.fb_from_name forKey:@"fb_from_name"];
            [coreDataObject setValue:messageToUpdate.parent_fb_msg_id forKey:@"parent_fb_msg_id"];
            [coreDataObject setValue:messageToUpdate.message forKey:@"message"];
            [coreDataObject setValue:messageToUpdate.fb_created_time forKey:@"fb_created_time"];
            [coreDataObject setValue:messageToUpdate.datetime forKey:@"datetime"];
            [coreDataObject setValue:messageToUpdate.fb_photo_id forKey:@"fb_photo_id"];
            [coreDataObject setValue:messageToUpdate.product_id forKey:@"product_id"];
            [coreDataObject setValue:messageToUpdate.client_id forKey:@"client_id"];
            [coreDataObject setValue:messageToUpdate.attachments forKey:@"attachments"];
            [coreDataObject setValue:messageToUpdate.agent_id forKey:@"agent_id"];
            [coreDataObject setValue:messageToUpdate.status forKey:@"status"];
            [coreDataObject setValue:messageToUpdate.type forKey:@"type"];
            [coreDataObject setValue:messageToUpdate.recipient forKey:@"recipient"];
            
            // Save object to persistent store
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", error, error.localizedDescription);
                updateSuccessful = NO;
            }
         }
    }
    
    return updateSuccessful;
}

- (BOOL)existMessage:(NSString*)messageIDToValidate; // Review an array of Messages to check if a given Message ID exists
{
    BOOL exists = NO;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"fb_msg_id", messageIDToValidate];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request");
        NSLog(@"%@, %@", error, error.localizedDescription);
        exists = NO;
    }
    else
    {
        if (result.count == 0)
        {
            NSLog(@"No records retrieved");
            exists = NO;
        }
        else
        {
            exists = YES;
        }
    }

    return exists;
}

- (NSString*)getPhotoID:(NSString*)facebookLink; // Search for 'fbid=' on a Facebook link to get photo_id
{
    NSString *photoID;
    
    // Define FB structure used
    
    NSRange searchForPhotoId = [facebookLink rangeOfString:@"fbid="];
    
    if (searchForPhotoId.location != NSNotFound)
    {
        // /photo.php? fbid = PHOTO-ID & set=a.A1.A2.A3 & type=1 & comment_id = COMMENT-ID
        // http://www.facebook.com/photo.php?fbid=313343305510194&set=a.313343328843525.1073741826.100005035818112&type=1&comment_id=389975127847011
        
        NSRange searchForDelimiter = [facebookLink rangeOfString:@"&"];
        
        int locationPhotoID = (int) searchForPhotoId.location + 5;
        int lengthPhotoID =  (int) searchForDelimiter.location - locationPhotoID;
        
        photoID = [facebookLink substringWithRange: NSMakeRange(locationPhotoID, lengthPhotoID)];
    }
    else
    {
        // /USER-ID/ photos/a.A1.A2.A3 / PHOTO-ID / ? type=1 & comment_id = COMMENT-ID
        // http://www.facebook.com/186087991419907/photos/a.217254244969948.71908.186087991419907/965486550146710/?type=1&comment_id=996070043755027"
        
        // Using "/" as a delimeter to create an array
        NSArray *sections = [facebookLink componentsSeparatedByString:@"/"];
        
        photoID = [sections[6] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    }
    
    return photoID;
}

- (NSString*)getCommentID:(NSString*)facebookLink; // Search for 'comment_id=' on a Facebook link to get _id
{
    NSString *commentID;

    NSRange searchForCommentId = [facebookLink rangeOfString:@"comment_id="];
    
    int locationCommentID = (int) searchForCommentId.location + 11;
    
    NSString *textForSearch = [facebookLink substringWithRange: NSMakeRange(locationCommentID, facebookLink.length - locationCommentID)];
    

    NSRange searchForDelimiter = [textForSearch rangeOfString:@"&"];
    int lengthCommentID =  (int) searchForDelimiter.location;

    commentID = [facebookLink substringWithRange: NSMakeRange(locationCommentID, lengthCommentID)];

    return commentID;
}

- (NSString*)getMessagesIDs:(NSMutableArray*)messagesArray; // Method that returns the IDs of all the Messages in the array sent
{
    Message *tempMessage;
        
    NSMutableString *messagesIDList = [[NSMutableString alloc] init];
    
    for (int i=0; i<messagesArray.count; i=i+1)
    {
        if (i>0) { [messagesIDList appendString:@","]; }
        
        tempMessage = [[Message alloc] init];
        tempMessage = (Message *)messagesArray[i];
        
        [messagesIDList appendString:tempMessage.fb_msg_id];
    }
    
    return messagesIDList;
}

- (Message*)getMessageFromMessageId:(NSString*)messageIDtoSearch;
{
    Message *messageFound = [[Message alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"fb_msg_id", messageIDtoSearch];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    else
    {
        if (result.count == 0)
        {
            NSLog(@"No records retrieved");
            messageFound = nil;
        }
        else
        {
            // Message found!
            messageFound = (Message *)[result objectAtIndex:0];
        }
    }
    
    return messageFound;
}

- (int)numberOfUnreadMessages; // Method that returns the total number of unread messages
{
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    
    // Fetch data from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Messages"];
    
    NSPredicate *predicateFetch = [NSPredicate predicateWithFormat:@"status == 'N'"];
    [fetchRequest setPredicate:predicateFetch];
    
    messagesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return messagesArray.count;
}

- (int)numberOfUnreadMessagesForClient:(NSString*)clientFromID; // Method that returns the total number of unread messages for a client
{
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    
    // Fetch data from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Messages"];
    
    NSPredicate *predicateFetch = [NSPredicate predicateWithFormat:@"(status == 'N') AND (client_id == %@)", clientFromID];
    [fetchRequest setPredicate:predicateFetch];
    
    messagesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return messagesArray.count;
}

- (NSMutableArray*)sortMessagesArrayConsideringParents:(NSMutableArray*)messagesArray; // Order an array of messages considering parent messages
{
    // First, sort array by dates
    [messagesArray sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Message*)a datetime];
        NSDate *second = [(Message*)b datetime];
        return [first compare:second];
    }];
    
    Message *messageToReview = [[Message alloc] init];
    Message *parentMessage = [[Message alloc] init];

    for (int i=0; i<messagesArray.count; i++)
    {
        messageToReview = [[Message alloc] init];
        messageToReview = (Message *)messagesArray[i];

        if (messageToReview.parent_fb_msg_id)
        {
            // message has a parent! delete and insert next to its parent
            [messagesArray removeObjectAtIndex:i];
            BOOL found = NO;
            
            for (int x=0; x<messagesArray.count; x++)
            {
                parentMessage = [[Message alloc] init];
                parentMessage = (Message *)messagesArray[x];
                
                if ([parentMessage.fb_msg_id isEqualToString:messageToReview.parent_fb_msg_id])
                {
                    if (x == messagesArray.count)
                    {
                        [messagesArray addObject:messageToReview];  // Insert object at the end of the array
                    }
                    else
                    {
                        [messagesArray insertObject:messageToReview atIndex:x+1];
                    }
                    found = YES;
                    break;
                }
            }
            
            if (!found)
            {
                // Not found... insert in its original position
                [messagesArray insertObject:messageToReview atIndex:i];
            }
        }
    }

    return messagesArray;
}

@end
