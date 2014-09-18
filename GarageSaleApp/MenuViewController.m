//
//  MenuViewController.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"

@interface MenuViewController ()
{
    // The product data from the ProductModel
    NSMutableArray *_productList;
}

@end

@implementation MenuViewController

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
    
    // Get the Product data
    //_productList = [[[ProductModel alloc] init] getProducts:_productList];
    
    // Set self as the data source and delegate for the table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Fetch the menu items
    self.menuItems = [[[MenuModel alloc] init] getMenuItem];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Delegate Methods


- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Retrieve cell
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Get menu item that it's asking for
    MenuItem *item = self.menuItems[indexPath.row];
    
    // Get image view
    UILabel *menuItemTitle = (UILabel *)[menuCell viewWithTag:1];
    UIImageView *iconImageView = (UIImageView *)[menuCell viewWithTag:2];
    
    // UIImageView *picMenu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:item.menuIcon]];
    // iconImageView = picMenu;
    
    // Set menu item text and icon
    menuItemTitle.text = item.menuTitle;
    iconImageView.image = [UIImage imageNamed:item.menuIcon];

    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check with item was tapped
    MenuItem *item = self.menuItems[indexPath.row];
    
    switch (item.screenType) {
        case ScreenTypeMessages:
            // Go to product screen
            [self performSegueWithIdentifier:@"GoToMessageSegue" sender:self];
            break;

        case ScreenTypeClient:
            // Go to client screen
            [self performSegueWithIdentifier:@"GoToClientSegue" sender:self];
            break;
            
        case ScreenTypeProduct:
            // Go to product screen
            [self performSegueWithIdentifier:@"GoToProductSegue" sender:self];
            break;
            
        case ScreenTypeOpportunity:
            // Go to opportunity screen
            //[self performSegueWithIdentifier:@"GoToOpportunitySegue" sender:self];
            break;
            
        case ScreenTypeAbout:
            // Go to about screen
            //[self performSegueWithIdentifier:@"GoToAboutSegue" sender:self];
            break;
            
        default:
            break;
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    // Set the front view controller to be the destination on
    [self.revealViewController setFrontViewController:segue.destinationViewController];
    
    // Slide front view controller back into place
    [self.revealViewController revealToggleAnimated:YES];
    
}


@end
