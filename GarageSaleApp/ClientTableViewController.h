//
//  ClientTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientModel.h"
#import "EditClientViewController.h"
#import "ClientDetailViewController.h"


@class ClientDetailViewController;

@interface ClientTableViewController : UITableViewController <UIActionSheetDelegate, EditClientViewControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, ClientModelDelegate, ClientDetailViewControllerDelegate>

@property (strong, nonatomic) ClientDetailViewController *detailViewController;
@property (strong, nonatomic) UISearchController *searchController;

@end
