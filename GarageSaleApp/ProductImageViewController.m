//
//  ProductImageViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 4/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ProductImageViewController.h"

@interface ProductImageViewController ()

@end

@implementation ProductImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageProduct.image = [UIImage imageWithData:self.selectedProduct.picture];
    self.navigationItem.title = self.selectedProduct.name;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
