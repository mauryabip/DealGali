//
//  VerifySignUpVC.m
//  DealGali
//
//  Created by Virinchi Software on 27/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "VerifySignUpVC.h"
#import "DealGaliNetworkEngine.h"
#import "DealGaliInformation.h"
#import "LoginViewController.h"

@interface VerifySignUpVC ()

@end

@implementation VerifySignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting for font and color
    self.otpTXT.textColor=[UIColor DGBlackColor];
    self.otpTXT.font=[UIFont DGTextFieldFont];
    self.optLbl.textColor=[UIColor DGLightGrayColor];
    self.optLbl.font=[UIFont DGTextFieldFont];
    self.optLbl.text=ENTERBELOWOPT;
    self.verifyOtpbtn.backgroundColor=[UIColor DGPinkColor];
    self.verifyOtpbtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.verifyOtpbtn.titleLabel.textColor=[UIColor DGWhiteColor];
    self.resendBtn.titleLabel.textColor=[UIColor DGPurpleColor];
    self.resendBtn.titleLabel.font=[UIFont DGHyperLineButtonFont];
    
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
}
-(void)previousecall{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled=NO;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)verifyAction:(id)sender {
    if (self.otpTXT.hasText) {
        
        if ([self.controllerName isEqualToString:@"login"]) {
            NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"SignUpMOBILENUMBER"];
            [[DealGaliNetworkEngine sharedInstance] verificationBasedOnMoNoAPI:savedValue VerificationCode:self.otpTXT.text withCallback:^(NSDictionary *response) {
                NSString *str=[response objectForKey:@"Status"];
                NSString *msg=[response objectForKey:@"Message"];
                if (![str isEqualToString:@"2"]) {
                    [[DealGaliInformation sharedInstance]HideWaiting];
                    
                    [self showSucessWithMessage:SIGNUPVERIFIESDSUCCESSFULLY];
                }
                else{
                    [[DealGaliInformation sharedInstance]HideWaiting];
                    [self showErrorWithMessage:msg];
                }
                
            }];
            
        }
        else{
            
            NSString *savedValue = [NSUSERDEFAULTS stringForKey:@"UserId"];
            
            [[DealGaliNetworkEngine sharedInstance] VerifyAPI:savedValue VerificationCode:self.otpTXT.text withCallback:^(NSDictionary *response) {
                NSString *str=[response objectForKey:@"Message"];
                
                if ([str isEqualToString:@"Success"]) {
                    
                    UIDevice *device = [UIDevice currentDevice];
                    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
                    [NSUSERDEFAULTS setObject:currentDeviceId forKey:@"DeviceID"];
                    [NSUSERDEFAULTS synchronize];
                    // NSLog(@"%@",currentDeviceId);
                    
                    //API calling
                    
                    [[DealGaliInformation sharedInstance]ShowWaiting:Verifying];
                    NSString *lat = [NSUSERDEFAULTS stringForKey:@"lat"];
                    NSString *lon=[NSUSERDEFAULTS stringForKey:@"lon"];
                    NSString *mobile=[NSUSERDEFAULTS stringForKey:@"SignUpMOBILENUMBER"];
                    NSString *password=[NSUSERDEFAULTS stringForKey:@"SignUpPASSWORD"];
                    
                    password = [password stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
                    password = [password stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                    
                    [[DealGaliNetworkEngine sharedInstance] LoginAPI:mobile password:password deviceId:currentDeviceId deviceType:@"ios" Lat:lat Lon:lon withCallback:^(NSDictionary *response) {
                        
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
                            [NSUSERDEFAULTS setObject:@"" forKey:@"PROFILE"];
                            
                            NSString *path=[dic1 valueForKey:@"userProfilePic"];
                            
                            [NSUSERDEFAULTS setObject:path forKey:@"ProfileImagePath"];
                            [NSUSERDEFAULTS synchronize];
                            [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f]];
                            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                            [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
                            [[DealGaliInformation sharedInstance]HideWaiting];
                            
                            [self showSucessWithMessage:SIGNUPVERIFIESDSUCCESSFULLY];
                        }
                        else{
                            [[DealGaliInformation sharedInstance]HideWaiting];
                            NSString *msgg=[dic1 objectForKey:@"Message"];
                            [self showErrorWithMessage:msgg];
                        }
                        
                    }];
                    
                    
                }
                else{
                    [self showErrorWithMessage:EnterVerificationCode];
                }
                
            }];
            
            
        }
        
        
    }
    else{
        [self showErrorWithMessage:EnterOTP];
    }
}

- (void)handleTimer:(NSTimer*)theTimer {
    
    [self.minimalNotification dismiss];
    if ([self.controllerName isEqualToString:@"login"]) {
        [self.navigationController  popToRootViewControllerAnimated:YES];
    }
    else{
        UIViewController *Roottocontroller;
        SplashVC *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:SPLASHVCSTORYBOARD];
        Roottocontroller=homeViewController;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
        [navController setViewControllers: @[Roottocontroller] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    
    
    // homeViewController.responceData=theTimer.userInfo;
    //    RearViewController *rearViewController = [[DealGaliInformation sharedInstance]Storyboard:REARSTORYBOARDID];
    //
    //    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    //    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    //
    //    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    //    revealController.delegate = self;
    //
    //    [self.navigationController presentViewController:revealController animated:NO completion:nil];
    //    self.viewController = revealController;
    
    
}



- (IBAction)resendOTPAction:(id)sender {
    [self showSucessWithMessage1:@"New OTP has been sent to the registered mobile number"];
}
-(void)resentOTP{
    NSString *mobile=[NSUSERDEFAULTS stringForKey:@"SignUpMOBILENUMBER"];
    [[DealGaliInformation sharedInstance]ShowWaiting:Verifying];
    [[DealGaliNetworkEngine sharedInstance] forgotPasswordAPI:mobile withCallback:^(NSDictionary *response){
        [[DealGaliInformation sharedInstance]HideWaiting];
        [self.minimalNotification dismiss];
    }];
}

#pragma mark UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    self.scrollView.contentInset = contentInsets;
    //self.scrollView.contentOffset = CGPointMake(0, self.otpTXT.frame.origin.y-150);
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    [textField resignFirstResponder];
    return YES;
}



-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

-(void)touch{
    [self.otpTXT resignFirstResponder];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [self performSelector:@selector(handleTimer:) withObject:nil afterDelay:3.0];
    
}
- (void)showSucessWithMessage1:(NSString *)message {
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
    [self performSelector:@selector(showSucessNotification1) withObject:nil afterDelay:0.1];
}
-(void)showSucessNotification1{
    [self.minimalNotification show];
    [self performSelector:@selector(resentOTP) withObject:nil afterDelay:3.0];
    
}



@end
