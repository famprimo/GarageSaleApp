//
//  MessagesTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 06/02/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessagesDetailViewController;

@interface MessagesTableViewController : UITableViewController

@property (strong, nonatomic) MessagesDetailViewController *detailViewController;

@end

