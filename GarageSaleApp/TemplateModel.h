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


@protocol TemplateModelDelegate

-(void)templatesSyncedWithCoreData:(BOOL)succeed;

@end


@interface TemplateModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) id<TemplateModelDelegate> delegate;

- (void)saveInitialDataforTemplates;
- (NSMutableArray*)getTemplatesFromCoreData;
- (void)syncCoreDataWithParse;
- (NSMutableArray*)getTemplatesFromType:(NSString*)templateType;
- (NSString*)getNextTemplateID;
- (void)addNewTemplate:(Template*)newTemplate;
- (void)updateTemplate:(Template*)templateToUpdate;
- (NSString*)changeKeysForText:(NSString*)textToReview usingBuyer:(Client*)clientBuyer andOwner:(Client*)clientOwner andProduct:(Product*)relatedProduct;

@end
