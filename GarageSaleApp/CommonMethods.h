//
//  CommonMethods.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 08/08/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonMethods : NSObject

- (NSNumber *) numberNotNil:(NSNumber*)number;
- (NSString *) stringNotNil:(NSString*)string;
- (NSDate *) dateNotNil:(NSDate*)date;

@end
