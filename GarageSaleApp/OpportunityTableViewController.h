//
//  OpportunityTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 21/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpportunitiesFilterTableViewController.h"
#import "OpportunityModel.h"
#import "OpportunityDetailViewController.h"

@class OpportunityDetailViewController;

@interface OpportunityTableViewController : UITableViewController <UIActionSheetDelegate, OpportunitiesFilterViewControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, OpportunityModelDelegate, OpportunityDetailViewControllerDelegate>

@property (strong, nonatomic) OpportunityDetailViewController *detailViewController;
@property (strong, nonatomic) UISearchController *searchController;

@end

