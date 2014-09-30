//
//  ProductDetailViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "Product.h"
#import "ProductModel.h"
#import "Client.h"
#import "ProductImageViewController.h"
#import "CustomSegue.h"
#import "CustomUnwindSegue.h"


@interface ProductDetailViewController ()
{
    int margin;
    int marginLeft;
    int marginRight;
    int referenceCenter;
}
- (void)configureView;

@end

@implementation ProductDetailViewController

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
    
    margin = 30;
    marginLeft = margin;
    marginRight = self.view.frame.size.width - margin - 50;
    // marginRight = self.view.frame.size.width - margin;
    referenceCenter = (marginRight + margin) / 2;
    
    // Update the view
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
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
        
        Product *productSelected = [[Product alloc] init];
        productSelected = (Product *)_detailItem;
        
        Client *clientSelected = (Client *)[[[ProductModel alloc] init] getClient:productSelected];
        
        // NSMutableArray *opportunitiesSelected = [[[ ProductModel alloc] init] getOpportunitiesFromProduct:productSelected];

        // Add tap gesture recognizer to picture
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
        tapRecognizer.numberOfTapsRequired = 2;
        [self.imageProduct addGestureRecognizer:tapRecognizer];

        // Position of first item
        int positionY = 250;

        // Set Product Image
        self.imageProduct.image = [UIImage imageWithData:productSelected.picture];
        CGRect imageProductFrame = self.imageProduct.frame;
        imageProductFrame.origin.x = marginLeft;
        imageProductFrame.origin.y = positionY;
        imageProductFrame.size.width = marginRight - marginLeft;
        imageProductFrame.size.height = 500;
        self.imageProduct.frame = imageProductFrame;
       
        // Set Product Name
        positionY = positionY + self.imageProduct.frame.size.height + 20;
        self.labelName.text = productSelected.name;
        CGRect labelNameFrame = self.labelName.frame;
        labelNameFrame.origin.x = marginLeft;
        labelNameFrame.origin.y = positionY;
        labelNameFrame.size.width = marginRight - marginLeft;
        labelNameFrame.size.height = 60;
        self.labelName.frame = labelNameFrame;       
        
        // Set label "Offered by"
        positionY = positionY + self.labelName.frame.size.height + 20;
        CGRect labelOfferedbyFrame = self.labelOfferedBy.frame;
        labelOfferedbyFrame.origin.x = marginLeft;
        labelOfferedbyFrame.origin.y = positionY;
        self.labelOfferedBy.frame = labelOfferedbyFrame;

        // Set Client Image
        positionY = positionY + self.labelOfferedBy.frame.size.height + 10;
        self.imageClient.image = [UIImage imageWithData:clientSelected.picture];
        CGRect imageClientFrame = self.imageClient.frame;
        imageClientFrame.origin.x = marginLeft;
        imageClientFrame.origin.y = positionY;
        imageClientFrame.size.width = 50;
        imageClientFrame.size.height = 50;
        self.imageClient.frame = imageClientFrame;

        // Set Client Name
        self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", clientSelected.name, clientSelected.last_name];
        CGRect labelClientNameFrame = self.labelClientName.frame;
        labelClientNameFrame.origin.x = marginLeft + 60;
        labelClientNameFrame.origin.y = positionY;
        labelClientNameFrame.size.width = 200;
        labelClientNameFrame.size.height = 20;
        self.labelClientName.frame = labelClientNameFrame;

        // Set image "Zone Icon"
        CGRect imageZoneIconFrame = self.imageZoneIcon.frame;
        imageZoneIconFrame.origin.x = marginLeft + 60;
        imageZoneIconFrame.origin.y = positionY + 30;
        self.imageZoneIcon.frame = imageZoneIconFrame;

        // Set Client Zone
        self.labelClientZone.text = clientSelected.zone;
        CGRect labelClientZoneFrame = self.labelClientZone.frame;
        labelClientZoneFrame.origin.x = marginLeft + 90;
        labelClientZoneFrame.origin.y = positionY + 30;
        labelClientZoneFrame.size.width = 150;
        labelClientZoneFrame.size.height = 20;
        self.labelClientZone.frame = labelClientZoneFrame;
        
        // Set label "Details"
        positionY = positionY + self.imageClient.frame.size.height + 20;
        CGRect labelDetailsFrame = self.labelDetails.frame;
        labelDetailsFrame.origin.x = marginLeft;
        labelDetailsFrame.origin.y = positionY;
        self.labelDetails.frame = labelDetailsFrame;
        
        // Set Product Description
        positionY = positionY + self.labelDetails.frame.size.height + 10;
        self.labelDescription.text = productSelected.desc;
        CGRect labelDescriptionFrame = self.labelDescription.frame;
        labelDescriptionFrame.origin.x = marginLeft;
        labelDescriptionFrame.origin.y = positionY;
        labelDescriptionFrame.size.width = marginRight - marginLeft;
        self.labelDescription.frame = labelDescriptionFrame;
        [self.labelDescription sizeToFit];
        self.labelDescription.numberOfLines = 0;

        positionY = positionY + self.labelDescription.frame.size.height + 50;

        // Set content size of scrollview
        self.scrollViewProduct.contentSize = CGSizeMake(marginRight + margin, positionY);
        //[self.scrollViewProduct setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)tapPicture:(UITapGestureRecognizer *)sender
{
    NSLog(@"Tap Recognized");
    
    
    // Segue to the image
    [self performSegueWithIdentifier:@"ProductImageSegue" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"Image tapped");
    
    if([segue isKindOfClass:[CustomSegue class]]) {
        // Set the start point for the animation to center of the button for the animation
        ((CustomSegue *)segue).originatingPoint = self.imageProduct.center;
    }

    Product *productSelected = [[Product alloc] init];
    productSelected = (Product *)_detailItem;

    ProductImageViewController *imageVC = segue.destinationViewController;
    imageVC.selectedProduct = productSelected;

}

// This is the IBAction method referenced in the Storyboard Exit for the Unwind segue.
// It needs to be here to create a link for the unwind segue.
// But we'll do nothing with it.
- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender {
}

// We need to over-ride this method from UIViewController to provide a custom segue for unwinding
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    // Instantiate a new CustomUnwindSegue
    CustomUnwindSegue *segue = [[CustomUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    // Set the target point for the animation to the center of the button in this VC
    segue.targetPoint = self.imageProduct.center;
    return segue;
}



@end
