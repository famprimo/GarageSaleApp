//
//  ProductImageViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 4/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;

@property (strong, nonatomic) Product *selectedProduct;

@end
