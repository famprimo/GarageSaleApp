//
//  ProductPickerViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "ProductPickerViewController.h"
#import "Product.h"
#import "ProductModel.h"
#import "NS-Extensions.h"


@interface ProductPickerViewController ()
{
    
    // Data for the table
    NSMutableArray *_productsArray;
    NSMutableArray *_myData;
    
    // The client that is selected from the table
    Product *_selectedProduct;
    
}
@end


@implementation ProductPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ProductModel *productMethods = [[ProductModel alloc] init];
    
    // Remember to set ViewControler as the delegate and datasource
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    // Get the listing data
    _productsArray = productMethods.getProductArray;
    
    // Sort array in alphabetic order
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [_productsArray sortUsingDescriptors:@[sort]];
    
    _myData = [NSMutableArray arrayWithArray:_productsArray];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)selectTab:(id)sender
{

    if (self.filterTabs.selectedSegmentIndex == 1) // Unsold
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(status == %@) OR (status ==%@)", @"N", @"U"];
        _myData = [NSMutableArray arrayWithArray:[_productsArray filteredArrayUsingPredicate:predicate]];
    }
    else if (self.filterTabs.selectedSegmentIndex == 2) // Recent
    {
        NSDate *referenceDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*21];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updated_time > %@", referenceDate];
        _myData = [NSMutableArray arrayWithArray:[_productsArray filteredArrayUsingPredicate:predicate]];
    }
    else // All
    {
        _myData = [NSMutableArray arrayWithArray:_productsArray];
    }
    
    [self.myTable reloadData];
}


- (IBAction)selectProduct:(id)sender
{
    if (_selectedProduct)
    {
        [self.delegate productSelectedfromProductPicker:_selectedProduct.product_id];
    }

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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Product *myProduct = _myData[indexPath.row];
    
    // Set table cell labels to listing data
    
    cell.textLabel.text = myProduct.name;
    cell.imageView.image = [[UIImage imageWithData:myProduct.picture] makeThumbnailOfSize:CGSizeMake(40, 40)];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected listing to var
    _selectedProduct = _myData[indexPath.row];
    
}



@end
