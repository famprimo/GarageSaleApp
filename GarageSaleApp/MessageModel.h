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

- (NSMutableArray*)getMessages:(NSMutableArray*)messageList;
- (BOOL)existNotification:(NSString*)notificationIDToValidate withMessagesArray:(NSMutableArray*)messageList;
- (BOOL)existMessage:(NSString*)messageIDToValidate withMessagesArray:(NSMutableArray*)messageList;
- (NSString*)getPhotoID:(NSString*)facebookLink;
- (NSString*)getCommentID:(NSString*)facebookLink;
- (NSString*)getMessagesIDs:(NSMutableArray*)messagesArray;

@end
