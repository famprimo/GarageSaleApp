//
//  FacebookMethods.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 15/08/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "FacebookMethods.h"
#import "SettingsModel.h"
#import "Settings.h"
#import "MessageModel.h"
#import "Message.h"
#import "ClientModel.h"
#import "Client.h"
#import "ProductModel.h"
#import "Product.h"
#import "AttachmentModel.h"
#import "Attachment.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface FacebookMethods ()
{
    // Data for temp objects
    NSMutableArray *_newClientsArray;
    
    Settings *_tmpSettings;
    
    NSDate *_messagesSinceDate;
}

@end

@implementation FacebookMethods

- (void)initializeMethods;
{
    // Review if Settings needs to be initialized
    
    if (_tmpSettings == nil)
    {
        [self setFBPageID];
        
        _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
    }
    
    // Clean new clients array
    _newClientsArray = [[NSMutableArray alloc] init];
}

- (void)setFBPageID;
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSString *url = @"me?fields=id,name,accounts";
        
        // Prepare for FB request
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error) {  // FB request was a success!
                 
                 NSString *userID = result[@"id"];
                 NSString *userName = result[@"name"];
                 NSString *pageID = result[@"accounts"][@"data"][0][@"id"];
                 NSString *pageName = result[@"accounts"][@"data"][0][@"name"];
                 NSString *pageToken = result[@"accounts"][@"data"][0][@"access_token"];
                 
                 if (![[[SettingsModel alloc] init] updateSettingsUser:userName withUserID:userID andPageID:pageID andPageName:pageName andPageTokenID:pageToken]) {
                     NSLog(@"Error updating settings");
                 }
             }
         }];
    }
}


#pragma mark methods for getting FB page notifications

- (void)getFBPageNotifications:(NSDate*)sinceDate;
{
    _messagesSinceDate = sinceDate;

    if ((_tmpSettings!= nil) && ![_tmpSettings.fb_page_id isEqualToString:@""])
    {
        NSString *url = [NSString stringWithFormat:@"%@/notifications?fields=application,link,object&include_read=true&since=%ld", _tmpSettings.fb_page_id, (long)[_messagesSinceDate timeIntervalSince1970]];;
        
        [self makeFBRequestForPageNotifications:url];
    }
    else
    {
        [self setFBPageID];
        
        _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
        
        [self.delegate finishedGettingFBpageNotifications:NO];
    }
}

- (void)makeFBRequestForPageNotifications:(NSString*)url;
{
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"manage_pages"])
    {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil tokenString:_tmpSettings.fb_page_token version:@"v2.0" HTTPMethod:@"GET"];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error) {  // FB request was a success!

                 if (result[@"data"]) {   // There is FB data!

                     NSArray *jsonArray = result[@"data"];
                     NSMutableArray *photosArray = [[NSMutableArray alloc] init];
                     
                     // Get photo IDs of all notifications
                     for (int i=0; i<jsonArray.count; i=i+1)
                     {
                         NSDictionary *newMessage = jsonArray[i];
                         
                         if ([newMessage[@"application"][@"name"] isEqual: @"Photos"]) {
                             
                             NSString *photoIDfromLink = [self getPhotoID:newMessage[@"link"]]; // Optional: take from [@"object"][@"id"]
                             
                             // Review if photo ID already exists
                             BOOL photoExists = NO;
                             
                             for (int j=0; j<photosArray.count; j=j+1)
                             {
                                 if ([photoIDfromLink isEqualToString:photosArray[j]])
                                 {
                                     photoExists = YES;
                                 }
                             }
                             // Add photo ID to array
                             if (!photoExists) {
                                 [photosArray addObject:photoIDfromLink];
                             }
                         }
                     }

                     if (photosArray.count >0)
                     {
                         // Get message details for the new notifications
                         [self makeFBRequestForPhotosDetails:photosArray];
                     }
                     
                     // Review is there is a next page
                     NSString *next = result[@"paging"][@"next"];
                     if (next)
                     {
                         [self makeFBRequestForPageNotifications:[next substringFromIndex:32]];
                     }
                 }
              }
             else
             {
                 // An error occurred, we need to handle the error
                 // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                 NSLog(@"error getFBNotifications: %@", error.description);
                 [self.delegate finishedGettingFBpageNotifications:NO];
             }
         }];
    }
}

- (void)makeFBRequestForPhotosDetails:(NSMutableArray*)photosArray;
{
    MessageModel *messageMethods = [[MessageModel alloc] init];
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    if (_newClientsArray == nil)
    {
        _newClientsArray = [[NSMutableArray alloc] init];
    }
    
    // Create string for FB request
    NSMutableString *requestPhotosList = [[NSMutableString alloc] init];
    [requestPhotosList appendString:@"?ids="];
    
    for (int i=0; i<photosArray.count; i=i+1)
    {
        if (i>0) { [requestPhotosList appendString:@","]; }
        [requestPhotosList appendString:photosArray[i]];
    }
    
    // Make FB request
    if ([FBSDKAccessToken currentAccessToken])
    {
        // Prepare for FB request
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:requestPhotosList parameters:nil];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error) { // FB request was a success!
                 
                 // Get details and create array
                 for (int i=0; i<photosArray.count; i=i+1)
                 {
                     // Review each photo
                     NSString *photoID = result[photosArray[i]][@"id"];
                     
                     // Review if product exists
                     NSString *productID = [productMethods getProductIDfromFbPhotoId:photoID];
                     
                     if ([productID  isEqual: @"Not Found"] && !(result[photosArray[i]][@"name"] == nil) && ![[productMethods getTextThatFollows:@"GS" fromMessage:result[photosArray[i]][@"name"]] isEqualToString:@"Not Found"])
                     {
                         // New product!
                         productID = [productMethods getNextProductID];
                         
                         Product *newProduct = [[Product alloc] init];
                         
                         newProduct.product_id = productID;
                         newProduct.client_id = @"";
                         newProduct.desc = result[photosArray[i]][@"name"];
                         newProduct.fb_photo_id = photoID;
                         newProduct.fb_link = result[photosArray[i]][@"link"];
                         
                         // Get name, currency, price, GS code and type from photo description
                         
                         newProduct.name = [productMethods getProductNameFromFBPhotoDesc:newProduct.desc];
                         
                         NSString *tmpText;
                         
                         tmpText = [productMethods getTextThatFollows:@"GSN" fromMessage:newProduct.desc];
                         if (![tmpText isEqualToString:@"Not Found"])
                         {
                             newProduct.codeGS = [NSString stringWithFormat:@"GSN%@", tmpText];
                             newProduct.type = @"A";
                         }
                         else
                         {
                             tmpText = [productMethods getTextThatFollows:@"GS" fromMessage:newProduct.desc];
                             if (![tmpText isEqualToString:@"Not Found"])
                             {
                                 newProduct.codeGS = [NSString stringWithFormat:@"GS%@", tmpText];
                                 newProduct.type = @"S";
                             }
                             else
                             {
                                 newProduct.codeGS = @"None";
                                 newProduct.type = @"A";
                             }
                         }
                         
                         tmpText = [productMethods getTextThatFollows:@"s/. " fromMessage:newProduct.desc];
                         if (![tmpText isEqualToString:@"Not Found"]) {
                             tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
                             newProduct.currency = @"S/.";
                             newProduct.price = [NSNumber numberWithFloat:[tmpText integerValue]];
                         }
                         else
                         {
                             tmpText = [productMethods getTextThatFollows:@"USD " fromMessage:newProduct.desc];
                             if (![tmpText isEqualToString:@"Not Found"]) {
                                 tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
                                 newProduct.currency = @"USD";
                                 newProduct.price = [NSNumber numberWithFloat:[tmpText integerValue]];
                             }
                             else {
                                 newProduct.currency = @"S/.";
                                 newProduct.price = 0;
                             }
                         }
                         
                         NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
                         [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
                         newProduct.created_time = [formatFBdates dateFromString:result[photosArray[i]][@"created_time"]];
                         newProduct.updated_time = [formatFBdates dateFromString:result[photosArray[i]][@"updated_time"]];
                         newProduct.fb_updated_time = [formatFBdates dateFromString:result[photosArray[i]][@"updated_time"]];
                         newProduct.solddisabled_time = [formatFBdates dateFromString:@"2000-01-01T01:01:01+0000"];
                         
                         newProduct.picture_link = result[photosArray[i]][@"picture"];
                         newProduct.additional_pictures = @"";
                         newProduct.status = @"N";
                         newProduct.promotion_piority = @"2";
                         newProduct.notes = @"";
                         newProduct.agent_id = @"00001";
                         
                         [productMethods addNewProduct:newProduct];
                     }
                     
                     // Review each comment
                     NSArray *jsonArray = result[photosArray[i]][@"comments"][@"data"];
                     NSMutableArray *commentsIDArray = [[NSMutableArray alloc] init];
                     Message *tempMessage;
                     Client *tempClient;
                     
                     for (int j=0; j<jsonArray.count; j=j+1)
                     {
                         NSDictionary *newMessage = jsonArray[j];
                         [commentsIDArray addObject:newMessage[@"id"]];
                         
                         // Validate if the comment/message exists
                         if (![messageMethods existMessage:newMessage[@"id"]])
                         {
                             // New message!
                             tempMessage = [[Message alloc] init];
                             
                             tempMessage.fb_msg_id = newMessage[@"id"];
                             tempMessage.fb_from_id = newMessage[@"from"][@"id"];
                             tempMessage.fb_from_name = newMessage[@"from"][@"name"];
                             tempMessage.parent_fb_msg_id = nil;
                             tempMessage.message = newMessage[@"message"];
                             
                             tempMessage.fb_created_time = newMessage[@"created_time"];
                             NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
                             [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
                             tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time];
                             
                             tempMessage.fb_photo_id = photoID;
                             tempMessage.product_id = productID;
                             tempMessage.attachments = @"N";
                             tempMessage.agent_id = @"00001";
                             tempMessage.type = @"P";
                             
                             NSLog(@"%@ : %@", tempMessage.fb_from_name, [FBSDKProfile currentProfile].name);
                             
                             if ([tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_user_id] || [tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_page_id])
                             {
                                 // Is a message from GarageSale!
                                 tempMessage.recipient = @"C";
                                 tempMessage.status = @"D";
                             }
                             else
                             {
                                 tempMessage.recipient = @"G";
                                 tempMessage.status = @"N";
                             }
                             
                             // Review if client exists
                             NSString *fromClientID = [self getClientIDfromFbId:tempMessage.fb_from_id];
                             
                             if ([fromClientID  isEqual: @"Not Found"])
                             {
                                 // New client!
                                 tempMessage.client_id = [self getNextClientID];;
                                 
                                 Client *newClient = [[Client alloc] init];
                                 
                                 newClient.client_id = tempMessage.client_id;
                                 newClient.fb_client_id = tempMessage.fb_from_id;
                                 newClient.fb_inbox_id = @"";
                                 newClient.fb_page_message_id = @"";
                                 newClient.type = @"F";
                                 newClient.name = tempMessage.fb_from_name; // TEMPORAL
                                 newClient.preference = @"F";
                                 newClient.status = @"N";
                                 newClient.created_time = [NSDate date];
                                 newClient.last_interacted_time = tempMessage.datetime;
                                 
                                 [_newClientsArray addObject:newClient];
                             }
                             else
                             {
                                 // The client already exists
                                 tempClient = [self getClientFromClientId:fromClientID];

                                 tempMessage.client_id = tempClient.client_id;
                                 tempMessage.fb_inbox_id = tempClient.fb_inbox_id;
                                 
                                 if (tempMessage.datetime > tempClient.last_interacted_time)
                                 {
                                     tempClient.last_interacted_time = tempMessage.datetime;
                                     [self updateClient:tempClient];
                                 }
                             }
                             
                             // Add new message and inform delegate
                             [messageMethods addNewMessage:tempMessage];
                             
                             [self.delegate newMessageAddedFromFB:tempMessage];
                         }
                     }
                     
                     // Call method for getting sub comments
                     [self makeFBRequestForSubComments:commentsIDArray];
                 }
                 
                 [self.delegate finishedGettingFBpageNotifications:YES];
             }
             else {
                 // An error occurred, we need to handle the error
                 // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                 NSLog(@"error makeFBRequestForPhotosDetails: %@", error.description);
                 
                 [self.delegate finishedGettingFBpageNotifications:NO];
             }
         }];
    }
}

- (void)makeFBRequestForSubComments:(NSMutableArray*)commentsIDArray;
{
    NSMutableString *requestCommentsDetails = [[NSMutableString alloc] init];
    
    // Request detail information for each picture
    
    for (int i=0; i<commentsIDArray.count; i=i+1)
    {
        requestCommentsDetails = [[NSMutableString alloc] init];
        
        [requestCommentsDetails appendString:commentsIDArray[i]];
        [requestCommentsDetails appendString:@"?fields=id,from,created_time,comments"];
        [requestCommentsDetails appendString:[NSString stringWithFormat:@"&since=%ld", (long)[_messagesSinceDate timeIntervalSince1970]]];
        
        [self getFBPhotoSubComments:requestCommentsDetails];
    }
}

- (void)getFBPhotoSubComments:(NSString*)url;
{
    // Make FB request
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) { // FB request was a success!
             
             [self parseFBPhotoSubComments:result];
             
             NSString *next = result[@"paging"][@"next"];
             if (next)
             {
                 [self getFBPhotoSubComments:[next substringFromIndex:32]];
             }
         }
         else {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error getFBPhotoComments: %@", error.description);
         }
     }];
}

- (void)parseFBPhotoSubComments:(id)result;
{
    MessageModel *messageMethods = [[MessageModel alloc] init];
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    // Get client ID to use
    NSString *tmpFbFromId = result[@"from"][@"id"];
    NSString *fromClientID = [self getClientIDfromFbId:tmpFbFromId];
    
    // Obtaining photoID from message ID
    NSString *tmpMessageID = result[@"id"];
    NSRange match = [tmpMessageID rangeOfString:@"_"];
    NSString *photoID = [tmpMessageID substringToIndex:match.location];
    
    // Review if product exists
    NSString *productID = [productMethods getProductIDfromFbPhotoId:photoID];
    
    // Review each comment
    NSArray *jsonArray = result[@"comments"][@"data"];
    
    for (int j=0; j<jsonArray.count; j=j+1)
    {
        NSDictionary *newMessage = jsonArray[j];
        
        // Validate if the comment/message exists
        if (![messageMethods existMessage:newMessage[@"id"]])
        {
            // New message!
            Message *tempMessage = [[Message alloc] init];
            
            tempMessage.fb_msg_id = newMessage[@"id"];
            tempMessage.fb_from_id = newMessage[@"from"][@"id"];
            tempMessage.fb_from_name = newMessage[@"from"][@"name"];
            tempMessage.parent_fb_msg_id = tmpMessageID;
            tempMessage.message = newMessage[@"message"];
            
            tempMessage.fb_created_time = newMessage[@"created_time"];
            NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
            [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
            tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time];
            
            tempMessage.fb_photo_id = photoID;
            tempMessage.product_id = productID;
            tempMessage.attachments = @"N";
            tempMessage.agent_id = @"00001";
            tempMessage.type = @"P";
            
            NSLog(@"%@ : %@", tempMessage.fb_from_name, [FBSDKProfile currentProfile].name);
            
            if ([tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_user_id] || [tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_page_id])
            {
                // Is a message from GarageSale
                tempMessage.recipient = @"C";
                tempMessage.client_id = fromClientID;
                tempMessage.fb_inbox_id = fromClientID;
                tempMessage.status = @"D";
            }
            else
            {
                tempMessage.recipient = @"G";
                tempMessage.status = @"N";
                
                // Review if client exists
                fromClientID = [self getClientIDfromFbId:tempMessage.fb_from_id];
                
                if ([fromClientID  isEqual: @"Not Found"])
                {
                    // New client!
                    tempMessage.client_id = [self getNextClientID];;
                    
                    Client *newClient = [[Client alloc] init];
                    
                    newClient.client_id = tempMessage.client_id;
                    newClient.fb_client_id = tempMessage.fb_from_id;
                    newClient.fb_inbox_id = @"";
                    newClient.fb_page_message_id = @"";
                    newClient.type = @"F";
                    newClient.name = tempMessage.fb_from_name; // TEMPORAL
                    newClient.preference = @"F";
                    newClient.status = @"N";
                    newClient.created_time = [NSDate date];
                    newClient.last_interacted_time = tempMessage.datetime;
                    
                    [_newClientsArray addObject:newClient];
                }
                else
                {
                    // The client already exists
                    Client *tempClient = [self getClientFromClientId:fromClientID];
                    
                    tempMessage.client_id = tempClient.client_id;
                    tempMessage.fb_inbox_id = tempClient.fb_inbox_id;
                    
                    if (tempMessage.datetime > tempClient.last_interacted_time)
                    {
                        tempClient.last_interacted_time = tempMessage.datetime;
                        [self updateClient:tempClient];
                    }
                }
            }
            
            // Insert new message to array and inform delegate
            [messageMethods addNewMessage:tempMessage];
            
            [self.delegate newMessageAddedFromFB:tempMessage];
        }
    }
    
    [self.delegate finishedGettingFBpageNotifications:YES];
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


#pragma mark methods for getting FB inbox

- (void)getFBInbox:(NSDate*)sinceDate;
{
    _messagesSinceDate = sinceDate;
    
    if ((_tmpSettings!= nil) && ![_tmpSettings.fb_page_id isEqualToString:@""])
    {
        NSString *url = [NSString stringWithFormat:@"me/inbox?fields=id,to,updated_time,comments&limit=50&since=%ld", (long)[_messagesSinceDate timeIntervalSince1970]];
        
        [self makeFBRequestForNewInbox:url];
    }
    else
    {
        [self setFBPageID];
        
        _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
        
        [self.delegate finishedGettingFBInbox:NO];
    }
}

- (void)makeFBRequestForNewInbox:(NSString*)url;
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {  // FB request was a success!
             
             if (result[@"data"]) {   // There is FB data!
                 
                 [self parseFBInbox:result];
                 
                 NSString *next = result[@"paging"][@"next"];
                 if (next)
                 {
                     [self makeFBRequestForNewInbox:[next substringFromIndex:32]];
                 }
             }
         }
         else
         {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error getFBInbox: %@", error.description);
             [self.delegate finishedGettingFBInbox:NO];
         }
     }];
}

- (void)parseFBInbox:(id)result;
{
    Client *tmpClient;
    
    if (_newClientsArray == nil)
    {
        _newClientsArray = [[NSMutableArray alloc] init];
    }
    
    NSString *fbIDfromInbox;
    NSString *fbNamefromInbox;
    NSString *fbInboxID;
    
    // Review each chat
    
    NSArray *jsonArray = result[@"data"];
    
    for (int i=0; i<jsonArray.count; i=i+1)
    {
        fbInboxID = jsonArray[i][@"id"];
        fbNamefromInbox = jsonArray[i][@"to"][@"data"][1][@"name"];
        fbIDfromInbox = jsonArray[i][@"to"][@"data"][1][@"id"];
        
        NSLog(@"%@ : %@", fbNamefromInbox, [FBSDKProfile currentProfile].name);
        
        // Make sure it takes the ID and name of the client, not of GarageSale
        if ([fbIDfromInbox isEqualToString:_tmpSettings.fb_user_id] || [fbIDfromInbox isEqualToString:_tmpSettings.fb_page_id])
        {
            fbNamefromInbox = jsonArray[i][@"to"][@"data"][0][@"name"];
            fbIDfromInbox = jsonArray[i][@"to"][@"data"][0][@"id"];
        }
        
        // Review if client exists
        NSString *fromClientID = [self getClientIDfromFbId:fbIDfromInbox];
        
        if ([fromClientID  isEqual: @"Not Found"])
        {
            // New client!
            
            Client *newClient = [[Client alloc] init];
            
            fromClientID = [self getNextClientID];
            newClient.client_id = fromClientID;
            newClient.fb_client_id = fbIDfromInbox;
            newClient.fb_inbox_id = fbInboxID;
            newClient.fb_page_message_id =  @"";
            newClient.type = @"F";
            newClient.name = fbNamefromInbox; // TEMPORAL
            newClient.preference = @"F";
            newClient.status = @"N";
            newClient.created_time = [NSDate date];
            
            NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
            [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
            newClient.last_interacted_time = [formatFBdates dateFromString:jsonArray[i][@"updated_time"]];;
            
            [_newClientsArray addObject:newClient];
        }
        
        // Review if inboxID is updated
        tmpClient = [[Client alloc] init];
        tmpClient = [self getClientFromClientId:fromClientID];
        
        if (![tmpClient.fb_inbox_id isEqualToString:fbInboxID])
        {
            // InboxID is differente... update with the actual
            tmpClient.fb_inbox_id = fbInboxID;
            [self updateClient:tmpClient];
        }
        
        NSArray *jsonMessagesArray = jsonArray[i][@"comments"][@"data"];
        
        [self parseFBInboxComments:jsonMessagesArray withClientID:fromClientID];
        
        /*
         // Review if there are more comments from this chat
         
         NSString *next = jsonArray[i][@"comments"][@"paging"][@"next"];
         
         if (next && jsonMessagesArray.count>=25)
         {
         [self getFBInboxComments:[next substringFromIndex:32] withClientID:fromClientID];
         }
         */
    }
}

- (void)getFBInboxComments:(NSString *)url withClientID:(NSString *)fromClientID;
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {  // FB request was a success!
             
             if (result[@"data"]) {   // There is FB data!
                 
                 NSArray *jsonMessagesArray = result[@"data"];
                 
                 [self parseFBInboxComments:jsonMessagesArray withClientID:fromClientID];
                 
                 // Review if there are more comments from this chat
                 
                 // EVALUAR SI TODOS LOS MENSAJES YA ESTAN REGISTRADOS PARA NO SEGUIR...!!!!
                 
                 NSString *next = result[@"paging"][@"next"];
                 
                 if (next && jsonMessagesArray.count>=25)
                 {
                     [self getFBInboxComments:[next substringFromIndex:32] withClientID:fromClientID];
                 }
             }
             
         } else {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error getFBInboxComments: %@", error.description);
         }
     }];
}

- (void)parseFBInboxComments:(NSArray *)jsonMessagesArray withClientID:(NSString *)fromClientID;
{
    MessageModel *messageMethods = [[MessageModel alloc] init];
    
    Client *tmpClient = [self getClientFromClientId:fromClientID];
    NSString *fbInboxID = tmpClient.fb_inbox_id;
    NSString *fbIDfromInbox = tmpClient.fb_client_id;
    NSString *fbNamefromInbox = [NSString stringWithFormat:@"%@ %@", tmpClient.name, tmpClient.last_name];
    
    // Add all messages from this conversation
    
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000

    NSDate *lastMessageDate = [formatFBdates dateFromString:@"2000-01-01T01:01:01+0000"];
    
    for (int i=0; i<jsonMessagesArray.count; i=i+1)
    {
        NSDictionary *newMessage = jsonMessagesArray[i];
        
        // Validate if the comment/message exists
        if (![messageMethods existMessage:newMessage[@"id"]])
        {
            // New message!
            Message *tempMessage = [[Message alloc] init];
            
            tempMessage.fb_inbox_id = fbInboxID;
            tempMessage.fb_msg_id = newMessage[@"id"];
            tempMessage.fb_from_id = newMessage[@"from"][@"id"];
            tempMessage.fb_from_name = newMessage[@"from"][@"name"];
            tempMessage.client_id = fromClientID;
            tempMessage.parent_fb_msg_id = nil;
            tempMessage.message = newMessage[@"message"];
            tempMessage.fb_created_time = newMessage[@"created_time"];
            tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time];
            tempMessage.fb_photo_id = nil;
            tempMessage.product_id = nil;
            tempMessage.attachments = @"N";
            tempMessage.agent_id = @"00001";
            tempMessage.status = @"N";
            tempMessage.type = @"I";
            
            NSLog(@"%@ : %@", tempMessage.fb_from_name, [FBSDKProfile currentProfile].name);
            
            if ([tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_user_id] || [tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_page_id])
            {
                // Message from GarageSale
                tempMessage.recipient = @"C";
                tempMessage.fb_from_id = fbIDfromInbox;
                tempMessage.fb_from_name = fbNamefromInbox;
            }
            else
            { tempMessage.recipient = @"G";}
            
            tempMessage.client_id = fromClientID;
            
            // Save last date
            if (tempMessage.datetime > lastMessageDate)
            {
                lastMessageDate = tempMessage.datetime;
            }
            
            // Add new message and inform delegate
            [messageMethods addNewMessage:tempMessage];
            
            [self.delegate newMessageAddedFromFB:tempMessage];
        }
    }
    
    // Review if last message date is newer than last interacted date
    if (lastMessageDate > tmpClient.last_interacted_time)
    {
        tmpClient.last_interacted_time = lastMessageDate;
        [self updateClient:tmpClient];
    }
}


#pragma mark methods for getting FB page messages

- (void)getFBPageMessages:(NSDate*)sinceDate;
{
    _messagesSinceDate = sinceDate;
    
    if ((_tmpSettings!= nil) && ![_tmpSettings.fb_page_id isEqualToString:@""])
    {
        NSString *url = [NSString stringWithFormat:@"%@/conversations?fields=id,participants,updated_time,messages&since=%ld", _tmpSettings.fb_page_id, (long)[_messagesSinceDate timeIntervalSince1970]];;
        
        [self makeFBRequestForPageMessages:url];
    }
    else
    {
        [self setFBPageID];
        
        _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
        
        [self.delegate finishedGettingFBPageMessages:NO];
    }
}

- (void)makeFBRequestForPageMessages:(NSString*)url;
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"manage_pages"])
    {
        // Prepare for FB request
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil tokenString:_tmpSettings.fb_page_token version:@"v2.0" HTTPMethod:@"GET"];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error) {  // FB request was a success!
                 
                 if (result[@"data"]) {   // There is FB data!
                     
                     [self parseFBPageMessages:result];
                     
                     NSString *next = result[@"paging"][@"next"];
                     if (next)
                     {
                         [self makeFBRequestForPageMessages:[next substringFromIndex:32]];
                     }
                 }
                 
             } else {
                 // An error occurred, we need to handle the error
                 // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                 NSLog(@"error getFBPageMessages: %@", error.description);
                 [self.delegate finishedGettingFBPageMessages:NO];
             }
         }];
    }
}

- (void)parseFBPageMessages:(id)result;
{
    Client *tmpClient;
    
    if (_newClientsArray == nil)
    {
        _newClientsArray = [[NSMutableArray alloc] init];
    }
    
    NSString *fbIDfromInbox;
    NSString *fbNamefromInbox;
    NSString *fbPageMessageID;
    
    // Review each chat
    
    NSArray *jsonArray = result[@"data"];
    
    
    for (int i=0; i<jsonArray.count; i=i+1)
    {
        fbPageMessageID = jsonArray[i][@"id"];
        fbNamefromInbox = jsonArray[i][@"participants"][@"data"][0][@"name"];
        fbIDfromInbox = jsonArray[i][@"participants"][@"data"][0][@"id"];
        
        // Make sure it takes the ID and name of the client, not of GarageSale
        if ([fbIDfromInbox isEqualToString:_tmpSettings.fb_user_id] || [fbIDfromInbox isEqualToString:_tmpSettings.fb_page_id])
        {
            fbNamefromInbox = jsonArray[i][@"participants"][@"data"][1][@"name"];
            fbIDfromInbox = jsonArray[i][@"participants"][@"data"][1][@"id"];
        }
        
        NSLog(@"%@ : %@", fbNamefromInbox, [FBSDKProfile currentProfile].name);
        
        // Review if client exists
        NSString *fromClientID = [self getClientIDfromFbId:fbIDfromInbox];
        
        if ([fromClientID  isEqual: @"Not Found"])
        {
            // New client!
            
            Client *newClient = [[Client alloc] init];
            
            fromClientID = [self getNextClientID];
            newClient.client_id = fromClientID;
            newClient.fb_client_id = fbIDfromInbox;
            newClient.fb_inbox_id = @"";
            newClient.fb_page_message_id = fbPageMessageID;
            newClient.type = @"F";
            newClient.name = fbNamefromInbox; // TEMPORAL
            newClient.preference = @"F";
            newClient.status = @"N";
            newClient.created_time = [NSDate date];
            
            NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
            [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
            newClient.last_interacted_time = [formatFBdates dateFromString:jsonArray[i][@"updated_time"]];;
            
            [_newClientsArray addObject:newClient];
        }
        
        // Review if pageMessageID is updated
        tmpClient = [[Client alloc] init];
        tmpClient = [self getClientFromClientId:fromClientID];
        
        if (![tmpClient.fb_page_message_id isEqualToString:fbPageMessageID])
        {
            // InboxID is different... update with the actual
            tmpClient.fb_page_message_id = fbPageMessageID;
            [self updateClient:tmpClient];
        }
        
        NSArray *jsonMessagesArray = jsonArray[i][@"messages"][@"data"];
        
        [self parseFBPageMessagesComments:jsonMessagesArray withClientID:fromClientID];
        
        /*
         // Review if there are more comments from this chat
         
         NSString *next = jsonArray[i][@"messages"][@"paging"][@"next"];
         
         if (next && jsonMessagesArray.count>=25)
         {
         [self getFBPageMessagesComments:[next substringFromIndex:32] withClientID:fromClientID];
         }
         */
    }
}

- (void) getFBPageMessagesComments:(NSString *)url withClientID:(NSString *)fromClientID;
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil tokenString:_tmpSettings.fb_page_token version:@"v2.0" HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {  // FB request was a success!
             
             if (result[@"data"]) {   // There is FB data!
                 
                 NSArray *jsonMessagesArray = result[@"data"];
                 
                 [self parseFBPageMessagesComments:jsonMessagesArray withClientID:fromClientID];
                 
                 // Review if there are more comments from this chat
                 
                 // EVALUAR SI TODOS LOS MENSAJES YA ESTAN REGISTRADOS PARA NO SEGUIR...!!!!
                 
                 NSString *next = result[@"paging"][@"next"];
                 
                 if (next && jsonMessagesArray.count>=25)
                 {
                     [self getFBPageMessagesComments:[next substringFromIndex:32] withClientID:fromClientID];
                 }
             }
             
         } else {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error getFBPageMessagesComments: %@", error.description);
         }
     }];
}

- (void) parseFBPageMessagesComments:(NSArray *)jsonMessagesArray withClientID:(NSString *)fromClientID;
{
    MessageModel *messageMethods = [[MessageModel alloc] init];
    
    Client *tmpClient = [self getClientFromClientId:fromClientID];
    NSString *fbInboxID = tmpClient.fb_inbox_id;
    NSString *fbIDfromInbox = tmpClient.fb_client_id;
    NSString *fbNamefromInbox = [NSString stringWithFormat:@"%@ %@", tmpClient.name, tmpClient.last_name];
    
    // Add all messages from this conversation
    
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
    
    NSDate *lastMessageDate = [formatFBdates dateFromString:@"2000-01-01T01:01:01+0000"];
    
    for (int i=0; i<jsonMessagesArray.count; i=i+1)
    {
        NSDictionary *newMessage = jsonMessagesArray[i];
        
        // Validate if the comment/message exists
        if (![messageMethods existMessage:newMessage[@"id"]])
        {
            // New message!
            Message *tempMessage = [[Message alloc] init];
            
            tempMessage.fb_inbox_id = fbInboxID;
            tempMessage.fb_msg_id = newMessage[@"id"];
            tempMessage.fb_from_id = newMessage[@"from"][@"id"];
            tempMessage.fb_from_name = newMessage[@"from"][@"name"];
            tempMessage.client_id = fromClientID;
            tempMessage.parent_fb_msg_id = nil;
            tempMessage.message = newMessage[@"message"];
            tempMessage.fb_created_time = newMessage[@"created_time"];
            tempMessage.datetime = [formatFBdates dateFromString:tempMessage.fb_created_time];
            tempMessage.fb_photo_id = nil;
            tempMessage.product_id = nil;
            
            // Review if there are attachments
            if (newMessage[@"attachments"])
            { tempMessage.attachments = @"Y"; }
            else { tempMessage.attachments = @"N"; }
            
            tempMessage.agent_id = @"00001";
            tempMessage.status = @"N";
            tempMessage.type = @"M"; // Page message!
            
            NSLog(@"%@ : %@", tempMessage.fb_from_name, [FBSDKProfile currentProfile].name);
            
            if ([tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_user_id] || [tempMessage.fb_from_id isEqualToString:_tmpSettings.fb_page_id])
            {
                // Message from GarageSale
                tempMessage.recipient = @"C";
                tempMessage.fb_from_id = fbIDfromInbox;
                tempMessage.fb_from_name = fbNamefromInbox;
            }
            else
            { tempMessage.recipient = @"G";}
            
            tempMessage.client_id = fromClientID;
            
            // Save last date
            if (tempMessage.datetime > lastMessageDate)
            {
                lastMessageDate = tempMessage.datetime;
            }
            
            // Add new message and inform delegate
            [messageMethods addNewMessage:tempMessage];
            
            [self.delegate newMessageAddedFromFB:tempMessage];
            
            // If there are attachments, include them
            if ([tempMessage.attachments isEqualToString:@"Y"])
            {
                NSMutableArray *attachmentsArray = newMessage[@"attachments"][@"data"];
                [self parseFBMessageAttachments:attachmentsArray for:tempMessage];
            }
        }
    }
    
    // Review if last message date is newer than last interacted date
    if (lastMessageDate > tmpClient.last_interacted_time)
    {
        tmpClient.last_interacted_time = lastMessageDate;
        [self updateClient:tmpClient];
    }
}

- (void) parseFBMessageAttachments:(NSMutableArray*)attachmentsArray for:(Message*)containerMessage;
{
    AttachmentModel *attachmentMethods = [[AttachmentModel alloc] init];
    Attachment *tempAttachment = [[Attachment alloc] init];
    
    // Add all messages from this conversation
    
    for (int i=0; i<attachmentsArray.count; i=i+1)
    {
        NSDictionary *newAttachment = attachmentsArray[i];
        tempAttachment = [[Attachment alloc] init];
        
        tempAttachment.fb_msg_id = containerMessage.fb_msg_id;
        tempAttachment.fb_attachment_id = newAttachment[@"id"];
        tempAttachment.client_id = containerMessage.client_id;
        tempAttachment.datetime = containerMessage.datetime;
        tempAttachment.fb_name = newAttachment[@"name"];
        tempAttachment.picture_link = newAttachment[@"image_data"][@"url"];
        tempAttachment.preview_link = newAttachment[@"image_data"][@"preview_url"];
        tempAttachment.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempAttachment.picture_link]];
        tempAttachment.agent_id = @"00001";
        
        [attachmentMethods addNewAttachment:tempAttachment];
    }
}


#pragma mark methods related to clients

- (NSString*)getNextClientID;
{
    ClientModel *clientMethods = [[ClientModel alloc] init];
    Client *clientToReview = [[Client alloc] init];
    
    // Get next client ID from Database
    int lastID = [[clientMethods getNextClientID] intValue] - 1;
    
    // Review latest ID from new clients temp array
    for (int i=0; i<_newClientsArray.count; i=i+1)
    {
        clientToReview = [[Client alloc] init];
        clientToReview = (Client *)_newClientsArray[i];
        
        if ([clientToReview.client_id intValue] >= lastID)
        {
            lastID = [clientToReview.client_id intValue];
        }
    }
    
    NSString *nextID = [NSString stringWithFormat:@"00000000%d", lastID + 1];
    nextID = [nextID substringFromIndex:[nextID length] - 7];
    
    return nextID;
}

- (NSString*)getClientIDfromFbId:(NSString*)clientFbIdToValidate;
{
    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    // Look for client in Database
    NSString *clientID = [clientMethods getClientIDfromFbId:clientFbIdToValidate];
    
    if ([clientID isEqualToString:@"Not Found"])
    {
        // Not found in database, look in temp array
        Client *clientToReview = [[Client alloc] init];

        for (int i=0; i<_newClientsArray.count; i=i+1)
        {
            clientToReview = [[Client alloc] init];
            clientToReview = (Client *)_newClientsArray[i];
            
            if ([clientToReview.fb_client_id isEqual:clientFbIdToValidate])
            {
                clientID = clientToReview.client_id;
                break;
            }
        }
    }
    return clientID;
}

- (Client*)getClientFromClientId:(NSString*)clientIDtoSearch;
{
    ClientModel *clientMethods = [[ClientModel alloc] init];

    // Look for client in Database
    Client *clientFound = [clientMethods getClientFromClientId:clientIDtoSearch];
    
    if (clientFound.client_id == nil)
    {
        // Not found in database, look in temp array

        for (int i=0; i<_newClientsArray.count; i=i+1)
        {
            Client *clientToReview = (Client *)_newClientsArray[i];
            
            if ([clientToReview.client_id isEqual:clientIDtoSearch])
            {
                clientFound = clientToReview;
                break;
            }
        }
    }
    return clientFound;
}

- (void)updateClient:(Client*)clientToUpdate;
{
    // Look for client in temp array
    BOOL clientFound = NO;
    
    Client *clientToReview = [[Client alloc] init];
    
    for (int i=0; i<_newClientsArray.count; i=i+1)
    {
        clientToReview = [[Client alloc] init];
        clientToReview = (Client *)_newClientsArray[i];
        
        if ([clientToReview.client_id isEqual:clientToUpdate.client_id])
        {
            clientFound = YES;
            [_newClientsArray replaceObjectAtIndex:i withObject:clientToUpdate];
            break;
        }
    }

    if (clientFound == NO)
    {
        // Update object in database
        ClientModel *clientMethods = [[ClientModel alloc] init];
        [clientMethods updateClient:clientToUpdate];
    }
}

- (void)insertNewClientsFound;
{
    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    // Create string for FB request
    NSMutableString *requestClientDetails = [[NSMutableString alloc] init];
    Client *newClient = [[Client alloc] init];
    
    for (int i=0; i<_newClientsArray.count; i=i+1)
    {
        newClient = [[Client alloc] init];
        newClient = (Client *)_newClientsArray[i];
        
        requestClientDetails = [[NSMutableString alloc] init];
        [requestClientDetails appendString:newClient.fb_client_id];
        [requestClientDetails appendString:@"?fields=first_name,last_name,gender,picture"];
        
        NSLog(@"%@ - %@: %@", newClient.fb_client_id, newClient.name, requestClientDetails);
        
        // Make FB request
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:requestClientDetails parameters:nil];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error) { // FB request was a success!
                 
                 newClient.name = result[@"first_name"];
                 newClient.last_name = result[@"last_name"];
                 if ([result[@"gender"] isEqualToString:@"male"])
                 {
                     newClient.sex = @"M";
                 }
                 else
                 {
                     newClient.sex = @"F";
                 }
                 newClient.picture_link = result[@"picture"][@"data"][@"url"];
                 
                 [clientMethods addNewClient:newClient];
                 if (i == _newClientsArray.count-1)
                 {
                     // Last client to be updated
                     [self.delegate finishedInsertingNewClientsFound:YES];
                 }
             }
             else {
                 // An error occurred, we need to handle the error
                 // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                 NSLog(@"error makeFBRequestForClientsDetails: %@", error.description);
                 [self.delegate finishedInsertingNewClientsFound:NO];
             }
         }];
    }
}

@end
