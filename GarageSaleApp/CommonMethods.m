//
//  CommonMethods.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 08/08/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "CommonMethods.h"

@implementation CommonMethods

- (NSNumber *) numberNotNil:(NSNumber*)number;
{
    if (number)
    {
        return number;
    }
    else
    {
        return [NSNumber numberWithFloat:0];
    }
}

- (NSString *) stringNotNil:(NSString*)string;
{
    if (string)
    {
        return string;
    }
    else
    {
        return @"";
    }
}

- (NSDate *) dateNotNil:(NSDate*)date;
{
    if (date)
    {
        return date;
    }
    else
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd"];
        return [dateFormat dateFromString:@"20000101"];
    }
}

@end
