//
//  MessageModel.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageModel : NSObject

- (void)saveInitialDataforMessages;
- (NSMutableArray*)getMessagesFromCoreData; // Return an array with all messages
- (NSMutableArray*)getMessagesArray; // Return an array with all messages
- (NSMutableArray*)getMessagesArrayFromClients; // Return an array will all messages with recipient "GarageSale"
- (NSMutableArray*)getMessagesArrayFromClient:(NSString*)clientFromID; // Return an array with all messages from a client
- (NSMutableArray*)getMessagesArrayForProduct:(NSString*)productForID; // Return an array with all messages for a product
- (Message*)getLastMessageFromClient:(NSString*)clientFromID; // Return the last message for a specific client
- (BOOL)addNewMessage:(Message*)newMessage;
- (BOOL)existMessage:(NSString*)messageIDToValidate; // Review an array of Messages to check if a given Message ID exists
- (NSString*)getPhotoID:(NSString*)facebookLink; // Search for 'fbid=' on a Facebook link to get photo_id
- (NSString*)getCommentID:(NSString*)facebookLink; // Search for 'comment_id=' on a Facebook link to get _id
- (NSString*)getMessagesIDs:(NSMutableArray*)messagesArray; // Method that returns the IDs of all the Messages in the array sent
- (Message*)getMessageFromMessageId:(NSString*)messageIDtoSearch;
- (int)numberOfUnreadMessages; // Method that returns the total number of unread messages
- (int)numberOfUnreadMessagesForClient:(NSString*)clientFromID; // Method that returns the total number of unread messages for a client
- (BOOL)updateMessage:(Message*)messageToUpdate; // Update a message
- (NSMutableArray*)sortMessagesArrayConsideringParents:(NSMutableArray*)messagesArray; // Order an array of messages considering parent messages

@end
