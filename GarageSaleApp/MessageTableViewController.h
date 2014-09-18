//
//  MessageTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageDetailViewController;

@interface MessageTableViewController : UITableViewController

@property (strong, nonatomic) MessageDetailViewController *detailViewController;

@end
