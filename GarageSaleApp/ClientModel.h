//
//  ClientModel.h
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Client.h"

@interface ClientModel : NSObject

//- (NSMutableArray*)getClients:(NSMutableArray*)clientList;
- (NSMutableArray*)getClients;
- (NSString*)getNextClientID;
- (BOOL)addNewClient:(Client*)newClient;
- (void)updateClient:(Client*)clientToUpdate;
- (NSString*)getClientIDfromFbId:(NSString*)clientFbIdToValidate;
- (UIImage*)getImageFromClientId:(NSString*)clientIDtoSearch;
- (Client*)getClientFromClientId:(NSString*)clientIDtoSearch;

@end
