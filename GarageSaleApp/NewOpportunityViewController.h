//
//  NewOpportunityViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 19/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NewOpportunityViewControllerDelegate

-(void)OpportunityCreated;
-(NSString*)GetBuyerIdForOpportunity;
-(NSString*)GetProductIdForOpportunity;

@end

@interface NewOpportunityViewController : UIViewController

@property (nonatomic, strong) id<NewOpportunityViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *buttonCreateOpportunity;
@property (strong, nonatomic) IBOutlet UIImageView *imageProduct;
@property (strong, nonatomic) IBOutlet UIImageView *imageSold;
@property (strong, nonatomic) IBOutlet UIImageView *imageClient;
@property (strong, nonatomic) IBOutlet UIImageView *imageClientStatus;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelProductGSCode;
@property (strong, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDesc;
@property (strong, nonatomic) IBOutlet UILabel *labelClientName;
@property (strong, nonatomic) IBOutlet UILabel *labelProductCurrency;
@property (strong, nonatomic) IBOutlet UITextField *textOpportunityPrice;
@property (strong, nonatomic) IBOutlet UITextView *textOpportunityNotes;

- (IBAction)createOpportunity:(id)sender;


@end