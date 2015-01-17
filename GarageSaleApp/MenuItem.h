//
//  MenuItem.h
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (strong, nonatomic) NSString *menuTitle;
@property (strong, nonatomic) NSString *menuIcon;
@property (nonatomic) int screenType;

@end
