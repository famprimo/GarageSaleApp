//
//  ProductPickerViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductPickerViewControllerDelegate

-(void)productSelectedfromProductPicker:(NSMutableArray *)selectedProductsArray;
-(BOOL)allowMultipleSelectionfromProductPicker;
-(NSString*)getRelatedOwnerfromProductPicker;

@end

@interface ProductPickerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) id<ProductPickerViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageClient;
@property (weak, nonatomic) IBOutlet UILabel *labelClientName;
@property (weak, nonatomic) IBOutlet UIButton *buttonSelectProduct;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterTabs;
@property (weak, nonatomic) IBOutlet UISearchBar *productSearchBar;

@property (strong, nonatomic) UISearchController *searchController;

@end
