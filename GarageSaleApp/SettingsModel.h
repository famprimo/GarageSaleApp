//
//  SettingsModel.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 06/06/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@interface SettingsModel : NSObject

- (void)saveInitialDataforSettings;
- (Settings*)getSettingsFromCoreData;
- (Settings*)getSharedSettings;
- (BOOL)addSettings:(Settings*)newSettings;
- (BOOL)updateSettingsUser:(NSString*)userName withUserID:(NSString*)userID andPageID:(NSString*)pageID andPageName:(NSString*)pageName andPageTokenID:(NSString*)pageTokenID;
- (BOOL)updateSettingsInitialDataSaved;
- (BOOL)updateSettingsTemplateDataUptaded:(NSDate*)lastUpdateDate;

@end
