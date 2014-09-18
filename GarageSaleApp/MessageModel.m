//
//  MessageModel.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (NSMutableArray*)getMessages:(NSMutableArray*)messageList;
{
    // Array to hold the listing data
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    // Create message #1
    Message *tempMessage = [[Message alloc] init];
    tempMessage.message_main_id = @"153344961539458_1378402423";
    tempMessage.message_detail_id = @"153344961539458_1378402423";
    tempMessage.from_facebook_id = @"10203554768023190";
    tempMessage.from_facebook_name = @"Mily de la Cruz";
    tempMessage.facebook_link = @"XXXXX";
    tempMessage.message = @"Me interesa. Enviar datos al inbox";
    // tempMessage.time = @"00001";
    tempMessage.from_client_id = @"00006";
    tempMessage.agent_id = @"00001";
    tempMessage.done = FALSE;
   
    // Add message #1 to the array
    [messages addObject:tempMessage];
    
    // Create message #2
    tempMessage = [[Message alloc] init];
    tempMessage.message_main_id = @"1469889866608936_1408489028";
    tempMessage.message_detail_id = @"1469889866608936_1408489028";
    tempMessage.from_facebook_id = @"10152156045491377";
    tempMessage.from_facebook_name = @"Amparo Gonzalez";
    tempMessage.facebook_link = @"XXXXX";
    tempMessage.message = @"Cuales son las medidas?";
    // tempMessage.time = @"00001";
    tempMessage.from_client_id = @"00004";
    tempMessage.agent_id = @"00001";
    tempMessage.done = FALSE;
    
    // Add message #2 to the array
    [messages addObject:tempMessage];
    
    // Return the producct array as the return value
    return messages;
}


@end
