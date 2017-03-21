//
//  ResetPasswordVC.m
//  DealGali
//
//  Created by Virinchi Software on 21/07/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "ResetPasswordVC.h"

@interface ResetPasswordVC ()

@end

@implementation ResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting for font and color
    //setting for font and color
    self.neWPassTXT.textColor=[UIColor DGBlackColor];
    self.neWPassTXT.font=[UIFont DGTextFieldFont];
    self.retypePassTXT.textColor=[UIColor DGBlackColor];
    self.retypePassTXT.font=[UIFont DGTextFieldFont];
    self.currentPassTXT.textColor=[UIColor DGBlackColor];
    self.currentPassTXT.font=[UIFont DGTextFieldFont];
    self.updatePassBtn.backgroundColor=[UIColor DGLightGrayColor];
    self.updatePassBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.updatePassBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    active=NO;
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
    // Do any additional setup after loading the view.
}
-(void)previousecall{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.profileImgView.layer.cornerRadius = self.imgVwHT.constant / 2;
    self.profileImgView.layer.borderColor=[UIColor DGLightGrayColor].CGColor;
    self.profileImgView.layer.borderWidth=1.0;
    NSString *PROFILE = [NSUSERDEFAULTS stringForKey:@"PROFILE"];
    
    if ([PROFILE isEqualToString:@"PROFILE"]) {
        NSData *imgData = [[NSUserDefaults standardUserDefaults] dataForKey:@"ProfileImage"];
        UIImage *image = [[UIImage alloc]initWithData:imgData];
        
        if (image==nil) {
            
            NSString *path = [NSUSERDEFAULTS stringForKey:@"ProfileImagePath"];
            
            if (path.length==0) {
                NSString *path = [NSUSERDEFAULTS stringForKey:@"pathUserProfile"];
                [self.profileImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                //self.profileImgView.image=[UIImage imageNamed:@"profileImg"];
            }
            else{
                [self.profileImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                NSData *imageData = UIImagePNGRepresentation(self.profileImgView.image);
                
                [NSUSERDEFAULTS setObject:imageData forKey:@"ProfileImage"];
                [NSUSERDEFAULTS synchronize];
            }
        }
        else
            self.profileImgView.image=image;
        
    }
    else{
        NSString *path = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileImagePath"];
        if (path.length==0) {
            NSString *path = [NSUSERDEFAULTS stringForKey:@"pathUserProfile"];
            [self.profileImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            // self.profileImgView.image=[UIImage imageNamed:@"profileImg"];
        }
        else{
            [self.profileImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            
        }
    }
    self.profileImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImgView.clipsToBounds = YES;
    
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
-(IBAction)updateAction:(id)sender{
    if (active) {
        BOOL isValid=[self CheckForValidation];
        if (isValid){
            
            self.currentPassTXT.text = [self.currentPassTXT.text stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            self.currentPassTXT.text = [self.currentPassTXT.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            self.neWPassTXT.text = [self.neWPassTXT.text stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            self.neWPassTXT.text = [self.neWPassTXT.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            self.retypePassTXT.text = [self.retypePassTXT.text stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            self.retypePassTXT.text = [self.retypePassTXT.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            if ([self.neWPassTXT.text isEqualToString:self.retypePassTXT.text]) {
                [[DealGaliInformation sharedInstance]ShowWaiting:SavingPassword];
                NSString *UniqueUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
                [[DealGaliNetworkEngine sharedInstance] ResetPasswordAPI:UniqueUserId CurrentPassword:self.currentPassTXT.text NewPassword:self.neWPassTXT.text withCallback:^(NSDictionary *response) {
                    dic=[response objectForKey:@"ResetPasswordStatus"];
                    NSString *str=[dic objectForKey:@"Status"];
                    NSString *msg=[dic objectForKey:@"Message"];
                    if ([str isEqualToString:@"1"]) {
                        [[DealGaliInformation sharedInstance]HideWaiting];
                        [self showSucessWithMessage:PASSWORDUPDATEDSUCCESSFULLY];
                    }
                    else{
                        [[DealGaliInformation sharedInstance]HideWaiting];
                        [self showErrorWithMessage:msg];
                    }
                }];
            }
            else{
                [[DealGaliInformation sharedInstance]HideWaiting];
                
                [self showErrorWithMessage:MatchNewRetypePassword];
            }
        }
    }
}


-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    
    
    if(([self.currentPassTXT.text isEqualToString:@""]&& [self.currentPassTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])){
        valid = NO;
        [self.currentPassTXT becomeFirstResponder];
        [self showErrorWithMessage:CURREENTPASS];
    }
    
    else if(([self.neWPassTXT.text isEqualToString:@""]&& [self.neWPassTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])){
        valid = NO;
        [self.neWPassTXT becomeFirstResponder];
        [self showErrorWithMessage:ENTERNEWPASS];
    }
    
    else if([self.neWPassTXT.text length]<3){
        valid = NO;
        [self.neWPassTXT becomeFirstResponder];
        [self showErrorWithMessage:EnterPasswordValidation];
    }
    
    else if(([self.retypePassTXT.text isEqualToString:@""]&& [self.retypePassTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])){
        valid = NO;
        [self.retypePassTXT becomeFirstResponder];
        [self showErrorWithMessage:ENTERRETYPEPASS];
    }
    
    
    return valid;
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
    [self submitMethod];
    //self.scrollView.contentOffset = CGPointMake(0, 0);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [activeField resignFirstResponder];
    
}
-(void)submitMethod{
    if (self.currentPassTXT.hasText && self.neWPassTXT.hasText && self.retypePassTXT.hasText) {
        self.updatePassBtn.backgroundColor=[UIColor DGPinkColor];
        active=YES;
    }
    else{
        self.updatePassBtn.backgroundColor=[UIColor DGLightGrayColor];
        
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:@"Please enter all fields" withTitle:nil withCancelTitle:OK];
        active=NO;
    }
    
}


-(void)touch{
    [self.currentPassTXT resignFirstResponder];
    [self.neWPassTXT resignFirstResponder];
    [self.retypePassTXT resignFirstResponder];
    
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
    [self performSelector:@selector(updatedProfile) withObject:nil afterDelay:2.0];
    
}
-(void)updatedProfile{
    [self.minimalNotification dismiss];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
