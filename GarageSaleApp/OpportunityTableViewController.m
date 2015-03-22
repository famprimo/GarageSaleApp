//
//  OpportunityTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 21/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "OpportunityTableViewController.h"
#import "OpportunityDetailViewController.h"
#import "SWRevealViewController.h"
#import "Opportunity.h"
#import "OpportunityModel.h"
#import "Client.h"
#import "ClientModel.h"
#import "Product.h"
#import "ProductModel.h"
#import "NSDate+NVTimeAgo.h"


@interface OpportunityTableViewController ()
{
    // Data for the table
    NSMutableArray *_myData;
        
    // The product that is selected from the table
    Opportunity *_selectedOpportunity;
    
}
@end

@implementation OpportunityTableViewController

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
    self.navigationItem.title = @"Oportunidades";
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newOpportunity:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.detailViewController = (OpportunityDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Get the listing data
    _myData = [[[OpportunityModel alloc] init] getOpportunitiesArray];
    
    // Sort array to be sure new opportunities are on top
    [_myData sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Opportunity*)a created_time];
        NSDate *second = [(Opportunity*)b created_time];
        return [second compare:first];
        //return [first compare:second];
    }];

    // Assign detail view with first item
    _selectedOpportunity = [_myData firstObject];
    [self.detailViewController setDetailItem:_selectedOpportunity];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)menuButtonClicked:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

- (void)newOpportunity:(id)sender
{
    // code for adding a new product
}

- (void)didReceiveMemoryWarning {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Retrieve cell
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"CellOpp" forIndexPath:indexPath];

    // Get references to images and labels of cell
    UILabel *productLabel = (UILabel*)[myCell.contentView viewWithTag:1];
    UILabel *opportunityDate = (UILabel*)[myCell.contentView viewWithTag:2];
    UILabel *clientName = (UILabel*)[myCell.contentView viewWithTag:3];
    UILabel *opportunityStatus = (UILabel*)[myCell.contentView viewWithTag:4];
    UIImageView *productImage = (UIImageView*)[myCell.contentView viewWithTag:5];
    UIImageView *productSoldImage = (UIImageView*)[myCell.contentView viewWithTag:6];
    UIImageView *clientImage = (UIImageView*)[myCell.contentView viewWithTag:7];
    UIImageView *clientStatus = (UIImageView*)[myCell.contentView viewWithTag:8];
    
    
    CGRect productImageFrame = productImage.frame;
    productImageFrame.origin.x = 8;
    productImageFrame.origin.y = 24;
    productImageFrame.size.width = 40;
    productImageFrame.size.height = 40;
    productImage.frame = productImageFrame;

    CGRect productSoldImageFrame = productSoldImage.frame;
    productSoldImageFrame.origin.x = 8;
    productSoldImageFrame.origin.y = 24; //32
    productSoldImageFrame.size.width = 40;
    productSoldImageFrame.size.height = 40; //23
    productSoldImage.frame = productSoldImageFrame;

    CGRect clientImageFrame = clientImage.frame;
    clientImageFrame.origin.x = 56;
    clientImageFrame.origin.y = 24;
    clientImageFrame.size.width = 40;
    clientImageFrame.size.height = 40;
    clientImage.frame = clientImageFrame;

    CGRect clientStatusFrame = clientStatus.frame;
    clientStatusFrame.origin.x = 104;
    clientStatusFrame.origin.y = 27;
    clientStatusFrame.size.width = 10;
    clientStatusFrame.size.height = 10;
    clientStatus.frame = clientStatusFrame;

    // Make client picture rounded
    clientImage.layer.cornerRadius = clientImage.frame.size.width / 2;
    clientImage.clipsToBounds = YES;

    // Get the information to be shown
    Opportunity *myOpportunity = _myData[indexPath.row];
    
    Product *relatedProduct = [[[ProductModel alloc] init] getProductFromProductId:myOpportunity.product_id];
    Client *clientRelatedToOpportunity = [[[ClientModel alloc] init] getClientFromClientId:myOpportunity.buyer_id];

    // Set product data
    
    productLabel.text = relatedProduct.name;
    productImage.image = [UIImage imageWithData:relatedProduct.picture];
    if ([relatedProduct.status isEqualToString:@"S"])
    {
        productSoldImage.image = [UIImage imageNamed:@"Sold"];
    }
    else
    {
        productSoldImage.image = [UIImage imageNamed:@"Blank"];
    }
    
    // Set client data
    clientImage.image = [UIImage imageWithData:clientRelatedToOpportunity.picture];
    if ([clientRelatedToOpportunity.status isEqualToString:@"V"])
    {
        clientName.text = [NSString stringWithFormat:@"    %@ %@", clientRelatedToOpportunity.name, clientRelatedToOpportunity.last_name];
        clientStatus.image = [UIImage imageNamed:@"Verified"];
    }
    else
    {
        clientName.text = [NSString stringWithFormat:@"%@ %@", clientRelatedToOpportunity.name, clientRelatedToOpportunity.last_name];
        clientStatus.image = [UIImage imageNamed:@"Blank"];
    }
    
    // Set opportunity status and dates
    
    opportunityDate.text = [myOpportunity.created_time formattedAsTimeAgo];
    
    if ([myOpportunity.status isEqualToString:@"O"])
    {
        opportunityStatus.text = @"Oportunidad abierta";
    }
    else if ([myOpportunity.status isEqualToString:@"C"])
    {
        opportunityStatus.text = [NSString stringWithFormat:@"Oportunidad cerrada %@", [myOpportunity.closedsold_time formattedAsTimeAgo]];
    }
    else if ([myOpportunity.status isEqualToString:@"S"])
    {
        opportunityStatus.text = [NSString stringWithFormat:@"Producto vendido %@, pero pendiente de pago", [myOpportunity.closedsold_time formattedAsTimeAgo]];
    }
    else if ([myOpportunity.status isEqualToString:@"P"])
    {
        opportunityStatus.text = [NSString stringWithFormat:@"Producto vendido %@, y pagado %@", [myOpportunity.closedsold_time formattedAsTimeAgo], [myOpportunity.paid_time formattedAsTimeAgo]];
    }

    
    return myCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected listing to var
    _selectedOpportunity = _myData[indexPath.row];
    
    // Refresh detail view with selected item
    [self.detailViewController setDetailItem:_selectedOpportunity];
}

@end
