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
#import "ProductModel.h"
#import "AttachmentModel.h"
#import "Attachment.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface FacebookMethods ()
{
    // Data for temp objects
    NSMutableArray *_newClientsArray;
    NSMutableArray *_photosArray;
    NSMutableArray *_commentsIDArray;
    
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
    
    // Clean arrays
    _photosArray = [[NSMutableArray alloc] init];
    _newClientsArray = [[NSMutableArray alloc] init];
    _commentsIDArray = [[NSMutableArray alloc] init];
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


#pragma mark methods for getting FB photos

- (void)getFBPhotos;
{
    
    if ((_tmpSettings!= nil) && ![_tmpSettings.fb_page_id isEqualToString:@""])
    {
        NSString *url = [NSString stringWithFormat:@"%@/photos/uploaded?fields=created_time,id,link,updated_time,picture,name&limit=100", _tmpSettings.fb_page_id];;
        
        [self makeFBRequestForPhotos:url];
    }
    else
    {
        [self setFBPageID];
        
        _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
        
        [self.delegate finishedGettingFBPhotos:NO];
    }
}

- (void)makeFBRequestForPhotos:(NSString*)url;
{
    // Make FB request
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {  // FB request was a success!
             
             if (result[@"data"])
             {   // There is FB data!
                 [self parseFBResultsRequestForPhotos:result];
             }
             NSString *next = result[@"paging"][@"next"];
             if (next)
             {
                 [self makeFBRequestForPhotos:[next substringFromIndex:32]];
             }
             else
             {
                 // last page inbox processed!
                 [self.delegate finishedGettingFBPhotos:YES];
             }
         }
         else
         {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error makeFBRequestForPhotos: %@", error.description);
             [self.delegate finishedGettingFBPhotos:NO];
         }
     }];
}

- (void)parseFBResultsRequestForPhotos:(id)result
{
    ProductModel *productMethods = [[ProductModel alloc] init];

    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000

    NSArray *photosArray = result[@"data"];
    
    // Get details and create array
    for (int i=0; i<photosArray.count; i=i+1)
    {
        
        // Review each photo
        NSString *photoID = photosArray[i][@"id"];
        
        // Review if product exists
        NSString *productID = [productMethods getProductIDfromFbPhotoId:photoID];
        
        if ([productID  isEqual: @"Not Found"] && !(photosArray[i][@"name"] == nil) && ![[productMethods getTextThatFollows:@"GS" fromMessage:photosArray[i][@"name"]] isEqualToString:@"Not Found"])
        {
            // New product!
            Product *newProduct = [[Product alloc] init];

            productID = [productMethods getNextProductID];
            newProduct = [self parseFBPhotoName:photosArray[i]];
            
            newProduct.product_id = productID;
            
            
            // Add new product to DB
            [productMethods addNewProduct:newProduct];
        }
        else
        {
            // Existing product. Review if there were changes
            
            Product *existingProduct = [[Product alloc] init];
            existingProduct = [productMethods getProductFromProductId:productID];
            
            NSDate *photoUpdatedTime = [formatFBdates dateFromString:photosArray[i][@"updated_time"]];

            if (photoUpdatedTime != existingProduct.fb_updated_time)
            {
                // Review changes !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            }
            
        }
    }
}

- (Product*)parseFBPhotoName:(id)results;
{
    ProductModel *productMethods = [[ProductModel alloc] init];
    Product *tempProduct = [[Product alloc] init];
    
    tempProduct.client_id = @"";
    tempProduct.desc = results[@"name"];
    tempProduct.fb_photo_id = results[@"id"];
    tempProduct.fb_link = results[@"link"];
    
    // Get name, currency, price, GS code and type from photo description
    
    tempProduct.name = [productMethods getProductNameFromFBPhotoDesc:tempProduct.desc];
    
    NSString *tmpText;
    
    tmpText = [productMethods getTextThatFollows:@"GSN" fromMessage:tempProduct.desc];
    if (![tmpText isEqualToString:@"Not Found"])
    {
        tempProduct.codeGS = [NSString stringWithFormat:@"GSN%@", tmpText];
        tempProduct.type = @"A";
    }
    else
    {
        tmpText = [productMethods getTextThatFollows:@"GS" fromMessage:tempProduct.desc];
        if (![tmpText isEqualToString:@"Not Found"])
        {
            tempProduct.codeGS = [NSString stringWithFormat:@"GS%@", tmpText];
            tempProduct.type = @"S";
        }
        else
        {
            tempProduct.codeGS = @"None";
            tempProduct.type = @"A";
        }
    }
    
    tmpText = [productMethods getTextThatFollows:@"s/. " fromMessage:tempProduct.desc];
    if (![tmpText isEqualToString:@"Not Found"]) {
        tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
        tempProduct.currency = @"S/.";
        tempProduct.price = [NSNumber numberWithFloat:[tmpText integerValue]];
    }
    else
    {
        tmpText = [productMethods getTextThatFollows:@"S/. " fromMessage:tempProduct.desc];
        if (![tmpText isEqualToString:@"Not Found"]) {
            tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
            tempProduct.currency = @"S/.";
            tempProduct.price = [NSNumber numberWithFloat:[tmpText integerValue]];
        }
        else
        {
            tmpText = [productMethods getTextThatFollows:@"USD " fromMessage:tempProduct.desc];
            if (![tmpText isEqualToString:@"Not Found"]) {
                tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
                tempProduct.currency = @"USD";
                tempProduct.price = [NSNumber numberWithFloat:[tmpText integerValue]];
            }
            else {
                tmpText = [productMethods getTextThatFollows:@"US$ " fromMessage:tempProduct.desc];
                if (![tmpText isEqualToString:@"Not Found"]) {
                    tmpText = [tmpText stringByReplacingOccurrencesOfString:@"," withString:@""];
                    tempProduct.currency = @"USD";
                    tempProduct.price = [NSNumber numberWithFloat:[tmpText integerValue]];
                }
                else {
                    tempProduct.currency = @"S/.";
                    tempProduct.price = 0;
                }
            }
        }
    }
    
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
    tempProduct.created_time = [formatFBdates dateFromString:results[@"created_time"]];
    tempProduct.updated_time = [formatFBdates dateFromString:results[@"updated_time"]];
    tempProduct.fb_updated_time = [formatFBdates dateFromString:results[@"updated_time"]];
    tempProduct.solddisabled_time = [formatFBdates dateFromString:@"2000-01-01T01:01:01+0000"];
    tempProduct.last_promotion_time = [formatFBdates dateFromString:@"2000-01-01T01:01:01+0000"];
    
    tempProduct.picture_link = results[@"picture"];
    tempProduct.additional_pictures = @"";
    tempProduct.status = @"N";
    tempProduct.promotion_piority = @"2";
    tempProduct.notes = @"";
    tempProduct.agent_id = @"00001";
    
    // Status... Sold?
    tmpText = [productMethods getTextThatFollows:@"VENDID" fromMessage:tempProduct.desc];
    if (![tmpText isEqualToString:@"Not Found"])
    {
        tempProduct.status = @"S";
    }
    
    return tempProduct;
}


#pragma mark methods for getting FB photo comments

- (void)getFBPhotoCommentsforProduct:(Product*)forProduct;
{
    if (forProduct.fb_photo_id && ![forProduct.fb_photo_id isEqualToString:@""])
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd"];
        _messagesSinceDate = [dateFormat dateFromString:@"20100101"];
        
        NSString *url = [NSString stringWithFormat:@"%@/comments", forProduct.fb_photo_id];
        
        [self makeFBRequestforPhotoComments:url forProduct:forProduct];
    }
    else
    {
        // No FB product related
        NSLog(@"No FB product related to photo");
        [self.delegate finishedGettingFBPhotoComments:NO];
    }
}

- (void)makeFBRequestforPhotoComments:(NSString *)url forProduct:(Product *)forProduct;
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {  // FB request was a success!
             
             if (result[@"data"])
             {   // There is FB data!
                 
                 NSMutableArray *jsonArray = result[@"data"];
                 
                 [self parseFBPhotoComments:jsonArray forProduct:forProduct];
             }
             
             // Review if there are more comments for this photo
             NSString *next = result[@"paging"][@"next"];
             
             if (next)
             {
                 [self makeFBRequestforPhotoComments:[next substringFromIndex:32] forProduct:forProduct];
             }
             else
             {
                 // Call method for getting sub comments if there are comments
                 if (!(_commentsIDArray.count == 0))
                 {
                     // Get message details for the new notifications
                     [self makeFBRequestForSubComments:@"FBPhotoComments"];
                 }
                 else
                 {
                     // No comments found
                     [self.delegate finishedGettingFBPhotoComments:YES];
                 }
            }
             
         } else {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error makeFBRequestforPhotoComments: %@", error.description);
             [self.delegate finishedGettingFBPhotoComments:NO];
         }
     }];
}

- (void)parseFBPhotoComments:(NSMutableArray*)jsonArray forProduct:(Product *)forProduct;
{
    MessageModel *messageMethods = [[MessageModel alloc] init];
    Message *tempMessage;
    Client *tempClient;
    
    for (int j=0; j<jsonArray.count; j=j+1)
    {
        NSDictionary *newMessage = jsonArray[j];
        [_commentsIDArray addObject:newMessage[@"id"]];
        
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
            
            tempMessage.fb_photo_id = forProduct.fb_photo_id;
            tempMessage.product_id = forProduct.product_id;
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
                newClient.last_name = @"Apellido";
                newClient.sex = @"F";
                newClient.client_zone = @"Surco";
                newClient.address = @"";
                newClient.phone1 = @"";
                newClient.phone2 = @"";
                newClient.email = @"";
                newClient.preference = @"F";
                newClient.picture_link = @"";
                newClient.status = @"N";
                newClient.created_time = [NSDate date];
                newClient.last_interacted_time = [formatFBdates dateFromString:@"2000-01-01T10:00:00+0000"];
                newClient.last_inventory_time = newClient.last_interacted_time;
                newClient.notes = @"";
                newClient.agent_id = @"00001";

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
    
}

- (void)makeFBRequestForSubComments:(NSString*)fromMethod;
{
    NSMutableString *requestCommentsDetails = [[NSMutableString alloc] init];
    
    // Request detail information for each picture
    
    BOOL isLastOne = NO;
    
    for (int i=0; i<_commentsIDArray.count; i=i+1)
    {
        requestCommentsDetails = [[NSMutableString alloc] init];
        
        [requestCommentsDetails appendString:_commentsIDArray[i]];
        [requestCommentsDetails appendString:@"?fields=id,from,created_time,comments"];
        [requestCommentsDetails appendString:[NSString stringWithFormat:@"&since=%ld", (long)[_messagesSinceDate timeIntervalSince1970]]];
        
        if (i == (_commentsIDArray.count - 1))
        {
            isLastOne = YES;
        }
        
        [self getFBPhotoSubComments:requestCommentsDetails fromMethod:fromMethod isLastOne:isLastOne];
    }
}

- (void)getFBPhotoSubComments:(NSString*)url fromMethod:(NSString*)fromMethod isLastOne:(BOOL)isLastOne;
{
    // Make FB request
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         { // FB request was a success!
             
             [self parseFBPhotoSubComments:result];
             
             NSString *next = result[@"paging"][@"next"];
             if (next)
             {
                 [self getFBPhotoSubComments:[next substringFromIndex:32] fromMethod:fromMethod isLastOne:isLastOne];
             }
             else
             {
                 if (isLastOne)
                 {
                     // last subcomment processed!
                     if ([fromMethod isEqualToString:@"FBPhotoComments"])
                     {
                         [self.delegate finishedGettingFBPhotoComments:YES];
                     }
                     else
                     {
                         [self.delegate finishedGettingFBpageNotifications:YES];
                     }
                 }
             }
         }
         else
         {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error getFBPhotoSubComments: %@", error.description);
             if ([fromMethod isEqualToString:@"FBPhotoComments"])
             {
                 [self.delegate finishedGettingFBPhotoComments:NO];
             }
             else
             {
                 [self.delegate finishedGettingFBpageNotifications:NO];
             }
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
                    newClient.last_name = @"Apellido";
                    newClient.sex = @"F";
                    newClient.client_zone = @"Surco";
                    newClient.address = @"";
                    newClient.phone1 = @"";
                    newClient.phone2 = @"";
                    newClient.email = @"";
                    newClient.preference = @"F";
                    newClient.picture_link = @"";
                    newClient.status = @"N";
                    newClient.created_time = [NSDate date];
                    newClient.last_interacted_time = tempMessage.datetime;
                    newClient.last_inventory_time = newClient.last_interacted_time;
                    newClient.notes = @"";
                    newClient.agent_id = @"00001";

                    
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

                 if (result[@"data"])
                 {   // There is FB data!

                     NSArray *jsonArray = result[@"data"];
                     
                     // Get photo IDs of all notifications
                     for (int i=0; i<jsonArray.count; i=i+1)
                     {
                         NSDictionary *newMessage = jsonArray[i];
                         
                         if ([newMessage[@"application"][@"name"] isEqual: @"Photos"])
                         {
                             
                             NSString *photoIDfromLink = [self getPhotoID:newMessage[@"link"]]; // Optional: take from [@"object"][@"id"]
                             
                             // Review if photo ID already exists
                             BOOL photoExists = NO;
                             
                             for (int j=0; j<_photosArray.count; j=j+1)
                             {
                                 if ([photoIDfromLink isEqualToString:_photosArray[j]])
                                 {
                                     photoExists = YES;
                                 }
                             }
                             // Add photo ID to array
                             if (!photoExists) {
                                 [_photosArray addObject:photoIDfromLink];
                             }
                         }
                     }
                     
                 }
                 
                 // Review is there is a next page
                 NSString *next = result[@"paging"][@"next"];
                 if (next)
                 {
                     [self makeFBRequestForPageNotifications:[next substringFromIndex:32]];
                 }
                 else
                 {
                     // last request... look for photo details
                     if (!(_photosArray.count == 0))
                     {
                         // Get message details for the new notifications
                         [self makeFBRequestForPhotosDetails];
                     }
                     else
                     {
                         // No notifications related to photos found
                         [self.delegate finishedGettingFBpageNotifications:YES];
                     }
                 }

              }
             else
             {
                 // An error occurred, we need to handle the error
                 // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                 NSLog(@"error makeFBRequestForPageNotifications: %@", error.description);
                 [self.delegate finishedGettingFBpageNotifications:NO];
             }
         }];
    }
    else
    {
        [self.delegate finishedGettingFBpageNotifications:NO];
    }
}

- (void)makeFBRequestForPhotosDetails;
{
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    if (_newClientsArray == nil)
    {
        _newClientsArray = [[NSMutableArray alloc] init];
    }
    
    // Create string for FB request
    NSMutableString *requestPhotosList = [[NSMutableString alloc] init];
    [requestPhotosList appendString:@"?ids="];
    
    for (int i=0; i<_photosArray.count; i=i+1)
    {
        if (i>0) { [requestPhotosList appendString:@","]; }
        [requestPhotosList appendString:_photosArray[i]];
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
                 for (int i=0; i<_photosArray.count; i=i+1)
                 {
                     // Review each photo
                     NSString *photoID = result[_photosArray[i]][@"id"];
                     
                     // Review if product exists
                     NSString *productID = [productMethods getProductIDfromFbPhotoId:photoID];
                     
                     Product *tempProduct = [[Product alloc] init];
                     
                     if ([productID isEqual: @"Not Found"] && !(result[_photosArray[i]][@"name"] == nil) && ![[productMethods getTextThatFollows:@"GS" fromMessage:result[_photosArray[i]][@"name"]] isEqualToString:@"Not Found"])
                     {
                         // New product!
                         productID = [productMethods getNextProductID];
                         
                         tempProduct = [self parseFBPhotoName:result[_photosArray[i]]];
                         tempProduct.product_id = productID;
                         
                         [productMethods addNewProduct:tempProduct];
                     }
                     else
                     {
                         tempProduct = [productMethods getProductFromProductId:productID];
                     }
                     
                     // Review each comment
                     if (![tempProduct.product_id isEqualToString:@""])
                     {
                         NSMutableArray *jsonArray = result[_photosArray[i]][@"comments"][@"data"];
                         
                         [self parseFBPhotoComments:jsonArray forProduct:tempProduct];
                     }
                 }
                 
                 // Call method for getting sub comments if there are comments
                 if (!(_commentsIDArray.count == 0))
                 {
                     // Get message details for the new notifications
                     [self makeFBRequestForSubComments:@"FBPageNotifications"];
                 }
                 else
                 {
                     // No comments found
                     [self.delegate finishedGettingFBpageNotifications:YES];
                 }
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
             
             if (result[@"data"])
             {   // There is FB data!
                 
                 [self parseFBInbox:result];
             }
             
             NSString *next = result[@"paging"][@"next"];
             if (next)
             {
                 [self makeFBRequestForNewInbox:[next substringFromIndex:32]];
             }
             else
             {
                 // last inbox processed!
                 [self.delegate finishedGettingFBInbox:YES];
             }
         }
         else
         {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error makeFBRequestForNewInbox: %@", error.description);
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
            newClient.last_name = @"Apellido";
            newClient.sex = @"F";
            newClient.client_zone = @"Surco";
            newClient.address = @"";
            newClient.phone1 = @"";
            newClient.phone2 = @"";
            newClient.email = @"";
            newClient.preference = @"F";
            newClient.picture_link = @"";
            newClient.status = @"N";
            newClient.created_time = [NSDate date];
 
            NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
            [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
            newClient.last_interacted_time = [formatFBdates dateFromString:jsonArray[i][@"updated_time"]];;
 
            newClient.last_inventory_time = newClient.last_interacted_time;
            newClient.notes = @"";
            newClient.agent_id = @"00001";

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

- (void)getFBInboxForClient:(Client*)clientInbox sinceDate:(NSDate*)sinceDate;
{
    _messagesSinceDate = sinceDate;
    
    if ((_tmpSettings!= nil) && ![_tmpSettings.fb_page_id isEqualToString:@""])
    {
        NSString *url = [NSString stringWithFormat:@"%@/comments&since=%ld", clientInbox.fb_inbox_id, (long)[_messagesSinceDate timeIntervalSince1970]];
        
        [self getFBInboxComments:url withClientID:clientInbox.client_id];
    }
    else
    {
        [self setFBPageID];
        
        _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
        
        [self.delegate finishedGettingFBInbox:NO];
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
                 NSString *next = result[@"paging"][@"next"];
                 
                 if (next)
                 {
                     [self getFBInboxComments:[next substringFromIndex:32] withClientID:fromClientID];
                 }
                 else
                 {
                     // last comment processed!
                     [self.delegate finishedGettingFBInbox:YES];
                 }
             }
         } else {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error getFBInboxComments: %@", error.description);
             [self.delegate finishedGettingFBInbox:NO];
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
                 
                 if (result[@"data"])
                 {   // There is FB data!
                     [self parseFBPageMessages:result];
                 }
                 NSString *next = result[@"paging"][@"next"];
                 if (next)
                 {
                     [self makeFBRequestForPageMessages:[next substringFromIndex:32]];
                 }
                 else
                 {
                     // last page inbox processed!
                     [self.delegate finishedGettingFBPageMessages:YES];
                 }
             }
             else
             {
                 // An error occurred, we need to handle the error
                 // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                 NSLog(@"error makeFBRequestForPageMessages: %@", error.description);
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
            newClient.agent_id = @"00001";
            
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

- (void)getFBPageMessagesForClient:(Client*)clientInbox;
{
    
    if ((_tmpSettings!= nil) && ![_tmpSettings.fb_page_id isEqualToString:@""])
    {
        NSString *url = [NSString stringWithFormat:@"%@/messages", clientInbox.fb_page_message_id];
        
        [self getFBPageMessagesComments:url withClientID:clientInbox.client_id];
    }
    else
    {
        [self setFBPageID];
        
        _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];
        
        [self.delegate finishedGettingFBPageMessages:NO];
    }
}

- (void)getFBPageMessagesComments:(NSString *)url withClientID:(NSString *)fromClientID; // NOT IN USE
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil tokenString:_tmpSettings.fb_page_token version:@"v2.0" HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {  // FB request was a success!
             
             if (result[@"data"]) {   // There is FB data!
                 
                 NSArray *jsonMessagesArray = result[@"data"];
                 
                 [self parseFBPageMessagesComments:jsonMessagesArray withClientID:fromClientID];
                 
                 // Review if there are more comments from this chat
                 NSString *next = result[@"paging"][@"next"];
                 
                 if (next)
                 {
                     [self getFBPageMessagesComments:[next substringFromIndex:32] withClientID:fromClientID];
                 }
                 else
                 {
                     // last message processed!
                     [self.delegate finishedGettingFBPageMessages:YES];
                 }
             }
         } else {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             NSLog(@"error getFBPageMessagesComments: %@", error.description);
             [self.delegate finishedGettingFBPageMessages:NO];
         }
     }];
}

- (void)parseFBPageMessagesComments:(NSArray *)jsonMessagesArray withClientID:(NSString *)fromClientID;
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

- (void)parseFBMessageAttachments:(NSMutableArray*)attachmentsArray for:(Message*)containerMessage;
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
    if (_newClientsArray.count == 0)
    {
        // No new clients to add
        [self.delegate finishedInsertingNewClientsFound:YES];
    }
    else
    {
        ClientModel *clientMethods = [[ClientModel alloc] init];
        
        // Create string for FB request
        NSMutableString *requestClientDetails = [[NSMutableString alloc] init];
        Client *newClient = [[Client alloc] init];
        
        for (int i=0; i<_newClientsArray.count; i=i+1)
        {
            newClient = [[Client alloc] init];
            newClient = (Client *)_newClientsArray[i];
            
            // Review if new client is GarageSale
            if ([newClient.fb_client_id isEqualToString:_tmpSettings.fb_user_id] || [newClient.fb_client_id isEqualToString:_tmpSettings.fb_page_id])
            {
                // Is a message from GarageSale!...
                if (i == _newClientsArray.count-1)
                {
                    // This is the last new client
                    [self.delegate finishedInsertingNewClientsFound:YES];
                }
            }
            else
            {
                // Get information from new client
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
    }
}

@end
