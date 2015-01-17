//
//  SetupDetailViewController.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 16/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableTemplates;
@property (strong, nonatomic) IBOutlet UITextField *labelTemplateTitle;
@property (strong, nonatomic) IBOutlet UITextView *labelTemplateText;
@property (strong, nonatomic) IBOutlet UIButton *buttonSaveTemplate;
@property (strong, nonatomic) IBOutlet UIButton *buttonNewTemplate;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControlType;
@property (strong, nonatomic) IBOutlet UIImageView *imageTemplateIcon;

-(IBAction)saveTemplate:(id)sender;
-(IBAction)newTemplate:(id)sender;
-(IBAction)segmentedControlChange:(id)sender;


@end
