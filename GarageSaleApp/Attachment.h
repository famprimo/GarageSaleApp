//
//  Attachment.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 10/07/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attachment : NSObject

@property (strong, nonatomic) NSString *fb_msg_id;
@property (strong, nonatomic) NSString *fb_attachment_id;
@property (strong, nonatomic) NSString *client_id;
@property (strong, nonatomic) NSDate *datetime ;
@property (strong, nonatomic) NSString *fb_name;
@property (strong, nonatomic) NSString *picture_link;
@property (strong, nonatomic) NSString *preview_link;
@property (strong, nonatomic) NSData *picture;
@property (strong, nonatomic) NSString *agent_id;


@end
