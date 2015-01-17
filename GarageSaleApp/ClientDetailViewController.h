//
//  ClientDetailViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface ClientDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelLastName;
@property (weak, nonatomic) IBOutlet UILabel *labelZone;

@end
