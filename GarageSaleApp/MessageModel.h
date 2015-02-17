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

- (NSMutableArray*)getMessages; // Updates the array with message list with new messages from database
- (NSMutableArray*)getMessagesArray; // Return an array with all messages
- (NSMutableArray*)getMessagesArrayFromClients; // Return an array will all messages with recipient "GarageSale"
- (NSMutableArray*)getMessagesArrayFromClient:(NSString*)clientFromID; // Return an array with all messages from a client
//- (NSMutableArray*)getMessagesArrayFromClient:(NSString*)clientFromID withoutMessage:(NSString*)messageToNotConsider; // Return an array with all messages from a client
- (Message*)getLastMessageFromClient:(NSString*)clientFromID; // Return the last message for a specific client
- (BOOL)addNewMessage:(Message*)newMessage;
- (BOOL)existMessage:(NSString*)messageIDToValidate; // Review an array of Messages to check if a given Message ID exists
- (NSString*)getPhotoID:(NSString*)facebookLink; // Search for 'fbid=' on a Facebook link to get photo_id
- (NSString*)getCommentID:(NSString*)facebookLink; // Search for 'comment_id=' on a Facebook link to get _id
- (NSString*)getMessagesIDs:(NSMutableArray*)messagesArray; // Method that returns the IDs of all the Messages in the array sent
- (int)numberOfMessagesNotReplied; // Method that returns the total number of messages not replied yet
- (void)updateMessage:(Message*)messageToUpdate; // Update a message

@end
