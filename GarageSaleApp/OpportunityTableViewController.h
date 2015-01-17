//
//  OpportunityTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 21/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpportunityDetailViewController;

@interface OpportunityTableViewController : UITableViewController

@property (strong, nonatomic) OpportunityDetailViewController *detailViewController;

@end
