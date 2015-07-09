//
//  TemplateModel.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 17/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Template.h"
#import "Client.h"
#import "Product.h"

@interface TemplateModel : NSObject

- (void)saveInitialDataforTemplates;
- (NSMutableArray*)getTemplatesFromCoreData;
- (NSMutableArray*)getTemplatesFromType:(NSString*)templateType;
- (NSString*)getNextTemplateID;
- (BOOL)addNewTemplate:(Template*)newTemplate;
- (BOOL)updateTemplate:(Template*)templateToUpdate;
- (NSString*)changeKeysForText:(NSString*)textToReview usingBuyer:(Client*)clientBuyer andOwner:(Client*)clientOwner andProduct:(Product*)relatedProduct;

@end
