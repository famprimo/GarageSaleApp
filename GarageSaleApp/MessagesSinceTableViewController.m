//
//  MessagesSinceTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 28/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "MessagesSinceTableViewController.h"

@interface MessagesSinceTableViewController ()
{
    NSDate *_dateSince;
}
@end

@implementation MessagesSinceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _dateSince = [self.delegate getCurrentSinceDate];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSTimeInterval secondsSince = -(int)[_dateSince timeIntervalSinceDate:[NSDate date]];
    int optionSelected = 3;
    if (secondsSince < 60*60*24*5)
    {
        optionSelected = 0;
    }
    else if (secondsSince < 60*60*24*20)
    {
        optionSelected = 1;
    }
    else if (secondsSince < 60*60*24*30*3)
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
    if (indexPath.row == 0)
    {
        _dateSince = [NSDate dateWithTimeInterval:-60*60*24*1 sinceDate:[NSDate date]];
    }
    else if (indexPath.row == 1)
    {
        _dateSince = [NSDate dateWithTimeInterval:-60*60*24*7 sinceDate:[NSDate date]];
    }
    else if (indexPath.row == 2)
    {
        _dateSince = [NSDate dateWithTimeInterval:-60*60*24*30 sinceDate:[NSDate date]];
    }
    else
    {
        _dateSince = [NSDate dateWithTimeInterval:-60*60*24*30*6 sinceDate:[NSDate date]];
    }
    
    [self.delegate sinceDateSelected:_dateSince];
}

@end
