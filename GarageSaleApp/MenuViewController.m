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
    
    // UIImageView *picMenu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:item.menuIcon]];
    // iconImageView = picMenu;
    
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
