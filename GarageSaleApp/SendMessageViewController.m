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
    
    _clientBuyer = [[Client alloc] init];
    NSString *tmpID = [self.delegate GetBuyerIdFromMessage];
    if (![tmpID isEqualToString:@""])
    {
        _clientBuyer = [[[ClientModel alloc] init] getClientFromClientId:tmpID];
    }

    _clientOwner = [[Client alloc] init];
    tmpID = [self.delegate GetOwnerIdFromMessage];
    if (![tmpID isEqualToString:@""])
    {
        _clientOwner = [[[ClientModel alloc] init] getClientFromClientId:tmpID];
    }

    _relatedProduct = [[Product alloc] init];
    tmpID = [self.delegate GetProductIdFromMessage];
    if (![tmpID isEqualToString:@""])
    {
        _relatedProduct = [[[ProductModel alloc] init] getProductFromProductId:tmpID];
    }
    
    _templateType = [self.delegate GetTemplateTypeFromMessage];
    
    _myDataTemplates = [[[TemplateModel alloc] init] getTemplatesFromType:_templateType];
    _selectedTemplate = [[Template alloc] init];
    if ([_templateType isEqualToString:@"C"])
    {
        [self.filterTabs setSelectedSegmentIndex:0];
    }
    else
    {
        [self.filterTabs setSelectedSegmentIndex:1];
    }
    
    
    CGRect imageBuyerFrame = self.imageBuyer.frame;
    imageBuyerFrame.origin.x = 312;
    imageBuyerFrame.origin.y = 390;
    imageBuyerFrame.size.width = 40;
    imageBuyerFrame.size.height = 40;
    self.imageBuyer.frame = imageBuyerFrame;

    CGRect imageBuyerStatusFrame = self.imageBuyerStatus.frame;
    imageBuyerStatusFrame.origin.x = 360;
    imageBuyerStatusFrame.origin.y = 405;
    imageBuyerStatusFrame.size.width = 10;
    imageBuyerStatusFrame.size.height = 10;
    self.imageBuyerStatus.frame = imageBuyerStatusFrame;

    CGRect imageOwnerFrame = self.imageOwner.frame;
    imageOwnerFrame.origin.x = 312;
    imageOwnerFrame.origin.y = 445;
    imageOwnerFrame.size.width = 40;
    imageOwnerFrame.size.height = 40;
    self.imageOwner.frame = imageOwnerFrame;

    CGRect imageOwnerStatusFrame = self.imageOwnerStatus.frame;
    imageOwnerStatusFrame.origin.x = 360;
    imageOwnerStatusFrame.origin.y = 460;
    imageOwnerStatusFrame.size.width = 10;
    imageOwnerStatusFrame.size.height = 10;
    self.imageOwnerStatus.frame = imageOwnerStatusFrame;
    
    CGRect imageProductFrame = self.imageProduct.frame;
    imageProductFrame.origin.x = 554;
    imageProductFrame.origin.y = 415;
    imageProductFrame.size.width = 70;
    imageProductFrame.size.height = 70;
    self.imageProduct.frame = imageProductFrame;

    
    CGRect imageProductSoldFrame = self.imageProductSold.frame;
    imageProductSoldFrame.origin.x = 554;
    imageProductSoldFrame.origin.y = 415;
    imageProductSoldFrame.size.width = 70;
    imageProductSoldFrame.size.height = 70;
    self.imageProductSold.frame = imageProductSoldFrame;

    
    CGRect imageClientFrame = self.imageClient.frame;
    imageClientFrame.origin.x = 262;
    imageClientFrame.origin.y = 19;
    imageClientFrame.size.width = 40;
    imageClientFrame.size.height = 40;
    self.imageClient.frame = imageClientFrame;

    CGRect imageClientStatusFrame = self.imageClientStatus.frame;
    imageClientStatusFrame.origin.x = 312;
    imageClientStatusFrame.origin.y = 34;
    imageClientStatusFrame.size.width = 10;
    imageClientStatusFrame.size.height = 10;
    self.imageClientStatus.frame = imageClientStatusFrame;

    // Make client pictures rounded
    self.imageClient.layer.cornerRadius = self.imageClient.frame.size.width / 2;
    self.imageClient.clipsToBounds = YES;
    self.imageOwner.layer.cornerRadius = self.imageOwner.frame.size.width / 2;
    self.imageOwner.clipsToBounds = YES;
    self.imageBuyer.layer.cornerRadius = self.imageBuyer.frame.size.width / 2;
    self.imageBuyer.clipsToBounds = YES;

    // Basic information
    
    if (_clientBuyer)
    {
        self.imageBuyer.image = [UIImage imageWithData:_clientBuyer.picture];
        if ([_clientBuyer.status isEqualToString:@"V"])
        {
            self.labelBuyerName.text = [NSString stringWithFormat:@"    %@ %@", _clientBuyer.name, _clientBuyer.last_name];
            self.imageBuyerStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            self.labelBuyerName.text = [NSString stringWithFormat:@"%@ %@", _clientBuyer.name, _clientBuyer.last_name];
            self.imageBuyerStatus.image = [UIImage imageNamed:@"Blank"];
        }
    }
    else
    {
        self.imageBuyer.image = [UIImage imageNamed:@"Blank"];
        self.imageBuyerStatus.image = [UIImage imageNamed:@"Blank"];
        self.labelBuyerName.text = @"";
    }
    
    if (_clientOwner)
    {
        self.imageOwner.image = [UIImage imageWithData:_clientOwner.picture];
        if ([_clientOwner.status isEqualToString:@"V"])
        {
            self.labelOwnerName.text = [NSString stringWithFormat:@"    %@ %@", _clientOwner.name, _clientOwner.last_name];
            self.imageOwnerStatus.image = [UIImage imageNamed:@"Verified"];
        }
        else
        {
            self.labelOwnerName.text = [NSString stringWithFormat:@"%@ %@", _clientOwner.name, _clientOwner.last_name];
            self.imageOwnerStatus.image = [UIImage imageNamed:@"Blank"];
        }
    }
    else
    {
        self.imageOwner.image = [UIImage imageNamed:@"Blank"];
        self.imageOwnerStatus.image = [UIImage imageNamed:@"Blank"];
        self.labelOwnerName.text = @"";
    }
    

    if (_relatedProduct)
    {
        self.imageProduct.image = [UIImage imageWithData:_relatedProduct.picture];
        if ([_relatedProduct.status isEqualToString:@"S"])
        {
            self.imageProductSold.image = [UIImage imageNamed:@"Sold"];
        }
        else
        {
            self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
        }
        self.labelProductName.text = _relatedProduct.name;
        self.labelProductDesc.text = _relatedProduct.desc;
        
    }
    else
    {
        self.imageProduct.image = [UIImage imageNamed:@"Blank"];
        self.imageProductSold.image = [UIImage imageNamed:@"Blank"];
        self.labelProductName.text = @"";
        self.labelProductDesc.text = @"";
    }

    
    // Client (recipient) information

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


- (IBAction)selectTab:(id)sender
{
    if (self.filterTabs.selectedSegmentIndex == 0) // Compradores
    {
        _myDataTemplates = [[[TemplateModel alloc] init] getTemplatesFromType:@"C"];
        _selectedTemplate = [[Template alloc] init];
    }
    else if (self.filterTabs.selectedSegmentIndex == 1) // Duenos
    {
        _myDataTemplates = [[[TemplateModel alloc] init] getTemplatesFromType:@"O"];
        _selectedTemplate = [[Template alloc] init];
    }
    
    [self.tableTemplates reloadData];

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
