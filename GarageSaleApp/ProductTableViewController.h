//
//  ProductTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductDetailViewController;

@interface ProductTableViewController : UITableViewController

@property (strong, nonatomic) ProductDetailViewController *detailViewController;

@end
