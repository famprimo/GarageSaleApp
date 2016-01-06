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

@interface ProductTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, ProductModelDelegate, ProductDetailViewControllerDelegate, FacebookMethodsDelegate, ProductsFilterTableViewControllerDelegate>

@property (strong, nonatomic) ProductDetailViewController *detailViewController;
@property IBOutlet UISearchBar *productSearchBar;

@end
