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
#import "Product.h"
#import "ProductModel.h"

@interface SendMessageViewController ()
{
    // Data for the tables
    NSMutableArray *_myDataTemplates;
    
    // /For the selections in the tables
    Template *_selectedTemplate;
    
    Client *_clientBuyer;
    Client *_clientOwner;
    NSString *_templateType;
    Product *_relatedProduct;
}

@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableTemplates.delegate = self;
    self.tableTemplates.dataSource = self;
    
    _clientBuyer = [[[ClientModel alloc] init] getClientFromClientId:[self.delegate GetBuyerIdFromMessage]];
    _clientOwner = [[[ClientModel alloc] init] getClientFromClientId:[self.delegate GetOwnerIdFromMessage]];
    _relatedProduct = [[[ProductModel alloc] init] getProductFromProductId:[self.delegate GetProductIdFromMessage]];
    _templateType = [self.delegate GetTemplateTypeFromMessage];
    
    _myDataTemplates = [[[TemplateModel alloc] init] getTemplatesFromType:_templateType];
    _selectedTemplate = [[Template alloc] init];
    
    
    CGRect imageClientFrame = self.imageClient.frame;
    imageClientFrame.origin.x = 265;
    imageClientFrame.origin.y = 519;
    imageClientFrame.size.width = 40;
    imageClientFrame.size.height = 40;
    self.imageClient.frame = imageClientFrame;

    
    CGRect imageClientStatusFrame = self.imageClientStatus.frame;
    imageClientStatusFrame.origin.x = 313;
    imageClientStatusFrame.origin.y = 34;
    imageClientStatusFrame.size.width = 10;
    imageClientStatusFrame.size.height = 10;
    self.imageClientStatus.frame = imageClientStatusFrame;

    // Client information

    if ([_templateType isEqualToString:@"C"])
    {
        self.imageClient.image = [UIImage imageWithData:_clientBuyer.picture];

        if ([_clientBuyer.status isEqualToString:@"V"])
        {
            self.labelClientName.text = [NSString stringWithFormat:@"    %@ %@", _clientBuyer.name, _clientBuyer.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", _clientBuyer.name, _clientBuyer.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Blank"];
        }
    }
    else // "O"
    {
        self.imageClient.image = [UIImage imageWithData:_clientOwner.picture];
        
        if ([_clientOwner.status isEqualToString:@"V"])
        {
            self.labelClientName.text = [NSString stringWithFormat:@"    %@ %@", _clientOwner.name, _clientOwner.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", _clientOwner.name, _clientOwner.last_name];
            self.imageClientStatus.image = [UIImage imageNamed:@"Blank"];
        }
    }
    

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
    
    self.labelTemplateText.text = [[[TemplateModel alloc] init] changeKeysForText:_selectedTemplate.text usingBuyer:_clientBuyer andOwner:_clientOwner andProduct:_relatedProduct];
    self.labelTemplateText.editable = YES;
    
}


@end
