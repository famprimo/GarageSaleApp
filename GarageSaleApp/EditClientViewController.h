//
//  EditClientViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 25/03/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"
#import "ClientModel.h"

@protocol EditClientViewControllerDelegate

-(Client *)getClientforEdit;
-(void)clientEdited:(Client *)editedClient;

@end

@interface EditClientViewController : UIViewController <ClientModelDelegate>

@property (nonatomic, strong) id<EditClientViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIImageView *imageClient;
@property (weak, nonatomic) IBOutlet UILabel *labelClientName;
@property (weak, nonatomic) IBOutlet UILabel *labelClientCreationDate;

@property (weak, nonatomic) IBOutlet UIImageView *picMale;
@property (weak, nonatomic) IBOutlet UIImageView *picFemale;
@property (weak, nonatomic) IBOutlet UIImageView *picEmail;
@property (weak, nonatomic) IBOutlet UIImageView *picPhone1;
@property (weak, nonatomic) IBOutlet UIImageView *picPhone2;
@property (weak, nonatomic) IBOutlet UIImageView *picZone;

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textLastName;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPhone1;
@property (weak, nonatomic) IBOutlet UITextField *textPhone2;
@property (weak, nonatomic) IBOutlet UITextField *textZone;
@property (weak, nonatomic) IBOutlet UITextView *textAddress;
@property (weak, nonatomic) IBOutlet UITextView *textNotes;
@property (weak, nonatomic) IBOutlet UITextField *textCodeGS;

@property (weak, nonatomic) IBOutlet UISegmentedControl *tabSex;
@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;

@property (weak, nonatomic) IBOutlet UIImageView *picBackground;

@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIButton *buttonNextCodeGS;

@end
