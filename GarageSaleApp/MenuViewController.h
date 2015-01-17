//
//  MenuViewController.h
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MenuModel.h"
#import "MenuItem.h"

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, FBLoginViewDelegate>

@property (strong, nonatomic) MenuModel *model;
@property (strong, nonatomic) NSMutableArray *menuItems;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end
