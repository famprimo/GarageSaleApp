//
//  AppDelegate.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// For Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


// Shared Arrays with Data
@property(nonatomic,retain) NSMutableArray *sharedArrayProducts;
@property(nonatomic,retain) NSMutableArray *sharedArrayClients;
@property(nonatomic,retain) NSMutableArray *sharedArrayOpportunities;
@property(nonatomic,retain) NSMutableArray *sharedArrayMessages;
@property(nonatomic,retain) NSMutableArray *sharedArrayTemplates;

@property(nonatomic) int lastProductID;
@property(nonatomic) int lastCientID;
@property(nonatomic) int lastOpportunityID;
@property(nonatomic) int lastTemplateID;

@end
