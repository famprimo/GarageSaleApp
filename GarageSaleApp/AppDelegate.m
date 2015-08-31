//
//  AppDelegate.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsModel.h"
#import "ProductModel.h"
#import "ClientModel.h"
#import "OpportunityModel.h"
#import "MessageModel.h"
#import "AttachmentModel.h"
#import "TemplateModel.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Parse/Parse.h>

@implementation AppDelegate

@synthesize sharedSettings;
@synthesize sharedArrayProducts;
@synthesize sharedArrayClients;
@synthesize sharedArrayOpportunities;
@synthesize sharedArrayMessages;
@synthesize sharedArrayAttachments;
@synthesize sharedArrayTemplates;
@synthesize lastProductID;
@synthesize lastCientID;
@synthesize lastOpportunityID;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"ZTq2y8PnUJRt3S9XrioiiWBErFFbyd81YJmPRMhM"
                  clientKey:@"K9bIe2NfEj5vrLXPUXRNYTjWcmNCJpsGGJChyfFi"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    // Override point for customization after application launch.
    
    [FBSDKLoginButton class];
    [FBSDKProfilePictureView class];
    [FBSDKSendButton class];
    [FBSDKShareButton class];

    // Load Shared Arrays with Data
    
    ClientModel *clientMethods = [[ClientModel alloc] init];
    ProductModel *productMethods = [[ProductModel alloc] init];
    OpportunityModel *opportunityMethods = [[OpportunityModel alloc] init];
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    AttachmentModel *attachmentMethods = [[AttachmentModel alloc] init];
    TemplateModel *templateMethods = [[TemplateModel alloc] init];
    SettingsModel *settingsMethods = [[SettingsModel alloc] init];
    
    sharedSettings = [settingsMethods getSettingsFromCoreData];

    if (!sharedSettings)
    {
        [settingsMethods saveInitialDataforSettings];
    }
    
    if ([[[[SettingsModel alloc] init] getSharedSettings].initial_data_loaded isEqualToString:@"N"])
    {
        // Load initial data
        [clientMethods saveInitialDataforClients];
        [productMethods saveInitialDataforProducts];
        [opportunityMethods saveInitialDataforOpportunities];
        [messagesMethods saveInitialDataforMessages];
        [attachmentMethods saveInitialDataforAttachments];
        [templateMethods saveInitialDataforTemplates];
        
        [settingsMethods updateSettingsInitialDataSaved];
    }
    
    
    // Sync Parse with Core Data
    [clientMethods syncCoreDataWithParse];
    [productMethods syncCoreDataWithParse];
    [opportunityMethods syncCoreDataWithParse];
    [templateMethods syncCoreDataWithParse];
    
    // Get data from Core Data
    sharedArrayClients = [clientMethods getClientsFromCoreData];
    sharedArrayProducts = [productMethods getProductsFromCoreData];
    sharedArrayOpportunities = [opportunityMethods getOpportunitiesFromCoreData];
    sharedArrayMessages = [messagesMethods getMessagesFromCoreData];
    sharedArrayAttachments = [attachmentMethods getAttachmentsFromCoreData];
    sharedArrayTemplates = [templateMethods getTemplatesFromCoreData];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GarageSaleModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GarageSaleModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
