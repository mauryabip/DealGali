//
//  LoginViewController.m
//  DealGali
//
//  Created by Virinchi Software on 18/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting for font and color
    self.phoneTXT.textColor=[UIColor DGBlackColor];
    self.phoneTXT.font=[UIFont DGTextFieldFont];
    self.passwordTXT.textColor=[UIColor DGBlackColor];
    self.passwordTXT.font=[UIFont DGTextFieldFont];
    self.loginBtn.backgroundColor=[UIColor DGPinkColor];
    self.loginBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.loginBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    self.signinBtn.titleLabel.textColor=[UIColor DGPurpleColor];
    self.signinBtn.titleLabel.font=[UIFont DGHyperLineButtonFont];
    self.forgotBtn.titleLabel.textColor=[UIColor DGPurpleColor];
    self.forgotBtn.titleLabel.font=[UIFont DGHyperLineButtonFont];
    
    
    self.gPlusBtn.layer.cornerRadius = 5; // this value vary as per your desire
    self.gPlusBtn.clipsToBounds = YES;
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    //fb login premissions
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""]
                                                                         style:UIBarButtonItemStylePlain target:nil action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
}
-(void)previousecall{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.revealViewController.panGestureRecognizer.enabled=NO;
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    // self.revealViewController.panGestureRecognizer.enabled=YES;
    //[self.navigationController setNavigationBarHidden:NO];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)loginBtnAction:(id)sender {
    
    [activeField resignFirstResponder];
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:currentDeviceId forKey:@"DeviceID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    // NSLog(@"%@",currentDeviceId);
    
    //NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    //API calling
    BOOL isValid=[self CheckForValidation];
    if (isValid) {
        
        self.passwordTXT.text = [self.passwordTXT.text stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        self.passwordTXT.text = [self.passwordTXT.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [[DealGaliInformation sharedInstance]ShowWaiting:Loading];
        NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
        NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
        [[DealGaliNetworkEngine sharedInstance] LoginAPI:self.phoneTXT.text password:self.passwordTXT.text deviceId:currentDeviceId deviceType:@"ios" Lat:lat Lon:lon withCallback:^(NSDictionary *response) {
            
            dic1=[response objectForKey:@"LoginStatus"];
            NSString *str=[dic1 objectForKey:@"Status"];
            
            if ([str isEqualToString:@"1"]) {
                NSString *str1=[dic1 objectForKey:@"Status"];
                NSString *str2=[dic1 objectForKey:@"EmailId"];
                NSString *str3=[dic1 objectForKey:@"MobileNumber"];
                NSString *str4=[dic1 objectForKey:@"UserName"];
                NSString *str5=[dic1 objectForKey:@"UserId"];//"UserId":"U3531
                [NSUSERDEFAULTS setObject:str1 forKey:@"Status"];
                [NSUSERDEFAULTS setObject:str2 forKey:@"EmailId"];
                [NSUSERDEFAULTS setObject:str3 forKey:@"UserMobileNumber"];
                [NSUSERDEFAULTS setObject:str4 forKey:@"UserName"];
                [NSUSERDEFAULTS setObject:str5 forKey:@"UniqueUserId"];
                
                //profile pic
                NSString *path=[dic1 valueForKey:@"userProfilePic"];
                
                [NSUSERDEFAULTS setObject:path forKey:@"ProfileImagePath"];
                [NSUSERDEFAULTS setObject:@"" forKey:@"PROFILE"];
                
                
                [NSUSERDEFAULTS synchronize];
                [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f]];
                [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
                
                //        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                //        self.window = window;
                
                [[DealGaliInformation sharedInstance]HideWaiting];
                [self showSucessWithMessage:LOGINSUCCESSFULLY];
                
            }
            else if ([str isEqualToString:@"2"]) {
                [[DealGaliInformation sharedInstance]HideWaiting];
                NSString *msgg=[dic1 objectForKey:@"Message"];
                [self showErrorWithMessage:msgg];
                
            }
            else{
                [[DealGaliInformation sharedInstance]HideWaiting];
                NSString *msgg=[dic1 objectForKey:@"Message"];
                [self showErrorWithMessage:msgg];
                //[[DealGaliInformation sharedInstance]showAlertWithMessage:msgg withTitle:ALERT withCancelTitle:OK];
            }
            
        }];
        
        
        
    }
    
    
}
- (void)handleTimer:(NSTimer*)theTimer {
    
    [self.minimalNotification dismiss];
    
    // UIViewController *Roottocontroller;
    SplashVC *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:SPLASHVCSTORYBOARD];
    
    
    RearViewController *rearViewController = [[DealGaliInformation sharedInstance]Storyboard:REARSTORYBOARDID];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;
    [self.navigationController presentViewController:revealController animated:NO completion:nil];
    self.viewController = revealController;
}


- (IBAction)forgotBtnAction:(id)sender {
    //    self.phoneTXT.text=@"";
    //    self.passwordTXT.text=@"";
    ForgotPasswordVC *forgotVC = [[DealGaliInformation sharedInstance]Storyboard:FORGOTSTORYBOARD];
    [self.navigationController pushViewController:forgotVC animated:YES];
    
    
}

- (IBAction)signUpBtnAction:(id)sender {
    //    self.phoneTXT.text=@"";
    //    self.passwordTXT.text=@"";
    SignUpViewController *signUpViewController = [[DealGaliInformation sharedInstance]Storyboard:SIGNUPSTORYBOARDID];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}


#pragma mark UITextFieldDelegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==self.phoneTXT)
    {
        NSUInteger newLength = [self.phoneTXT.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField==self.passwordTXT ) {
        self.showhideBtn.hidden=NO;
        
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (!self.passwordTXT.hasText) {
        self.showhideBtn.hidden=YES;
    }
    activeField = nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [activeField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneTXT resignFirstResponder];
    [self.passwordTXT resignFirstResponder];
}

- (IBAction)loginWithFacebookBtnAction:(id)sender {
    
}

- (IBAction)loginWithGoogleBtnAction:(id)sender {
    //    self.phoneTXT.text=@"";
    //    self.passwordTXT.text=@"";
    [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)showhideBtnAction:(id)sender {
    if (self.passwordTXT.secureTextEntry == YES) {
        // [ self.showhideBtn setTitle:@"H" forState:(UIControlStateNormal)];
        [ self.showhideBtn setBackgroundImage:[UIImage imageNamed:@"eye.png"] forState:UIControlStateNormal];
        
        self.passwordTXT.secureTextEntry = NO;
        
    }
    
    else
    {
        // [ self.showhideBtn setTitle:@"S" forState:(UIControlStateNormal)];
        [ self.showhideBtn setBackgroundImage:[UIImage imageNamed:@"eye.png"] forState:UIControlStateNormal];
        self.passwordTXT.secureTextEntry = YES;
    }
    
    
}
#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    //    self.phoneTXT.text=@"";
    //    self.passwordTXT.text=@"";
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"Status"];
    if ([savedValue isEqualToString:@"1"]) {
        //        NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
        //        NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
        //[[DealGaliNetworkEngine sharedInstance] GetHomeDetailAPI:lat lon:lon withCallback:^(NSDictionary *response) {
        
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(handleTimer:)
                                       userInfo:nil repeats:NO];
        
        // }];
    }
    else{
        SignUPWithFaceBookVC *signUpViewController = [[DealGaliInformation sharedInstance]Storyboard:SIGNUPWITHFACEBOOKSTORYBOARD];
        [self.navigationController pushViewController:signUpViewController animated:YES];
    }
    
}


-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user.objectID);
    [[NSUserDefaults standardUserDefaults] setObject:user.objectID forKey:@"facebookID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.objectID];
    [NSUSERDEFAULTS setObject:userImageURL forKey:@"ProfileImagePath"];
    
    //    self.profilePicture.profileID = user.id;
    //    NSLog(@"self.profilePicture.profileID  %@",self.profilePicture.profileID);
    //    NSData *imageData = UIImagePNGRepresentation(self.profilePicture.profileID);
    //    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"ProfileImage"];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    //    self.lblUsername.text = user.name;
    //    self.lblEmail.text = [user objectForKey:@"email"];
    NSString *userEmail=[user objectForKey:@"email"];
    if ([userEmail isKindOfClass:[NSNull class]] || [userEmail length]==0) {
        
    }
    else
        [NSUSERDEFAULTS setObject:[user objectForKey:@"email"] forKey:@"EmailId"];
    [NSUSERDEFAULTS setObject:user.name forKey:@"UserName"];
    [NSUSERDEFAULTS synchronize];
    
}


-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    //    self.lblLoginStatus.text = @"You are logged out";
    //
    //    [self toggleHiddenState:YES];
}


-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - Google SignIn Delegate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    
    if ([userId length]==0) {
        
    }
    else{
        [NSUSERDEFAULTS setObject:user.profile.email forKey:@"EmailId"];
        [NSUSERDEFAULTS setObject:user.profile.name forKey:@"UserName"];
        [NSUSERDEFAULTS setObject:userId forKey:@"googleID"];
        
        //    NSString *idToken = user.authentication.idToken; // Safe to send to the server
        //    NSString *fullName = user.profile.name;
        //    NSString *givenName = user.profile.givenName;
        //    NSString *familyName = user.profile.familyName;
        //    NSString *email = user.profile.email;
        //    NSLog(@"idToken : %@    userId:  %@     userId: %@      userId: %@ ",idToken,userId,userId,userId);
        if (user.profile.hasImage){
            NSURL *url = [user.profile imageURLWithDimension:100];
            NSString *urlString = [url absoluteString];
            [NSUSERDEFAULTS setObject:urlString forKey:@"ProfileImagePath"];
            
        }
        [NSUSERDEFAULTS synchronize];
        
        
        SignUPWithFaceBookVC *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:SIGNUPWITHFACEBOOKSTORYBOARD];
        [self.navigationController pushViewController:homeViewController animated:YES];
        
    }
    
}

- (void)signIn:(GIDSignIn *)signIn  didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    
    //Mobile number validation
    NSString *phoneRegex =@"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";// @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    
    
    if((![phoneTest evaluateWithObject:self.phoneTXT.text]) || (self.phoneTXT.text.length!=10) || ([self.phoneTXT.text isEqualToString:@""]&& [self.phoneTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.phoneTXT becomeFirstResponder];
        [self showErrorWithMessage:Validmobile];
        //[[DealGaliInformation sharedInstance]showAlertWithMessage:Validmobile withTitle:nil withCancelTitle:OK];
    }
    
    
    else
        if(([self.passwordTXT.text isEqualToString:@""]&& [self.passwordTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
        {
            valid = NO;
            [self.passwordTXT becomeFirstResponder];
            [self showErrorWithMessage:EnterPassword];
            // [[DealGaliInformation sharedInstance]showAlertWithMessage:EnterPassword withTitle:nil withCancelTitle:OK];
        }
    
    
    return valid;
}

- (void)showErrorWithMessage:(NSString *)message {
    if (self.minimalNotification) {
        [self.minimalNotification dismiss];
        [self.minimalNotification removeFromSuperview];
        self.minimalNotification = nil;
    }
    
    self.minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError
                                                                      title:message
                                                                   subTitle:nil
                                                             dismissalDelay:2.0];
    
    /**
     * Set the desired font for the title and sub-title labels
     * Default is System Normal
     */
    UIFont* titleFont = [UIFont DGLocalNotiFont];
    [self.minimalNotification setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont systemFontOfSize:16.0];
    [self.minimalNotification setSubTitleFont:subTitleFont];
    
    self.minimalNotification.presentFromTop = YES;
    /**
     * Add the notification to a view
     */
    [self.navigationController.view addSubview:self.minimalNotification];
    
    // show
    [self performSelector:@selector(showNotification) withObject:nil afterDelay:0.1];
}
-(void)showNotification1{
    [self.minimalNotification dismiss];
    NSString *str=[dic1 objectForKey:@"Status"];
    if ([str isEqualToString:@"2"]){
        VerifySignUpVC *otpVC = [[DealGaliInformation sharedInstance]Storyboard:VERIFYSIGNUPSTORYBOARD];
        otpVC.controllerName=@"login";
        [self.navigationController pushViewController:otpVC animated:YES];
        
    }
}

- (void)showNotification {
    [self.minimalNotification show];
    [self performSelector:@selector(showNotification1) withObject:nil afterDelay:2.0];
    
}
- (void)showSucessWithMessage:(NSString *)message {
    if (self.minimalNotification) {
        [self.minimalNotification dismiss];
        [self.minimalNotification removeFromSuperview];
        self.minimalNotification = nil;
    }
    
    self.minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess
                                                                      title:message
                                                                   subTitle:nil
                                                             dismissalDelay:2.0];
    
    /**
     * Set the desired font for the title and sub-title labels
     * Default is System Normal
     */
    UIFont* titleFont = [UIFont DGLocalNotiFont];
    [self.minimalNotification setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont systemFontOfSize:16.0];
    [self.minimalNotification setSubTitleFont:subTitleFont];
    
    self.minimalNotification.presentFromTop = YES;
    /**
     * Add the notification to a view
     */
    [self.navigationController.view addSubview:self.minimalNotification];
    
    // show
    [self performSelector:@selector(showSucessNotification) withObject:nil afterDelay:0.1];
}
-(void)showSucessNotification{
    [self.minimalNotification show];
    [self performSelector:@selector(handleTimer:) withObject:nil afterDelay:2.0];
    
}

@end
