//
//  Template.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 16/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Template : NSObject

@property (strong, nonatomic) NSString *template_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *type; // (C)lient (O)wner
@property (strong, nonatomic) NSDate *updated_time;
@property (strong, nonatomic) NSString *agent_id;

@end
