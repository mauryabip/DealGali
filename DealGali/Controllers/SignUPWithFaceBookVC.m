//
//  SignUPWithFaceBookVC.m
//  DealGali
//
//  Created by Virinchi Software on 02/07/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "SignUPWithFaceBookVC.h"

@interface SignUPWithFaceBookVC ()

@end

@implementation SignUPWithFaceBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting for font and color
    self.phoneTXT.textColor=[UIColor DGBlackColor];
    self.phoneTXT.font=[UIFont DGTextFieldFont];
    self.emailTXT.textColor=[UIColor DGBlackColor];
    self.emailTXT.font=[UIFont DGTextFieldFont];
    self.firstNameTXT.textColor=[UIColor DGBlackColor];
    self.firstNameTXT.font=[UIFont DGTextFieldFont];
    self.updateBtn.backgroundColor=[UIColor DGPinkColor];
    self.updateBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.updateBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    self.termBtn.titleLabel.textColor=[UIColor DGPurpleColor];
    self.termBtn.titleLabel.font=[UIFont DGHyperLineButtonFont];
    
    self.firstNameTXT.text=[NSUSERDEFAULTS stringForKey:@"UserName"];
    self.emailTXT.text=[NSUSERDEFAULTS stringForKey:@"EmailId"];
    
    self.scrollView.userInteractionEnabled=YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
    
    
    self.navigationItem.rightBarButtonItem = nil;
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    
    
    self.navigationItem.leftBarButtonItem=revealButtonItem1;
    
}

-(void)previousecall{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled=NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)closeAction:(id)sender {
    
    //google logout
    if ([self.name isEqualToString:@"google"]) {
        [[GIDSignIn sharedInstance] signOut];
    }
    else{
        //facebook logout
        [FBSession.activeSession closeAndClearTokenInformation];
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpBTNaction:(id)sender {
    
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    
    // NSLog(@"%@",currentDeviceId);
    
    NSString *lat = [NSUSERDEFAULTS stringForKey:@"lat"];
    NSString *lon=[NSUSERDEFAULTS stringForKey:@"lon"];
    NSString *facebookID=[NSUSERDEFAULTS stringForKey:@"facebookID"];
    NSString *googleID=[NSUSERDEFAULTS stringForKey:@"googleID"];
    NSString *token=[NSUSERDEFAULTS stringForKey:@"token"];
    //API calling
    BOOL isValid=[self CheckForValidation];
    if (isValid){
        // if (self.checkBtn.selected) {
        
        [[DealGaliInformation sharedInstance]ShowWaiting:@"Updating details..."];
        if ([self.name isEqualToString:@"google"]) {
            [[DealGaliNetworkEngine sharedInstance]facebookSignUPAPI:self.firstNameTXT.text FacebookId:googleID emailid:self.emailTXT.text mobileNo:self.phoneTXT.text dob:self.dobTXT.text deviceId:currentDeviceId deviceType:@"ios" deviceToken:token latitude:lat lon:lon LoginType:@"google"  withCallback:^(NSDictionary *response) {
                
                dic1=[response objectForKey:@"SignUpStatus"];
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
                    
                    [NSUSERDEFAULTS synchronize];
                    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f]];
                    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
                    
                    
                    //  [[DealGaliNetworkEngine sharedInstance] GetHomeDetailAPI:lat lon:lon withCallback:^(NSDictionary *response) {
                    
                    [NSTimer scheduledTimerWithTimeInterval:0.0
                                                     target:self
                                                   selector:@selector(handleTimer:)
                                                   userInfo:response repeats:NO];
                    
                    //  }];
                }
                else{
                    [[DealGaliInformation sharedInstance]HideWaiting];
                    NSString *msgg=[dic1 objectForKey:@"Message"];
                    [self showErrorWithMessage:msgg];
                    // [[DealGaliInformation sharedInstance]showAlertWithMessage:msgg withTitle:@"Alert!" withCancelTitle:OK];
                }
                
            }];
        }
        else{
            [[DealGaliNetworkEngine sharedInstance]facebookSignUPAPI:self.firstNameTXT.text FacebookId:facebookID emailid:self.emailTXT.text mobileNo:self.phoneTXT.text dob:@"" deviceId:currentDeviceId deviceType:@"ios" deviceToken:token latitude:lat lon:lon LoginType:@"facebook"  withCallback:^(NSDictionary *response) {
                
                dic1=[response objectForKey:@"SignUpStatus"];
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
                    
                    [NSUSERDEFAULTS synchronize];
                    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f]];
                    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
                    
                    
                    //                    [[DealGaliNetworkEngine sharedInstance] GetHomeDetailAPI:lat lon:lon withCallback:^(NSDictionary *response) {
                    
                    [NSTimer scheduledTimerWithTimeInterval:0.0
                                                     target:self
                                                   selector:@selector(handleTimer:)
                                                   userInfo:response repeats:NO];
                    
                    //}];
                }
                else{
                    [[DealGaliInformation sharedInstance]HideWaiting];
                    NSString *msgg=[dic1 objectForKey:@"Message"];
                    [self showErrorWithMessage:msgg];
                    // [[DealGaliInformation sharedInstance]showAlertWithMessage:msgg withTitle:ALERT withCancelTitle:OK];
                }
                
            }];
        }
        
        
        
        //        }
        //        else
        //             [[DealGaliInformation sharedInstance]showAlertWithMessage:@"Please select Terms and Conditions" withTitle:nil withCancelTitle:OK];
        
        
    }
    
    
}
- (void)handleTimer:(NSTimer*)theTimer {
    [[DealGaliInformation sharedInstance]HideWaiting];
    [self showSucessWithMessage:DETAILSUPDATEDSUCCESSFULLY];
    
}



- (IBAction)termsNconditionsBtnAction:(id)sender {
    TermVC *tVC=[[DealGaliInformation sharedInstance]Storyboard:TERMVCSTORYBOARD];
    [self.navigationController pushViewController:tVC animated:YES];
}




- (IBAction)checkBoxBtnAction:(UIButton*)sender {
    
    //    sender.selected  = ! sender.selected;
    //
    //    if (sender.selected)
    //    {
    //        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"checd-box"] forState:UIControlStateSelected];
    //    }
    //    else
    //    {
    //       [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
    //    }
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    self.scrollView.contentInset = contentInsets;
    
    activeField = textField;
    self.navigationItem.rightBarButtonItem = nil;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
    if (textField==self.emailTXT) {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.scrollView.contentInset = contentInsets;
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [activeField resignFirstResponder];
}

- (void)touch
{
    [self.phoneTXT resignFirstResponder];
    [self.emailTXT resignFirstResponder];
    [self.firstNameTXT resignFirstResponder];
    [self.dobTXT resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    
}

-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z]+\\.[A-Za-z]{2,4}"];
    
    //Mobile number validation
    NSString *phoneRegex =@"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";// @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    
    
    if(([self.firstNameTXT.text isEqualToString:@""]&& [self.firstNameTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.firstNameTXT becomeFirstResponder];
        [self showErrorWithMessage:Enterusername];
        //[[DealGaliInformation sharedInstance]showAlertWithMessage:Enterusername withTitle:nil withCancelTitle:OK];
    }
    else if((![phoneTest evaluateWithObject:self.phoneTXT.text]) || (self.phoneTXT.text.length!=10) || ([self.phoneTXT.text isEqualToString:@""]&& [self.phoneTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self showErrorWithMessage:Validmobile];
        //[[DealGaliInformation sharedInstance]showAlertWithMessage:Validmobile withTitle:nil withCancelTitle:OK];
    }
    
    else if(self.emailTXT.text.length>0){
        if(![emailTest evaluateWithObject:self.emailTXT.text]){
            valid = NO;
            [self showErrorWithMessage:VALIDEMAIL];
            // [[DealGaliInformation sharedInstance]showAlertWithMessage:VALIDEMAIL withTitle:nil withCancelTitle:OK];
        }
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
    [self performSelector:@selector(detailsUpdate) withObject:nil afterDelay:2.0];
    
}
-(void)detailsUpdate{
    [self.minimalNotification dismiss];
    UIViewController *Roottocontroller;
    SplashVC *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:SPLASHVCSTORYBOARD];
    
    Roottocontroller=homeViewController;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
    [navController setViewControllers: @[Roottocontroller] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    
    
}
@end
