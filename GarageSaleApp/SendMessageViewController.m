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
#import "Settings.h"
#import "Message.h"
#import "MessageModel.h"
#import "SettingsModel.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


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
    Message *_relatedMessage;
    
    // Temp variables for user and page IDs
    Settings *_tmpSettings;
}

@end

@implementation SendMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableTemplates.delegate = self;
    self.tableTemplates.dataSource = self;
    
    // General settings
    _tmpSettings = [[[SettingsModel alloc] init] getSharedSettings];

    _clientBuyer = [[Client alloc] init];
    NSString *tmpID = [self.delegate getBuyerIdFromMessage];
    if (![tmpID isEqualToString:@""])
    {
        _clientBuyer = [[[ClientModel alloc] init] getClientFromClientId:tmpID];
    }

    _clientOwner = [[Client alloc] init];
    tmpID = [self.delegate getOwnerIdFromMessage];
    if (![tmpID isEqualToString:@""])
    {
        _clientOwner = [[[ClientModel alloc] init] getClientFromClientId:tmpID];
    }

    _relatedProduct = [[Product alloc] init];
    tmpID = [self.delegate getProductIdFromMessage];
    if (![tmpID isEqualToString:@""])
    {
        _relatedProduct = [[[ProductModel alloc] init] getProductFromProductId:tmpID];
    }
    
    _relatedMessage = [[Message alloc] init];
    tmpID = [self.delegate getMessageIdFromMessage];
    if (![tmpID isEqualToString:@""])
    {
        _relatedMessage = [[[MessageModel alloc] init] getMessageFromMessageId:tmpID];
    }
    
    _templateType = [self.delegate getTemplateTypeFromMessage];
    
    _myDataTemplates = [[[TemplateModel alloc] init] getTemplatesFromType:_templateType];
    _selectedTemplate = [[Template alloc] init];
    if ([_templateType isEqualToString:@"B"] || [_templateType isEqualToString:@"P"])
    {
        [self.filterTabs setSelectedSegmentIndex:0];
    }
    else if ([_templateType isEqualToString:@"O"])
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
    
    ClientModel *clientMethods = [[ClientModel alloc] init];
    
    if (_clientBuyer)
    {
        //self.imageBuyer.image = [UIImage imageWithData:_clientBuyer.picture];
        self.imageBuyer.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:_clientBuyer]];
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
        //self.imageOwner.image = [UIImage imageWithData:_clientOwner.picture];
        self.imageOwner.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:_clientOwner]];
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
        // self.imageProduct.image = [UIImage imageWithData:_relatedProduct.picture];
        self.imageProduct.image = [UIImage imageWithData:[[[ProductModel alloc] init] getProductPhotoFrom:_relatedProduct]];
        
        self.labelProductName.text = _relatedProduct.name;
        self.labelProductDesc.text = _relatedProduct.desc;
        
    }
    else
    {
        self.imageProduct.image = [UIImage imageNamed:@"Blank"];
        self.labelProductName.text = @"";
        self.labelProductDesc.text = @"";
        self.buttonPostInPhoto.hidden = YES;
    }

    
    // Client (recipient) information

    if ([_templateType isEqualToString:@"B"])
    {
        //self.imageClient.image = [UIImage imageWithData:_clientBuyer.picture];
        self.imageClient.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:_clientBuyer]];

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
    else if ([_templateType isEqualToString:@"O"])
    {
        //self.imageClient.image = [UIImage imageWithData:_clientOwner.picture];
        self.imageClient.image = [UIImage imageWithData:[clientMethods getClientPhotoFrom:_clientOwner]];
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing button actions

- (IBAction)selectTab:(id)sender
{
    if (self.filterTabs.selectedSegmentIndex == 0) // Compradores
    {
        _myDataTemplates = [[[TemplateModel alloc] init] getTemplatesFromType:@"B"];
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
    NSString *pageMessageID;
    
    if ([_templateType isEqualToString:@"B"])
    {
        pageMessageID = _clientBuyer.fb_page_message_id;
    }
    else if ([_templateType isEqualToString:@"O"]) 
    {
        pageMessageID = _clientOwner.fb_page_message_id;
    }
    
    if (![self.labelTemplateText.text isEqualToString:@""] && ![pageMessageID isEqualToString:@""])
    {
        // Send messages via Facabook
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:self.labelTemplateText.text forKey:@"message"];

        NSString *url = [NSString stringWithFormat:@"/%@/messages", pageMessageID];

        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:params tokenString:_tmpSettings.fb_page_token version:@"v2.0" HTTPMethod:@"POST"];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
        {
            if (!error)
            {  // FB post was a success!
                
                [self.delegate messageSent:@"M"];
            }
            else
            {
                // An error occurred, we need to handle the error
                // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                NSLog(@"error sendMessage: %@", error.description);
            }
        }];
        
    }
}

- (IBAction)postInPhoto:(id)sender
{
    if (![self.labelTemplateText.text isEqualToString:@""])
    {
        // Post message on Photo via Facabook
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:self.labelTemplateText.text forKey:@"message"];

        NSString *url = @"";

        if ([_relatedMessage.recipient isEqualToString:@"G"])
        {
            // Message sent to GS so reply is on the message
            url = [NSString stringWithFormat:@"/%@/comments", _relatedMessage.fb_msg_id];
        }
        else
        {
            // Message sent to client so reply is on the photo
            url = [NSString stringWithFormat:@"/%@/comments", _relatedProduct.fb_photo_id];
        }
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:params tokenString:_tmpSettings.fb_page_token version:@"v2.0" HTTPMethod:@"POST"];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error)
             {  // FB post was a success!
                 
                 [self.delegate messageSent:@"P"];
             }
             else
             {
                 // An error occurred, we need to handle the error
                 // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                 NSLog(@"error postInPhoto: %@", error.description);
             }
         }];
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
