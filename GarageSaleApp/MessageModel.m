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

- (NSMutableArray*)getMessages; // Updates the array with message list with new messages from database
{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000

    // Create message #1
    Message *tempMessage = [[Message alloc] init];
    tempMessage.fb_msg_id = @"153344961539458_1378402423";
    tempMessage.fb_from_id = @"10203554768023190";
    tempMessage.fb_from_name = @"Mily de la Cruz";
    tempMessage.message = @"Me interesa. Enviar datos al inbox";
    tempMessage.fb_created_time = @"2014-09-20T18:45:38+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"0000001";
    tempMessage.client_id = @"00006";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"P";
    tempMessage.type = @"P";
    tempMessage.datetime = [formatFBdates dateFromString:@"2014-06-20T16:41:15+0000"];
    tempMessage.recipient = @"G";
   
    // Add message #1 to the array
    [messages addObject:tempMessage];
    
    // Create message #2
    tempMessage = [[Message alloc] init];
    tempMessage.fb_msg_id = @"1469889866608936_1408489028";
    tempMessage.fb_from_id = @"10152156045491377";
    tempMessage.fb_from_name = @"Amparo Gonzalez";
    tempMessage.message = @"Cuales son las medidas?";
    tempMessage.fb_created_time = @"2014-09-20T18:45:38+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"";
    tempMessage.client_id = @"00004";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"R";
    tempMessage.type = @"I";
    tempMessage.datetime = [formatFBdates dateFromString:@"2014-05-10T16:41:15+0000"];
    tempMessage.recipient = @"G";
    
    // Add message #2 to the array
    [messages addObject:tempMessage];
    
    // Create message #3
    tempMessage = [[Message alloc] init];
    tempMessage.fb_msg_id = @"1469889866608936_143534523426";
    tempMessage.fb_from_id = @"10152156045491377";
    tempMessage.fb_from_name = @"Amparo Gonzalez";
    tempMessage.message = @"Me gusta el perfume. Como lo consigo?";
    tempMessage.fb_created_time = @"2014-06-10T09:41:15+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.product_id = @"0000002";
    tempMessage.client_id = @"00004";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"P";
    tempMessage.type = @"P";
    tempMessage.datetime = [formatFBdates dateFromString:@"2014-06-10T09:41:15+0000"];
    tempMessage.recipient = @"G";
    
    // Add message #3 to the array
    [messages addObject:tempMessage];

    // Return the producct array as the return value
    return messages;
}

- (NSMutableArray*)getMessagesArray; // Return an array with all messages
{
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    messagesArray = mainDelegate.sharedArrayMessages;
    
    return messagesArray;
}

- (NSMutableArray*)getMessagesArrayFromClients; // Return an array will all messages with recibien "GarageSale"
{
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Message *messageToReview = [[Message alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayMessages.count; i=i+1)
    {
        messageToReview = [[Message alloc] init];
        messageToReview = (Message *)mainDelegate.sharedArrayMessages[i];
        
        // Add only the messages that have as recipient "GarageSale"
        if ([messageToReview.recipient isEqual:@"G"])
        {
            [messagesArray addObject:messageToReview];
        }
    }
    return messagesArray;
}

- (NSMutableArray*)getMessagesArrayFromClient:(NSString*)clientFromID; // Return an array with all messages from a client
{
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Message *messageToReview = [[Message alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayMessages.count; i=i+1)
    {
        messageToReview = [[Message alloc] init];
        messageToReview = (Message *)mainDelegate.sharedArrayMessages[i];
        
        if ([messageToReview.client_id isEqual:clientFromID])
        {
            [messagesArray addObject:messageToReview];
        }
    }
    return messagesArray;
}

/*
- (NSMutableArray*)getMessagesArrayFromClient:(NSString*)clientFromID withoutMessage:(NSString*)messageToNotConsider; // Return an array with all messages from a client
{
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Message *messageToReview = [[Message alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayMessages.count; i=i+1)
    {
        messageToReview = [[Message alloc] init];
        messageToReview = (Message *)mainDelegate.sharedArrayMessages[i];
        
        if ([messageToReview.client_id isEqual:clientFromID] && ![messageToReview.fb_msg_id isEqualToString:messageToNotConsider])
        {
            [messagesArray addObject:messageToReview];
        }
    }    
    return messagesArray;
}
*/

- (Message*)getLastMessageFromClient:(NSString*)clientFromID; // Return the last message for a specific client
{
    Message *lastMessage;

    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Message *messageToReview = [[Message alloc] init];
    int indexLastMessage = 0;
    
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
    NSDate *lastMessageDate = [formatFBdates dateFromString:@"2000-01-01T10:00:00+0000"];
    
    for (int i=0; i<mainDelegate.sharedArrayMessages.count; i=i+1)
    {
        messageToReview = [[Message alloc] init];
        messageToReview = (Message *)mainDelegate.sharedArrayMessages[i];
        
        if ([messageToReview.client_id isEqual:clientFromID])
        {
            if (lastMessageDate < messageToReview.datetime) {
                lastMessageDate = messageToReview.datetime;
                indexLastMessage = i;
            }
        }
    }

    if (indexLastMessage == 0) {
        lastMessage = nil;
    }
    else
    {
        lastMessage = (Message *)mainDelegate.sharedArrayMessages[indexLastMessage];
    }
    
    return lastMessage;
}

- (BOOL)addNewMessage:(Message*)newMessage;
{
    BOOL updateSuccessful = YES;
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [mainDelegate.sharedArrayMessages addObject:newMessage];
    
    return updateSuccessful;
}

- (BOOL)existMessage:(NSString*)messageIDToValidate; // Review an array of Messages to check if a given Message ID exists
{
    BOOL exists = NO;
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    Message *messageToReview = [[Message alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayMessages.count; i=i+1)
    {
        messageToReview = [[Message alloc] init];
        messageToReview = (Message *)mainDelegate.sharedArrayMessages[i];
        
        if ([messageToReview.fb_msg_id isEqual:messageIDToValidate])
        {
            exists = YES;
            break;
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

- (int)numberOfMessagesNotReplied; // Method that returns the total number of messages not replied yet
{
    int numberOfMessages = 0;
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Message *messageToReview = [[Message alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayMessages.count; i=i+1)
    {
        messageToReview = [[Message alloc] init];
        messageToReview = (Message *)mainDelegate.sharedArrayMessages[i];
        
        if ([messageToReview.status isEqualToString:@"R"])
        {
                // Do not need to count
        }
        else
        {
            numberOfMessages = numberOfMessages + 1;
        }
    }
    
    return numberOfMessages;

}

- (void)updateMessage:(Message*)messageToUpdate; // Update a message
{
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Message *messageToReview = [[Message alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayMessages.count; i=i+1)
    {
        messageToReview = [[Message alloc] init];
        messageToReview = (Message *)mainDelegate.sharedArrayMessages[i];
        
        if ([messageToReview.fb_msg_id isEqual:messageToUpdate.fb_msg_id])
        {
            [mainDelegate.sharedArrayMessages replaceObjectAtIndex:i withObject:messageToUpdate];
            break;
        }
    }
    
}


@end
