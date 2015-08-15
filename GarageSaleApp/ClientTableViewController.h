//
//  ClientTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientModel.h"

@class ClientDetailViewController;

@interface ClientTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, ClientModelDelegate>

@property (strong, nonatomic) ClientDetailViewController *detailViewController;
@property IBOutlet UISearchBar *clientSearchBar;

@end
