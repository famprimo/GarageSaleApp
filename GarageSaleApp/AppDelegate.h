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

// Shared Arrays with Data
@property(nonatomic,retain) NSMutableArray *sharedArrayProducts;
@property(nonatomic,retain) NSMutableArray *sharedArrayClients;
@property(nonatomic,retain) NSMutableArray *sharedArrayOpportunities;

@end
