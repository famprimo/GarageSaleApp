//
//  AttachmentModel.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 10/07/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "Attachment.h"
#import <Foundation/Foundation.h>

@interface AttachmentModel : NSObject

- (void)saveInitialDataforAttachments;
- (NSMutableArray*)getAttachmentsFromCoreData;
- (NSMutableArray*)getAttachmentsArray;
- (BOOL)addNewAttachment:(Attachment*)newAttachment;
- (BOOL)updateAttachment:(Attachment*)AttachmentToUpdate;
- (NSMutableArray*)getAttachmentsForFBMessageId:(NSString*)messageIDtoSearch;

@end
