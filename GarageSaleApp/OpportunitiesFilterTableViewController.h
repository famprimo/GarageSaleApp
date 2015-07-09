//
//  OpportunitiesFilterTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 19/05/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpportunitiesFilterViewControllerDelegate

-(NSString*)getCurrentFilter;
-(void)filterSet:(NSString*)selectedFilter;

@end

@interface OpportunitiesFilterTableViewController : UITableViewController

@property (nonatomic, strong) id<OpportunitiesFilterViewControllerDelegate> delegate;

@end


