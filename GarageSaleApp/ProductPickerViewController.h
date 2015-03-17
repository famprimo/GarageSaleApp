//
//  ProductPickerViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductPickerViewControllerDelegate

-(void)productSelectedfromProductPicker:(NSString *)productIDSelected;

@end

@interface ProductPickerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<ProductPickerViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *buttonSelectProduct;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterTabs;

@end
