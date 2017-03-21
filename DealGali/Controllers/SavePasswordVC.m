//
//  SavePasswordVC.m
//  DealGali
//
//  Created by Virinchi Software on 27/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "SavePasswordVC.h"
#import "LoginViewController.h"
#import "DealGaliInformation.h"

@interface SavePasswordVC ()

@end

@implementation SavePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting for font and color
    self.neWPassTXT.textColor=[UIColor DGBlackColor];
    self.neWPassTXT.font=[UIFont DGTextFieldFont];
    self.retypePassTXT.textColor=[UIColor DGBlackColor];
    self.retypePassTXT.font=[UIFont DGTextFieldFont];
    self.updateBtn.backgroundColor=[UIColor DGPinkColor];
    self.updateBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.updateBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"] style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
-(void)previousecall{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled=NO;
    
    
}

- (IBAction)updateAction:(id)sender {
    
    BOOL isvalid=[self CheckForValidation];
    if (isvalid) {
        
        self.neWPassTXT.text = [self.neWPassTXT.text stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        self.neWPassTXT.text = [self.neWPassTXT.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        self.retypePassTXT.text = [self.retypePassTXT.text stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        self.retypePassTXT.text = [self.retypePassTXT.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        if ([self.neWPassTXT.text isEqualToString:self.retypePassTXT.text]) {
            [[DealGaliInformation sharedInstance]ShowWaiting:SavingPassword];
            NSString *savedValue = [NSUSERDEFAULTS stringForKey:@"MobileNumber"];
            [[DealGaliNetworkEngine sharedInstance] setPaaswordAPI:savedValue NewPassword:self.neWPassTXT.text withCallback:^(NSDictionary *response) {
                dic=[response objectForKey:@"SetPasswordStatus"];
                NSString *str=[dic objectForKey:@"Status"];
                NSString *msg=[dic objectForKey:@"Message"];
                if ([str isEqualToString:@"1"]) {
                    // [[DealGaliInformation sharedInstance]HideWaiting];
                    UIDevice *device = [UIDevice currentDevice];
                    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
                    [NSUSERDEFAULTS setObject:currentDeviceId forKey:@"DeviceID"];
                    [NSUSERDEFAULTS synchronize];
                    
                    [[DealGaliInformation sharedInstance]HideWaiting];
                    [self showSucessWithMessage:PASSWORDSAVEDSUCCESSFULLY];
                    
                }
                else{
                    [[DealGaliInformation sharedInstance]HideWaiting];
                    [self showErrorWithMessage:msg];
                }
            }];
            
        }
        else{
            [[DealGaliInformation sharedInstance]HideWaiting];
            [self showErrorWithMessage:MatchPassword];
        }
    }
}


-(void)savePassScreen{
    [self.minimalNotification dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    self.scrollView.contentInset = contentInsets;
    // self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y+30);
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
    if (textField==self.retypePassTXT) {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.scrollView.contentInset = contentInsets;
    }
}
-(void)touch{
    [self.retypePassTXT resignFirstResponder];
    [self.neWPassTXT resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
}



-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    
    
    if(([self.neWPassTXT.text isEqualToString:@""]&& [self.neWPassTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.neWPassTXT becomeFirstResponder];
        [self showErrorWithMessage:EnterNewPass];
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:Enterusername withTitle:nil withCancelTitle:OK];
    }
    else if([self.neWPassTXT.text length]<3)
    {
        valid = NO;
        [self.neWPassTXT becomeFirstResponder];
        [self showErrorWithMessage:EnterPasswordValidation];
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:Validmobile withTitle:nil withCancelTitle:OK];
    }
    
    else
    {
        if(([self.retypePassTXT.text isEqualToString:@""]&& [self.retypePassTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
        {
            valid = NO;
            [self.retypePassTXT becomeFirstResponder];
            [self showErrorWithMessage:EnterRetyprPass];
            // [[DealGaliInformation sharedInstance]showAlertWithMessage:Enterusername withTitle:nil withCancelTitle:OK];
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
    [self performSelector:@selector(savePassScreen) withObject:nil afterDelay:2.0];
    
}



@end
