//
//  MessagesTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 06/02/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookMethods.h"
#import "ProductModel.h"
#import "ClientModel.h"
#import "MessagesDetailViewController.h"
#import "MessagesSinceTableViewController.h"

@class MessagesDetailViewController;

@interface MessagesTableViewController : UITableViewController <UIActionSheetDelegate, MessagesSinceViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, FacebookMethodsDelegate, ProductModelDelegate, ClientModelDelegate>

@property (strong, nonatomic) MessagesDetailViewController *detailViewController;
@property IBOutlet UISearchBar *clientSearchBar;

@end

