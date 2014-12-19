//
//  TemplateModel.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 17/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Template.h"

@interface TemplateModel : NSObject

- (NSMutableArray*)getTemplates;
- (NSMutableArray*)getTemplatesFromType:(NSString*)templateType;
- (NSString*)getNextTemplateID;
- (BOOL)addNewTemplate:(Template*)newTemplate;
- (void)updateTemplate:(Template*)templateToUpdate;
- (void)updateTemplate:(Template*)templateToUpdate withArray:(NSMutableArray*)arrayTemplates;

@end
