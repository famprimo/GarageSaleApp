//
//  ProductTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 2/07/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ProductTableViewController.h"
#import "ProductDetailViewController.h"
#import "SWRevealViewController.h"
#import "Product.h"
#import "ProductModel.h"
#import "AppDelegate.h"

@interface ProductTableViewController ()
{
    // Data for the table
    NSMutableArray *_myData;
    
    AppDelegate *mainDelegate;
    
    // The product that is selected from the table
    Product *_selectedProduct;

}
@end

@implementation ProductTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // For the reveal menu to work
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    // Add title and menu button
    self.navigationItem.title = @"Productos";
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;
     
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newProduct:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.detailViewController = (ProductDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];

    // To have access to shared arrays from AppDelegate
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Get the listing data
    _myData = mainDelegate.sharedArrayProducts;
    
    // Assign detail view with first item
    _selectedProduct = [_myData firstObject];
    [self.detailViewController setDetailItem:_selectedProduct];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)menuButtonClicked:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

- (void)newProduct:(id)sender
{
    // code for adding a new product
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _myData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve cell
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Get the listing to be shown
    Product *myProduct = _myData[indexPath.row];
    
    // Get references to images and labels of cell
    UIImageView *pictureCell = (UIImageView*)[myCell.contentView viewWithTag:1];
    UILabel *nameLabel = (UILabel*)[myCell.contentView viewWithTag:2];
    UILabel *codeLabel = (UILabel*)[myCell.contentView viewWithTag:3];
    UILabel *priceLabel = (UILabel*)[myCell.contentView viewWithTag:4];
    
    // Set table cell labels to listing data
    pictureCell.image = [UIImage imageWithData:myProduct.picture];
    nameLabel.text = myProduct.name;
    codeLabel.text = myProduct.GS_code;
    priceLabel.text = [NSString stringWithFormat:@"%@%.f", myProduct.currency, myProduct.published_price];
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row selected at row %li", (long)indexPath.row);
    
    // Set selected listing to var
    _selectedProduct = _myData[indexPath.row];
    
    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedProduct];

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
