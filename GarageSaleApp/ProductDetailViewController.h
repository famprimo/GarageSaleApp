//
//  ProductDetailViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;

@property (weak, nonatomic) IBOutlet UIImageView *imageClient;
@property (weak, nonatomic) IBOutlet UILabel *labelClientName;
@property (weak, nonatomic) IBOutlet UILabel *labelClientZone;

@property (weak, nonatomic) IBOutlet UILabel *labelOfferedBy;
@property (weak, nonatomic) IBOutlet UILabel *labelDetails;
@property (weak, nonatomic) IBOutlet UIImageView *imageZoneIcon;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewProduct;
@end
