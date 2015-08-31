//
//  MenuViewController.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "SettingsModel.h"

@interface MenuViewController ()
{
    // The product data from the ProductModel
    NSMutableArray *_productList;
}

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set self as the data source and delegate for the table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    // Fetch the menu items
    self.menuItems = [[[MenuModel alloc] init] getMenuItem];
    
    // Creates Facebook login buton
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    CGRect loginButtonFrame = loginButton.frame;
    loginButtonFrame.origin.x = 10;
    loginButtonFrame.origin.y = 30;
    loginButtonFrame.size.width = 40;
    loginButtonFrame.size.height = 40;
    loginButton.frame = loginButtonFrame;
    
    [self.view addSubview:loginButton];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    loginButton.delegate = self;
    

    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in
        NSLog(@"User is already logged in");
        self.profilePictureView.profileID = [FBSDKProfile currentProfile].userID;
        self.nameLabel.text = [FBSDKProfile currentProfile].name;
        
        [self reviewFacebookPermisions];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Retrieve cell
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Get menu item that it's asking for
    MenuItem *item = self.menuItems[indexPath.row];
    
    // Get image view
    UILabel *menuItemTitle = (UILabel *)[menuCell viewWithTag:1];
    UIImageView *iconImageView = (UIImageView *)[menuCell viewWithTag:2];
    
    CGRect iconImageViewFrame = iconImageView.frame;
    iconImageViewFrame.origin.x = 20;
    iconImageViewFrame.origin.y = 17;
    iconImageViewFrame.size.width = 45;
    iconImageViewFrame.size.height = 45;
    iconImageView.frame = iconImageViewFrame;
    
    // Set menu item text and icon
    menuItemTitle.text = item.menuTitle;
    iconImageView.image = [UIImage imageNamed:item.menuIcon];

    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check with item was tapped
    MenuItem *item = self.menuItems[indexPath.row];
    
    switch (item.screenType) {
        case ScreenTypeMessages:
            // Go to product screen
            [self performSegueWithIdentifier:@"GoToMessageSegue" sender:self];
            break;

        case ScreenTypeClient:
            // Go to client screen
            [self performSegueWithIdentifier:@"GoToClientSegue" sender:self];
            break;
            
        case ScreenTypeProduct:
            // Go to product screen
            [self performSegueWithIdentifier:@"GoToProductSegue" sender:self];
            break;
            
        case ScreenTypeOpportunity:
            // Go to opportunity screen
            [self performSegueWithIdentifier:@"GoToOpportunitySegue" sender:self];
            break;
            
        case ScreenTypeStatistics:
            // Go to statistics screen
            //[self performSegueWithIdentifier:@"GoToAboutSegue" sender:self];
            break;

        case ScreenTypeSetup:
            // Go to setup screen
            [self performSegueWithIdentifier:@"GoToSetupSegue" sender:self];
            break;

        default:
            break;
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    // Set the front view controller to be the destination on
    [self.revealViewController setFrontViewController:segue.destinationViewController];
    
    // Slide front view controller back into place
    [self.revealViewController revealToggleAnimated:YES];
    
}


#pragma mark - FBSDKLoginButtonDelegate


- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if (error) {
        NSLog(@"Unexpected login error: %@", error);
        NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
        NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    else
    {
        NSLog(@"Logged in!");
        
        [self reviewFacebookPermisions];
        [self setFacebookPageID];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
}

- (void)observeProfileChange:(NSNotification *)notfication
{
    if ([FBSDKProfile currentProfile])
    {
        self.profilePictureView.profileID = [FBSDKProfile currentProfile].userID;
        self.nameLabel.text = [FBSDKProfile currentProfile].name;

        [self setFacebookPageID];
    }
}

- (void)reviewFacebookPermisions;
{
    NSArray *readPermissionsNeeded = @[@"read_stream", @"user_photos", @"user_friends", @"read_mailbox", @"read_page_mailboxes"];
    NSArray *writePermissionsNeeded = @[@"manage_notifications", @"manage_pages", @"publish_pages", @"publish_actions"];
    
    NSMutableArray *readPermissionsRequest = [[NSMutableArray alloc] init];
    NSMutableArray *writePermissionsRequest = [[NSMutableArray alloc] init];

    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];

    // Review read permissions
    BOOL needRequest = NO;
    for (int i=0; i<readPermissionsNeeded.count; i++)
    {
        if (![[FBSDKAccessToken currentAccessToken] hasGranted:readPermissionsNeeded[i]])
        {
            [readPermissionsRequest addObject:readPermissionsNeeded[i]];
            needRequest = YES;
        }
    }
    
    if (needRequest)
    {
        [loginManager logInWithReadPermissions:readPermissionsRequest handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             //TODO: process error or result.
             NSLog(@"%@",error);
         }];
    }
    
    // Review write permissions
    needRequest = NO;
    for (int i=0; i<writePermissionsNeeded.count; i++)
    {
        if (![[FBSDKAccessToken currentAccessToken] hasGranted:writePermissionsNeeded[i]])
        {
            [writePermissionsRequest addObject:writePermissionsNeeded[i]];
            needRequest = YES;
        }
    }
    
    if (needRequest)
    {
        [loginManager logInWithPublishPermissions:writePermissionsRequest handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             //TODO: process error or result.
             NSLog(@"%@",error);
         }];
    }
    
    
    // @"manage_notifications", @"manage_pages", @"publish_pages"
    // self.loginButton.readPermissions = @[@"public_profile", @"manage_notifications", @"read_stream", @"user_photos", @"user_friends", @"read_mailbox", @"manage_pages", @"publish_pages", @"read_page_mailboxes"];

}

- (void)setFacebookPageID;
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSString *url = @"me?fields=id,name,accounts";
        
        // Prepare for FB request
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:url parameters:nil];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error) {  // FB request was a success!
                 
                 NSString *userID = result[@"id"];
                 NSString *userName = result[@"name"];
                 NSString *pageID = result[@"accounts"][@"data"][0][@"id"];
                 NSString *pageName = result[@"accounts"][@"data"][0][@"name"];
                 NSString *pageToken = result[@"accounts"][@"data"][0][@"access_token"];
                 
                 if (![[[SettingsModel alloc] init] updateSettingsUser:userName withUserID:userID andPageID:pageID andPageName:pageName andPageTokenID:pageToken]) {
                     NSLog(@"Error updating settings");
                 }

             }
         }];
    }
}


@end
