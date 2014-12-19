//
//  SendMessageViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 18/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "SendMessageViewController.h"
#import "Template.h"
#import "TemplateModel.h"
#import "Client.h"
#import "ClientModel.h"

@interface SendMessageViewController ()
{
    // Data for the tables
    NSMutableArray *_myDataTemplates;
    
    // /For the selections in the tables
    Template *_selectedTemplate;
    
    Client *_clientBuyer;
    Client *_clientOwner;
    NSString *_templateType;
}

@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableTemplates.delegate = self;
    self.tableTemplates.dataSource = self;
    
    _clientBuyer = [[[ClientModel alloc] init] getClientFromClientId:[self.delegate GetBuyerIdFromSendMessage]];
    _clientOwner = [[[ClientModel alloc] init] getClientFromClientId:[self.delegate GetOwnerIdFromSendMessage]];
    _templateType = [self.delegate GetTemplateTypeFromSendMessage];

    _myDataTemplates = [[[TemplateModel alloc] init] getTemplatesFromType:_templateType];
    _selectedTemplate = [[Template alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)sendMessage:(id)sender;
{
    if (_selectedTemplate)
    {
        // CODIGO PARA ENVIAR MENSAJE A TRAVES DE FACEBOOK

        [self.delegate MessageSent];
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
    return _myDataTemplates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Template *myTemplate = _myDataTemplates[indexPath.row];
    
    // Set table cell labels to listing data
    
    cell.textLabel.text = myTemplate.title;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set selected listing to var
    _selectedTemplate = _myDataTemplates[indexPath.row];
    
    self.labelTemplateText.text = _selectedTemplate.text;
    self.labelTemplateText.editable = YES;
    
}


@end
