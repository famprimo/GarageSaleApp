//
//  AttachmentModel.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 10/07/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "AttachmentModel.h"
#import "AppDelegate.h"
#import "Attachment.h"


@implementation AttachmentModel

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)saveInitialDataforAttachments;
{
    // No initial data for this class
}

- (NSMutableArray*)getAttachmentsFromCoreData;
{
    NSMutableArray *attachmentsArray = [[NSMutableArray alloc] init];
    
    // Fetch data from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Attachments"];
    attachmentsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return attachmentsArray;
}

- (BOOL)addNewAttachment:(Attachment*)newAttachment;
{
    BOOL updateSuccessful = YES;
    
    // Save object in persistent data store
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"Attachments" inManagedObjectContext:context];
    
    [coreDataObject setValue:newAttachment.fb_msg_id forKey:@"fb_msg_id"];
    [coreDataObject setValue:newAttachment.fb_attachment_id forKey:@"fb_attachment_id"];
    [coreDataObject setValue:newAttachment.client_id forKey:@"client_id"];
    [coreDataObject setValue:newAttachment.datetime forKey:@"datetime"];
    [coreDataObject setValue:newAttachment.fb_name forKey:@"fb_name"];
    [coreDataObject setValue:newAttachment.picture_link forKey:@"picture_link"];
    [coreDataObject setValue:newAttachment.preview_link forKey:@"preview_link"];
    [coreDataObject setValue:newAttachment.picture forKey:@"picture"];
    [coreDataObject setValue:newAttachment.agent_id forKey:@"agent_id"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        updateSuccessful = NO;
    }
    
    return updateSuccessful;
}

- (BOOL)updateAttachment:(Attachment*)attachmentToUpdate;
{
    BOOL updateSuccessful = YES;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Attachments" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"fb_attachment_id", attachmentToUpdate.fb_attachment_id];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request");
        NSLog(@"%@, %@", error, error.localizedDescription);
        updateSuccessful = NO;
    }
    else
    {
        if (result.count == 0)
        {
            NSLog(@"No records retrieved");
            updateSuccessful = NO;
        }
        else
        {
            // Set updated values
            NSManagedObject *coreDataObject = (NSManagedObject *)[result objectAtIndex:0];
            
            [coreDataObject setValue:attachmentToUpdate.fb_msg_id forKey:@"fb_msg_id"];
            [coreDataObject setValue:attachmentToUpdate.fb_attachment_id forKey:@"fb_attachment_id"];
            [coreDataObject setValue:attachmentToUpdate.client_id forKey:@"client_id"];
            [coreDataObject setValue:attachmentToUpdate.datetime forKey:@"datetime"];
            [coreDataObject setValue:attachmentToUpdate.fb_name forKey:@"fb_name"];
            [coreDataObject setValue:attachmentToUpdate.picture_link forKey:@"picture_link"];
            [coreDataObject setValue:attachmentToUpdate.preview_link forKey:@"preview_link"];
            [coreDataObject setValue:attachmentToUpdate.picture forKey:@"picture"];
            [coreDataObject setValue:attachmentToUpdate.agent_id forKey:@"agent_id"];

            
            // Save object to persistent store
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", error, error.localizedDescription);
                updateSuccessful = NO;
            }
        }
    }
    
    return updateSuccessful;
}

- (NSMutableArray*)getAttachmentsForFBMessageId:(NSString*)messageIDtoSearch;
{
    NSMutableArray *attachmentsArray = [[NSMutableArray alloc] init];
    
    // Fetch data from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Attachments"];
    
    NSPredicate *predicateFetch = [NSPredicate predicateWithFormat:@"fb_msg_id == %@", messageIDtoSearch];
    [fetchRequest setPredicate:predicateFetch];
    
    attachmentsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return attachmentsArray;
}


@end
