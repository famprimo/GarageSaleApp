//
//  MessagesSinceTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 28/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "MessagesSinceTableViewController.h"
#import "Settings.h"
#import "SettingsModel.h"

@implementation MessagesSinceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    Settings *currentSettings = [[[SettingsModel alloc] init] getSharedSettings];
    
    int optionSelected = 3;
    if ([currentSettings.since_date isEqualToString:@"1D"])
    {
        optionSelected = 0;
    }
    else if ([currentSettings.since_date isEqualToString:@"1S"])
    {
        optionSelected = 1;
    }
    else if ([currentSettings.since_date isEqualToString:@"1M"])
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
        cell.textLabel.text = @"Hace 1 día";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Hace 1 semana";
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"Hace 1 mes";
    }
    else
    {
        cell.textLabel.text = @"Hace 6 meses";
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *updateSinceDate;
    
    if (indexPath.row == 0)
    {
        updateSinceDate = @"1D";
    }
    else if (indexPath.row == 1)
    {
        updateSinceDate = @"1S";
    }
    else if (indexPath.row == 2)
    {
        updateSinceDate = @"1M";
    }
    else
    {
        updateSinceDate = @"6M";
    }
    
    [[[SettingsModel alloc] init] updateSinceDate:updateSinceDate];
    
    [self.delegate sinceDateSelected];
}

@end
