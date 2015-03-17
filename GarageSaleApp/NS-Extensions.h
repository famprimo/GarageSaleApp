//
//  NS-Extensions.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 13/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NS_Extensions : NSObject
@end

@interface UIImage (PhoenixMaster)
- (UIImage *) makeThumbnailOfSize:(CGSize)size;
@end