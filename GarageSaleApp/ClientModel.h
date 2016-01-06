//
//  ClientModel.h
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Client.h"

@protocol ClientModelDelegate

-(void)clientsSyncedWithCoreData:(BOOL)succeed;
-(void)clientAddedOrUpdated:(BOOL)succeed;

@end

@interface ClientModel : NSObject

@property (nonatomic, strong) id<ClientModelDelegate> delegate;

- (void)saveInitialDataforClients;
- (NSMutableArray*)getClientsFromCoreData;
- (void)syncCoreDataWithParse;
- (NSMutableArray*)getClientArray;
- (NSString*)getNextClientID;
- (NSString*)getClientIDfromCodeGS:(NSString*)codeGSToFind;
- (void)addNewClient:(Client*)newClient;
- (void)updateClient:(Client*)clientToUpdate;
- (NSData*)getClientPhotoFrom:(Client*)clientSelected;
- (NSString*)getClientIDfromFbId:(NSString*)clientFbIdToValidate;
- (Client*)getClientFromClientId:(NSString*)clientIDtoSearch;
- (int)numberOfNewClients;

@end
