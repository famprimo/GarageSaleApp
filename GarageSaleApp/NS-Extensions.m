//
//  NS-Extensions.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 13/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "NS-Extensions.h"

@implementation NS_Extensions

@end

@implementation UIImage (PhoenixMaster)
- (UIImage *) makeThumbnailOfSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    // draw scaled image into thumbnail context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    // pop the context
    UIGraphicsEndImageContext();
    if(newThumbnail == nil)
        NSLog(@"could not scale image");
    return newThumbnail;
}

@end

