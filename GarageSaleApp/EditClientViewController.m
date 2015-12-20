//
//  EditClientViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 25/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import "EditClientViewController.h"
#import "NSDate+NVTimeAgo.h"
#import "ProductModel.h"

@interface EditClientViewController ()
{
    Client *_clientToEdit;
    ClientModel *_clientMethods;
    ProductModel *_productMethods;
}
@end

@implementation EditClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize objects methods
    _clientMethods = [[ClientModel alloc] init];
    _clientMethods.delegate = self;

    _productMethods = [[ProductModel alloc] init];

    _clientToEdit = [self.delegate getClientforEdit];
    
    CGRect imageClientFrame = self.imageClient.frame;
    imageClientFrame.origin.x = 15;
    imageClientFrame.origin.y = 15;
    imageClientFrame.size.width = 70;
    imageClientFrame.size.height = 70;
    self.imageClient.frame = imageClientFrame;
    
    CGRect picMaleFrame = self.picMale.frame;
    picMaleFrame.origin.x = 120;
    picMaleFrame.origin.y = 181;
    picMaleFrame.size.width = 20;
    picMaleFrame.size.height = 20;
    self.picMale.frame = picMaleFrame;

    CGRect picFemaleFrame = self.picFemale.frame;
    picFemaleFrame.origin.x = 351;
    picFemaleFrame.origin.y = 181;
    picFemaleFrame.size.width = 20;
    picFemaleFrame.size.height = 20;
    self.picFemale.frame = picFemaleFrame;

    CGRect picEmailFrame = self.picEmail.frame;
    picEmailFrame.origin.x = 481;
    picEmailFrame.origin.y = 106;
    picEmailFrame.size.width = 20;
    picEmailFrame.size.height = 20;
    self.picEmail.frame = picEmailFrame;

    CGRect picPhone1Frame = self.picPhone1.frame;
    picPhone1Frame.origin.x = 120;
    picPhone1Frame.origin.y = 219;
    picPhone1Frame.size.width = 20;
    picPhone1Frame.size.height = 20;
    self.picPhone1.frame = picPhone1Frame;

    CGRect picPhone2Frame = self.picPhone2.frame;
    picPhone2Frame.origin.x = 120;
    picPhone2Frame.origin.y = 257;
    picPhone2Frame.size.width = 20;
    picPhone2Frame.size.height = 20;
    self.picPhone2.frame = picPhone2Frame;

    CGRect picZoneFrame = self.picZone.frame;
    picZoneFrame.origin.x = 481;
    picZoneFrame.origin.y = 144;
    picZoneFrame.size.width = 20;
    picZoneFrame.size.height = 20;
    self.picZone.frame = picZoneFrame;
    
    CGRect picBackgroundFrame = self.picBackground.frame;
    picBackgroundFrame.origin.x = 0;
    picBackgroundFrame.origin.y = 93;
    picBackgroundFrame.size.width = 800;
    picBackgroundFrame.size.height = 223;
    self.picBackground.frame = picBackgroundFrame;
    
    //self.imageClient.image = [UIImage imageWithData:_clientToEdit.picture];
    self.imageClient.image = [UIImage imageWithData:[[[ClientModel alloc] init] getClientPhotoFrom:_clientToEdit]];
    self.labelClientName.text = [NSString stringWithFormat:@"%@ %@", _clientToEdit.name, _clientToEdit.last_name];
    self.labelClientCreationDate.text = [NSString stringWithFormat:@"Creado %@",[_clientToEdit.created_time formattedAsDateComplete]];
    
    self.textName.text = _clientToEdit.name;
    self.textLastName.text = _clientToEdit.last_name;
    self.textEmail.text = _clientToEdit.email;
    self.textPhone1.text = _clientToEdit.phone1;
    self.textPhone2.text = _clientToEdit.phone2;
    self.textZone.text = _clientToEdit.client_zone;
    self.textAddress.text = _clientToEdit.address;
    self.textNotes.text = _clientToEdit.notes;
    self.textCodeGS.text = _clientToEdit.codeGS;
    
    if ([_clientToEdit.sex isEqualToString:@"M"])
    {
        [self.tabSex setSelectedSegmentIndex:0];
    }
    else
    {
        [self.tabSex setSelectedSegmentIndex:1];
    }
    
    if ([_clientToEdit.status isEqualToString:@"V"])
    {
        [self.switchStatus setOn:YES];
    }
    else
    {
        [self.switchStatus setOn:NO];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveClientEdits:(id)sender
{
    // Review if there was a change in code GS
    BOOL GSCodeUpdated = NO;
    if (![_clientToEdit.codeGS isEqualToString:self.textCodeGS.text])
    {
        GSCodeUpdated = YES;
    }
    
    // Create opportunity
    _clientToEdit.name = self.textName.text;
    _clientToEdit.last_name = self.textLastName.text;
    _clientToEdit.email = self.textEmail.text;
    _clientToEdit.phone1 = self.textPhone1.text;
    _clientToEdit.phone2 = self.textPhone2.text;
    _clientToEdit.client_zone =  self.textZone.text;
    _clientToEdit.address = self.textAddress.text;
    _clientToEdit.notes = self.textNotes.text;
    _clientToEdit.codeGS = self.textCodeGS.text;
    
    if (self.tabSex.selectedSegmentIndex == 0)
    {
        _clientToEdit.sex = @"M";
    }
    else
    {
        _clientToEdit.sex = @"F";
    }

    if (self.switchStatus.isOn)
    {
        _clientToEdit.status = @"V";
    }
    else
    {
        _clientToEdit.status = @"U";
    }
    
    [_clientMethods updateClient:_clientToEdit];

    if (GSCodeUpdated)
    {
        [_productMethods updateProductsWithCodeGS:_clientToEdit.codeGS withClientID:_clientToEdit.client_id];
    }
}

- (IBAction)getNextCodeGS:(id)sender
{
    self.textCodeGS.text = [_productMethods getNextCodeGS];
}


#pragma mark methods for OpportunityModel

-(void)clientsSyncedWithCoreData:(BOOL)succeed;
{
    // No need to implement
}

-(void)clientAddedOrUpdated:(BOOL)succeed;
{
    if (succeed)
    {
        [self.delegate clientEdited:_clientToEdit];
    }
}


@end
