//
//  OpportunitiesFilterTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 19/05/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "OpportunitiesFilterTableViewController.h"

@interface OpportunitiesFilterTableViewController ()
{
    NSString *_optionSelected;
}
@end

@implementation OpportunitiesFilterTableViewController

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
    int optionSelected = 3; // @"Todas"
    
    if ([_optionSelected isEqualToString:@"Activas"])
    {
        optionSelected = 0;
    }
    else if ([_optionSelected isEqualToString:@"Abiertas"])
    {
        optionSelected = 1;
    }
    else if ([_optionSelected isEqualToString:@"Vendidas"])
    {
        optionSelected = 2;
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
    return 4;
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
        cell.textLabel.text = @"Activas";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Solo Abiertas";
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"Solo Vendidas";
    }
    else
    {
        cell.textLabel.text = @"Todas";
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        _optionSelected = @"Activas";
    }
    else if (indexPath.row == 1)
    {
        _optionSelected = @"Abiertas";
    }
    else if (indexPath.row == 2)
    {
        _optionSelected = @"Vendidas";
    }
    else
    {
        _optionSelected = @"Todas";
    }
    
    [self.delegate filterSet:_optionSelected];
}

@end
