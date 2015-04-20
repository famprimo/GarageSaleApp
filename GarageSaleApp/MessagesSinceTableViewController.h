//
//  MessagesSinceTableViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 28/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessagesSinceViewControllerDelegate

-(NSDate*)getCurrentSinceDate;
-(void)sinceDateSelected:(NSDate *)selectedSinceDate;

@end


@interface MessagesSinceTableViewController : UITableViewController

@property (nonatomic, strong) id<MessagesSinceViewControllerDelegate> delegate;

@end
