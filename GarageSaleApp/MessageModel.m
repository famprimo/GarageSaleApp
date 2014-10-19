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

- (NSMutableArray*)getMessages:(NSMutableArray*)messageList;
{
    // Array to hold the listing data and formatter for FB dates
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
    tempMessage.product_id = @"00001";
    tempMessage.client_id = @"00006";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"N";
    tempMessage.type = @"I";
    tempMessage.datetime = [formatFBdates dateFromString:@"2014-06-20T16:41:15+0000"];
   
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
    tempMessage.client_id = @"00004";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"P";
    tempMessage.datetime = [formatFBdates dateFromString:@"2014-05-10T16:41:15+0000"];
    
    // Add message #2 to the array
    [messages addObject:tempMessage];
    
    // Return the producct array as the return value
    return messages;
}

- (BOOL)existMessage:(NSString*)messageIDToValidate;
{
    // Review an array of Messages to check if a given Message ID exists
    
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


- (NSString*)getPhotoID:(NSString*)facebookLink;
{
    // Search for 'fbid=' on a Facebook link to get photo_id
    
    NSString *photoID;
    
    NSRange searchForPhotoId = [facebookLink rangeOfString:@"fbid="];
    NSRange searchForDelimiter = [facebookLink rangeOfString:@"&"];
    
    int locationPhotoID = (int) searchForPhotoId.location + 5;
    int lengthPhotoID =  (int) searchForDelimiter.location - locationPhotoID;
    
    photoID = [facebookLink substringWithRange: NSMakeRange(locationPhotoID, lengthPhotoID)];
    
    return photoID;
}


- (NSString*)getCommentID:(NSString*)facebookLink;
{
    // Search for 'comment_id=' on a Facebook link to get _id
    
    NSString *commentID;

    NSRange searchForCommentId = [facebookLink rangeOfString:@"comment_id="];
    
    int locationCommentID = (int) searchForCommentId.location + 11;
    
    NSString *textForSearch = [facebookLink substringWithRange: NSMakeRange(locationCommentID, facebookLink.length - locationCommentID)];
    

    NSRange searchForDelimiter = [textForSearch rangeOfString:@"&"];
    int lengthCommentID =  (int) searchForDelimiter.location;

    commentID = [facebookLink substringWithRange: NSMakeRange(locationCommentID, lengthCommentID)];

    return commentID;
}


- (NSString*)getMessagesIDs:(NSMutableArray*)messagesArray;
{
    // Method that returns the IDs of all the Messages in the array sent
    
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

@end
