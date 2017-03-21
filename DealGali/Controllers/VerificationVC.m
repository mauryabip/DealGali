//
//  VerificationVC.m
//  DealGali
//
//  Created by Virinchi Software on 27/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "VerificationVC.h"
#import "SavePasswordVC.h"
#import "DealGaliNetworkEngine.h"
#import "DealGaliInformation.h"

@interface VerificationVC ()

@end

@implementation VerificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //setting for font and color
    self.verificationTXT.textColor=[UIColor DGBlackColor];
    self.verificationTXT.font=[UIFont DGTextFieldFont];
    self.verifyLbl.textColor=[UIColor DGLightGrayColor];
    self.verifyLbl.font=[UIFont DGTextFieldFont];
    self.verifyBtn.backgroundColor=[UIColor DGPinkColor];
    self.verifyBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.verifyBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    self.reenter.backgroundColor=[UIColor DGLightGrayColor];
    self.reenter.titleLabel.font=[UIFont DGActionButtonFont];
    self.reenter.titleLabel.textColor=[UIColor DGWhiteColor];
    
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
    
    
    self.scrollView.contentSize = self.view.frame.size;
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
}
-(void)previousecall{
    [self.navigationController popViewControllerAnimated:YES];
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.revealViewController.panGestureRecognizer.enabled=NO;
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"MobileNumber"];
    NSString *str=[NSString stringWithFormat:@"%@ %@",SENDVERIFICATIONCODEMO,savedValue];
    self.verifyLbl.text=str;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}

- (IBAction)reenterAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)verifyAction:(id)sender {
    if (self.verificationTXT.hasText) {
        [[DealGaliInformation sharedInstance]ShowWaiting:Verifying];
        NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"MobileNumber"];
        [[DealGaliNetworkEngine sharedInstance] verificationBasedOnMoNoAPI:savedValue VerificationCode:self.verificationTXT.text withCallback:^(NSDictionary *response) {
            NSString *str=[response objectForKey:@"Status"];
            NSString *msg=[response objectForKey:@"Message"];
            if (![str isEqualToString:@"2"]) {
                [[DealGaliInformation sharedInstance]HideWaiting];
                
                [self showSucessWithMessage:OTPVERIFIEDSUCCESSFULLY];
            }
            else{
                [[DealGaliInformation sharedInstance]HideWaiting];
                [self showErrorWithMessage:msg];
            }
            
        }];
    }
    else{
        [self showErrorWithMessage:EnterVerification];
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:EnterVerification withTitle:nil withCancelTitle:OK];
    }
    
    
}
-(void)savePasswordScreen{
    [self.minimalNotification dismiss];
    SavePasswordVC *saveVC = [[DealGaliInformation sharedInstance]Storyboard:SAVEPASSWORDSTORYBOARD];
    [self.navigationController pushViewController:saveVC animated:YES];
}

#pragma mark UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 216, 0.0);
    self.scrollView.contentInset = contentInsets;
    //self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y+30);
    
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
    [self.verificationTXT resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
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
    [self performSelector:@selector(savePasswordScreen) withObject:nil afterDelay:2.0];
    
}

@end
