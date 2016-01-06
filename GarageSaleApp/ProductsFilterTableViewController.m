//
//  ProductsFilterTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 03/01/16.
//  Copyright © 2016 Federico Amprimo. All rights reserved.
//

#import "ProductsFilterTableViewController.h"

@interface ProductsFilterTableViewController ()
{
    NSString *_optionSelected;
}
@end

@implementation ProductsFilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _optionSelected = [self.delegate getCurrentFilter];
}

- (void)viewDidAppear:(BOOL)animated
{
    int optionSelected = 2; // @"Todas"
    
    if ([_optionSelected isEqualToString:@"Activos"])
    {
        optionSelected = 0;
    }
    else if ([_optionSelected isEqualToString:@"Nuevos"])
    {
        optionSelected = 1;
    }
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:optionSelected inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Activos";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Solo Nuevos";
    }
    else
    {
        cell.textLabel.text = @"Todos";
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        _optionSelected = @"Activos";
    }
    else if (indexPath.row == 1)
    {
        _optionSelected = @"Nuevos";
    }
    else
    {
        _optionSelected = @"Todos";
    }
    
    [self.delegate filterSet:_optionSelected];
}

@end
