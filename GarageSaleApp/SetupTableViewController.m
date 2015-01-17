//
//  SetupTableViewController.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 16/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "SetupTableViewController.h"
#import "SetupDetailViewController.h"
#import "SWRevealViewController.h"

@interface SetupTableViewController ()

@end

@implementation SetupTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // For the reveal menu to work
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Add title and menu button
    self.navigationItem.title = @"Configuración";
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClicked:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.detailViewController = (SetupDetailViewController *)[self.splitViewController.viewControllers objectAtIndex:1];
    
    // Remember to set ViewControler as the delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
        
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuButtonClicked:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    UILabel *automaticMessagesLabel = (UILabel*)[cell.contentView viewWithTag:1];
    UIImageView *automaticMessagesImage = (UIImageView*)[cell.contentView viewWithTag:2];

    CGRect automaticMessagesImageFrame = automaticMessagesImage.frame;
    automaticMessagesImageFrame.origin.x = 29;
    automaticMessagesImageFrame.origin.y = 25;
    automaticMessagesImageFrame.size.width = 30;
    automaticMessagesImageFrame.size.height = 30;
    automaticMessagesImage.frame = automaticMessagesImageFrame;

    automaticMessagesLabel.text = @"Mensajes automáticos";
    automaticMessagesImage.image = [UIImage imageNamed:@"MsgSetup"];
    
    return cell;
}



@end
