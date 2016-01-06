//
//  ProductsFilterTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 03/01/16.
//  Copyright © 2016 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductsFilterTableViewControllerDelegate

-(NSString*)getCurrentFilter;
-(void)filterSet:(NSString*)selectedFilter;

@end

@interface ProductsFilterTableViewController : UITableViewController

@property (nonatomic, strong) id<ProductsFilterTableViewControllerDelegate> delegate;

@end
