//
//  FacebookMethods.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 15/08/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "Client.h"
#import "Product.h"

@protocol FacebookMethodsDelegate

-(void)newMessageAddedFromFB:(Message*)messageAdded;
-(void)finishedGettingFBpageNotifications:(BOOL)succeed;
-(void)finishedGettingFBInbox:(BOOL)succeed;
-(void)finishedGettingFBPageMessages:(BOOL)succeed;
-(void)finishedInsertingNewClientsFound:(BOOL)succeed;
-(void)finishedGettingFBPhotos:(BOOL)succeed;
-(void)finishedGettingFBPhotoComments:(BOOL)succeed;

@end

@interface FacebookMethods : NSObject

@property (nonatomic, strong) id<FacebookMethodsDelegate> delegate;

- (void)initializeMethods;
- (void)setFBPageID;
- (void)getFBPageNotifications:(NSDate*)sinceDate;
- (void)getFBInbox:(NSDate*)sinceDate;
- (void)getFBInboxForClient:(Client*)clientInbox sinceDate:(NSDate*)sinceDate;
- (void)getFBPageMessages:(NSDate*)sinceDate;
- (void)getFBPageMessagesForClient:(Client*)clientInbox;
- (void)insertNewClientsFound;
- (void)getFBPhotos;
- (void)getFBPhotoCommentsforProduct:(Product*)forProduct;

@end
