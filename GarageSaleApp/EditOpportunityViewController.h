//
//  EditOpportunityViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/05/15.
//  Copyright (c) 2015 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opportunity.h"

@protocol EditOpportunityViewControllerDelegate

-(Opportunity *)getOpportunityforEdit;
-(void)opportunityEdited:(Opportunity *)editedOpportunity;

@end

@interface EditOpportunityViewController : UIViewController

@property (nonatomic, strong) id<EditOpportunityViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *buttonOption1;
@property (weak, nonatomic) IBOutlet UIButton *buttonOption2;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UIImageView *imageSold;
@property (weak, nonatomic) IBOutlet UIImageView *imageClient;
@property (weak, nonatomic) IBOutlet UIImageView *imageClientStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imageOwner;
@property (weak, nonatomic) IBOutlet UIImageView *imageOwnerStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelClientName;
@property (weak, nonatomic) IBOutlet UILabel *labelOwnerName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductCurrency;
@property (weak, nonatomic) IBOutlet UILabel *labelProductCurrency2;
@property (weak, nonatomic) IBOutlet UITextField *textOpportunityPrice;
@property (weak, nonatomic) IBOutlet UITextField *textOpportunityCommision;
@property (weak, nonatomic) IBOutlet UITextView *textOpportunityNotes;


@end
