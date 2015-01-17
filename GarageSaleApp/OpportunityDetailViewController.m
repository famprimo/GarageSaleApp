//
//  OpportunityDetailViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 21/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "OpportunityDetailViewController.h"

@interface OpportunityDetailViewController ()

@end

@implementation OpportunityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        // Asign values to objects in View
        
        Opportunity *opportunitySelected = [[Opportunity alloc] init];
        opportunitySelected = (Opportunity *)_detailItem;
        
        
        // Set Opportunity Data

    
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
