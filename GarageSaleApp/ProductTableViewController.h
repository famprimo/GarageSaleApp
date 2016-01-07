//
//  ProductTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ProductModel.h"
#import "ProductDetailViewController.h"
#import "FacebookMethods.h"
#import "ProductsFilterTableViewController.h"

@class ProductDetailViewController;

@interface ProductTableViewController : UITableViewController <UISearchBarDelegate, UISearchResultsUpdating, ProductModelDelegate, ProductDetailViewControllerDelegate, FacebookMethodsDelegate, ProductsFilterTableViewControllerDelegate>

@property (strong, nonatomic) ProductDetailViewController *detailViewController;
@property (strong, nonatomic) UISearchController *searchController;

@end

