//
//  ClientPickerViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 10/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ClientPickerViewController.h"
#import "Client.h"
#import "ClientModel.h"


@interface ClientPickerViewController ()
{
    
    // Data for the table
    NSMutableArray *_myData;
     
    // The client that is selected from the table
    Client *_selectedClient;
    
}
@end


@implementation ClientPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    // Remember to set ViewControler as the delegate and datasource
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    // Get the listing data
    _myData = clientMethods.getClients;
   
    // Add button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(selectClient:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Seleccionar" forState:UIControlStateNormal];
    button.frame = CGRectMake(250.0, 19.0, 94.0, 19.0);
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)selectClient:(id)sender
{
    if (_selectedClient)
    {
        [self.delegate clientSelectedfromClientPicker:_selectedClient.client_id];
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
    Client *myClient = _myData[indexPath.row];
    
    // Set table cell labels to listing data
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", myClient.name, myClient.last_name];
    cell.imageView.image = [UIImage imageWithData:myClient.picture];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected listing to var
    _selectedClient = _myData[indexPath.row];
    
}


@end
