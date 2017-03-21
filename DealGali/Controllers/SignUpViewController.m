//
//  SignUpViewController.m
//  DealGali
//
//  Created by Virinchi Software on 18/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "SignUpViewController.h"
#import "VerifySignUpVC.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    
    //setting for font and color
    self.phoneTXT.textColor=[UIColor DGBlackColor];
    self.phoneTXT.font=[UIFont DGTextFieldFont];
    self.lastNameTXT.textColor=[UIColor DGBlackColor];
    self.lastNameTXT.font=[UIFont DGTextFieldFont];
    self.emailTXT.textColor=[UIColor DGBlackColor];
    self.emailTXT.font=[UIFont DGTextFieldFont];
    self.firstNameTXT.textColor=[UIColor DGBlackColor];
    self.firstNameTXT.font=[UIFont DGTextFieldFont];
    self.alreadyAccLbl.textColor=[UIColor DGLightGrayColor];
    self.alreadyAccLbl.font=[UIFont DGTextHomeFont];
    self.signup.backgroundColor=[UIColor DGPinkColor];
    self.signup.titleLabel.font=[UIFont DGActionButtonFont];
    self.signup.titleLabel.textColor=[UIColor DGWhiteColor];
    self.signinBtn.titleLabel.textColor=[UIColor DGLightGrayColor];
    self.signinBtn.titleLabel.font=[UIFont DGTextHomeFont];
    self.termBtn.titleLabel.textColor=[UIColor DGPurpleColor];
    self.termBtn.titleLabel.font=[UIFont DGHyperLineButtonFont];
    
    self.scrollView.userInteractionEnabled=YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
    
    
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
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



- (IBAction)signUpBTNaction:(id)sender {
    
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    
    // NSLog(@"%@",currentDeviceId);
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] stringForKey:@"lat"];
    NSString *lon=[[NSUserDefaults standardUserDefaults] stringForKey:@"lon"];
    NSString *token=[[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    //API calling
    BOOL isvalid=[self CheckForValidation];
    if (isvalid) {
        
        self.lastNameTXT.text = [self.lastNameTXT.text stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        self.lastNameTXT.text = [self.lastNameTXT.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        // if (self.checkBtn.selected) {
        [[DealGaliInformation sharedInstance]ShowWaiting:Loading];
        [[DealGaliNetworkEngine sharedInstance] postSignUPAPI:self.firstNameTXT.text password:self.lastNameTXT.text emailid:self.emailTXT.text mobileNo:self.phoneTXT.text deviceId:currentDeviceId deviceType:@"ios" deviceToken:token latitude:lat lon:lon dob:self.dobTXT.text withCallback:^(NSDictionary *response) {
            
            dic1=[response objectForKey:@"SignUpStatus"];
            NSString *str=[dic1 objectForKey:@"Message"];
            NSString *str1=[dic1 objectForKey:@"UserId"];
            if(![str1 isKindOfClass:[NSNull class]]) {
                [NSUSERDEFAULTS setObject:str1 forKey:@"UserId"];
                [NSUSERDEFAULTS synchronize];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([str isEqualToString:@"Success"]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.firstNameTXT.text forKey:@"SignUpNAME"];
                [[NSUserDefaults standardUserDefaults] setObject:self.lastNameTXT.text forKey:@"SignUpPASSWORD"];
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneTXT.text forKey:@"SignUpMOBILENUMBER"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[DealGaliInformation sharedInstance]HideWaiting];
                
                [self showSucessWithMessage:SIGNUPSUCCESSFULLY];
            }
            else{
                [[DealGaliInformation sharedInstance]HideWaiting];
                if ([str isEqualToString:@"Server error, please try again"]) {
                    [[DealGaliInformation sharedInstance]showAlertWithMessage:VALIDEMAIL withTitle:nil withCancelTitle:OK];
                }
                else{
                    [[DealGaliInformation sharedInstance]HideWaiting];
                    [self showErrorWithMessage:str];
                    
                    //[[DealGaliInformation sharedInstance]showAlertWithMessage:str withTitle:nil withCancelTitle:OK];
                }
                
            }
            
        }];
        
        
        //        }
        //        else
        //             [[DealGaliInformation sharedInstance]showAlertWithMessage:@"Please select Terms and Conditions" withTitle:nil withCancelTitle:OK];
        
    }
}
-(void)VerifyScreen{
    
    [self.minimalNotification dismiss];
    VerifySignUpVC *otpVC = [[DealGaliInformation sharedInstance]Storyboard:VERIFYSIGNUPSTORYBOARD];
    
    [self.navigationController pushViewController:otpVC animated:YES];
    
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollEnabled=NO;
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 180, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollEnabled=YES;
    activeField = textField;
    self.navigationItem.rightBarButtonItem = nil;
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField==self.emailTXT) {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollEnabled=NO;
    }
    activeField = nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [activeField resignFirstResponder];
}

- (void)touch
{
    [self.phoneTXT resignFirstResponder];
    [self.emailTXT resignFirstResponder];
    [self.firstNameTXT resignFirstResponder];
    [self.lastNameTXT resignFirstResponder];
    [self.dobTXT resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollEnabled=NO;
}

- (IBAction)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)signInBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:Enterusername withTitle:nil withCancelTitle:OK];
    }
    else if((![phoneTest evaluateWithObject:self.phoneTXT.text]) || (self.phoneTXT.text.length!=10) || ([self.phoneTXT.text isEqualToString:@""]&& [self.phoneTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.phoneTXT becomeFirstResponder];
        [self showErrorWithMessage:Validmobile];
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:Validmobile withTitle:nil withCancelTitle:OK];
    }
    
    else if(self.emailTXT.text.length>0){
        if(![emailTest evaluateWithObject:self.emailTXT.text]){
            valid = NO;
            [self showErrorWithMessage:VALIDEMAIL];
            //[[DealGaliInformation sharedInstance]showAlertWithMessage:VALIDEMAIL withTitle:nil withCancelTitle:OK];
        }
    }
    else
    {
        if(([self.lastNameTXT.text isEqualToString:@""]&& [self.lastNameTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
        {
            valid = NO;
            [self.lastNameTXT becomeFirstResponder];
            [self showErrorWithMessage:EnterPassword];
            //[[DealGaliInformation sharedInstance]showAlertWithMessage:EnterPassword withTitle:nil withCancelTitle:OK];
        }
        else if ([self.lastNameTXT.text length]<3){
            valid = NO;
            [self.lastNameTXT becomeFirstResponder];
            [self showErrorWithMessage:EnterPasswordValidation];
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
    [self performSelector:@selector(VerifyScreen) withObject:nil afterDelay:2.0];
    
}

@end
