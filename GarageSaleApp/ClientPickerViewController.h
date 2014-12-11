//
//  ClientPickerViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 10/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClientPickerViewControllerDelegate

-(void)clientSelectedfromClientPicker:(NSString *)clientIDSelected;

@end


@interface ClientPickerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<ClientPickerViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *myTable;

@end
