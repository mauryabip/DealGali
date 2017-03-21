//
//  ForgotPasswordVC.m
//  DealGali
//
//  Created by Virinchi Software on 27/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "VerificationVC.h"
#import "DealGaliInformation.h"

@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //setting for font and color
    self.phoneXT.textColor=[UIColor DGBlackColor];
    self.phoneXT.font=[UIFont DGTextFieldFont];
    self.resetBtn.backgroundColor=[UIColor DGPinkColor];
    self.resetBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.resetBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    self.cancelBtn.backgroundColor=[UIColor DGLightGrayColor];
    self.cancelBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.cancelBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
}
-(void)previousecall{
    [[DealGaliInformation sharedInstance]HideWaiting];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancelAction:(id)sender {
    self.phoneXT.text=@"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetAction:(id)sender {
    BOOL isValid=[self CheckForValidation];
    if (isValid) {
        [[DealGaliInformation sharedInstance]ShowWaiting:SendVerificationCode];
        [[DealGaliNetworkEngine sharedInstance] forgotPasswordAPI:self.phoneXT.text withCallback:^(NSDictionary *response) {
            dic=[response objectForKey:@"OTPStatus"];
            NSString *str=[dic objectForKey:@"MobileNumber"];
            NSString *status=[dic objectForKey:@"Status"];
            NSString *msg=[dic objectForKey:@"Message"];
            if ([str isKindOfClass:[NSNull class]]) {
                
            }
            else
                [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"MobileNumber"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if ([status isEqualToString:@"1"]) {
                [[DealGaliInformation sharedInstance]HideWaiting];
                
                [self showSucessWithMessage:FORGOTPASSWORDSUCCESSFULY];
                
            }else{
                [[DealGaliInformation sharedInstance]HideWaiting];
                [self showErrorWithMessage:msg];
                // [[DealGaliInformation sharedInstance]showAlertWithMessage:msg withTitle:nil withCancelTitle:OK];
            }
            
        }];
    }
}

-(void)otpScreen{
    
    [self.minimalNotification dismiss];
    VerificationVC *verifyVC = [[DealGaliInformation sharedInstance]Storyboard:VERIFICATIONSTORYBOARD];
    [self.navigationController pushViewController:verifyVC animated:YES];
}

#pragma mark UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==self.phoneXT)
    {
        NSUInteger newLength = [self.phoneXT.text length] + [string length] - range.length;
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


-(void)textFieldDidEndEditing:(UITextField *)textField {
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneXT resignFirstResponder];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.phoneXT resignFirstResponder];
}
-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    
    //Mobile number validation
    NSString *phoneRegex =@"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";// @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    
    if((![phoneTest evaluateWithObject:self.phoneXT.text]) || (self.phoneXT.text.length!=10) || ([self.phoneXT.text isEqualToString:@""]&& [self.phoneXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.phoneXT becomeFirstResponder];
        [self showErrorWithMessage:Validmobile];
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:Validmobile withTitle:nil withCancelTitle:OK];
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
    [[DealGaliInformation sharedInstance]HideWaiting];
    // show
    [self performSelector:@selector(showSucessNotification) withObject:nil afterDelay:0.1];
}
-(void)showSucessNotification{
    [self.minimalNotification show];
    [self performSelector:@selector(otpScreen) withObject:nil afterDelay:2.0];
    
}


@end
