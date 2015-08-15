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

@class OpportunityDetailViewController;

@interface OpportunityTableViewController : UITableViewController <UIActionSheetDelegate, OpportunitiesFilterViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, OpportunityModelDelegate>

@property (strong, nonatomic) OpportunityDetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UISearchBar *opportunitySearchBar;

@end
