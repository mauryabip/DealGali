//
//  PostRequirementViewController.m
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "PostRequirementViewController.h"

@interface PostRequirementViewController ()

@end

@implementation PostRequirementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //self.title = NSLocalizedString(@"Post Requirement", nil);
    
    // Do any additional setup after loading the view.
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(myMethod)];
    
    
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)previousecall{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)myMethod{
    [[[self revealViewController] view] endEditing:YES];
    // [self.view endEditing:YES];
    SWRevealViewController *reveal = self.revealViewController;
    [reveal revealToggleAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    //setting font and color
    self.nameLbl.textColor=[UIColor DGLightGrayColor];
    self.nameLbl.font=[UIFont DGTextFieldFont];
    self.lbl.textColor=[UIColor DGBlackColor];
    self.lbl.font=[UIFont DGTextMediumFont];
    self.lbl.text=POSTLBL;
    self.writeRequirementTxt.textColor=[UIColor DGDarkGrayColor];
    self.writeRequirementTxt.font=[UIFont DGTextFieldFont];
    self.mobileNoTXT.textColor=[UIColor DGBlackColor];
    self.mobileNoTXT.font=[UIFont DGTextFieldFont];
    self.nameTXT.textColor=[UIColor DGBlackColor];
    self.nameTXT.font=[UIFont DGTextFieldFont];
    self.emailIDTXT.textColor=[UIColor DGBlackColor];
    self.emailIDTXT.font=[UIFont DGTextFieldFont];
    self.postBtn.backgroundColor=[UIColor DGLightGrayColor];
    self.postBtn.titleLabel.font=[UIFont DGActionButtonFont];
    
    
    
    self.scrollView.userInteractionEnabled=YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
    
    
    self.profileImgView.layer.cornerRadius = self.imgVwHT.constant / 2;
    self.profileImgView.layer.borderColor=[UIColor DGLightGrayColor].CGColor;
    self.profileImgView.layer.borderWidth=1.0;
    self.profileImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImgView.clipsToBounds = YES;
    
    NSString *PROFILE = [NSUSERDEFAULTS stringForKey:@"PROFILE"];
    
    if ([PROFILE isEqualToString:@"PROFILE"]) {
        NSString *path = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileImagePath"];
        NSData *imgData = [[NSUserDefaults standardUserDefaults] dataForKey:@"ProfileImage"];
        UIImage *image = [[UIImage alloc]initWithData:imgData];
        
        if (image==nil) {
            
            if (path.length==0) {
                NSString *path = [NSUSERDEFAULTS stringForKey:@"pathUserProfile"];
                [self.profileImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                // self.profileImgView.image=[UIImage imageNamed:@"profileImg"];
            }
            else{
                [self.profileImgView sd_setImageWithURL:[NSURL URLWithString:path]
                                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                self.profileImgView.contentMode = UIViewContentModeScaleAspectFill;
                self.profileImgView.clipsToBounds = YES;
                NSData *imageData = UIImagePNGRepresentation(self.profileImgView.image);
                
                [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"ProfileImage"];
                [[NSUserDefaults standardUserDefaults]synchronize];
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
            self.profileImgView.contentMode = UIViewContentModeScaleAspectFill;
            self.profileImgView.clipsToBounds = YES;
            
        }
        
    }
    
    
    self.writeRequirementTxt.text = POSTWRITEMSG;
    self.writeRequirementTxt.textColor = [UIColor DGLightGrayColor];
    self.writeRequirementTxt.delegate = self;
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    NSString *savedValue1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserMobileNumber"];
    NSString *savedValue2 = [[NSUserDefaults standardUserDefaults] stringForKey:@"EmailId"];
    self.nameLbl.text=savedValue;
    self.nameTXT.text=savedValue;
    self.emailIDTXT.text=savedValue2;
    self.mobileNoTXT.text=savedValue1;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//
//    if([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//
//    return YES;
//}
- (IBAction)saveBtnAction:(id)sender {
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    if (active) {
        BOOL isValid=[self CheckForValidation];
        if (isValid) {
            [[DealGaliInformation sharedInstance]ShowWaiting:REQUESTING];
            [[DealGaliNetworkEngine sharedInstance]postRequirementAPI:self.nameTXT.text EmailId:self.emailIDTXT.text MobileNumber:self.mobileNoTXT.text Message:self.writeRequirementTxt.text deviceId:savedValue deviceType:@"ios" withCallback:^(NSDictionary *response) {
                NSString *status=[response valueForKey:@"Status"];
                NSString *msg=[response valueForKey:@"Message"];
                if ([status isEqualToString:@"2"]) {
                    [[DealGaliInformation sharedInstance]HideWaiting];
                    [self showErrorWithMessage:msg];
                }
                else{
                    [[DealGaliInformation sharedInstance]HideWaiting];
                    [self showSucessWithMessage:POSTEDREQUIREMENTSUCCESSFULLY];
                    //                self.writeRequirementTxt.text=@"";
                    //                active=NO;
                    //                self.postBtn.backgroundColor=[UIColor DGLightGrayColor];
                    
                }
            }];
            
        }
    }
}

#pragma mark UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 260, 0.0);
    self.scrollView.contentInset = contentInsets;
    //self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y+20);
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==self.mobileNoTXT)
    {
        NSUInteger newLength = [self.mobileNoTXT.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    
    //    if([string isEqualToString:@"\n"]) {
    //        [textField resignFirstResponder];
    //        return NO;
    //    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self postMethod];
    // self.scrollView.contentOffset = CGPointMake(0, 0);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [activeField resignFirstResponder];
}

#pragma mark UITextViewDelegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.scrollView.contentOffset = CGPointMake(0, 130);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 230.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [self postMethod];
    
    return YES;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    
    [textView setEnablesReturnKeyAutomatically:YES];
    
    if ([self.writeRequirementTxt.text isEqualToString:POSTWRITEMSG]) {
        self.writeRequirementTxt.text = @"";
    }else
        self.writeRequirementTxt.text = textView.text;
    
    self.writeRequirementTxt.textColor = [UIColor DGBlackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if((self.writeRequirementTxt.text.length == 0) && [self.writeRequirementTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
        // [self viewWillAppear:YES];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self postMethod];
    // self.scrollView.contentOffset = CGPointMake(0, 0);
}


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImgView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)touch
{
    if((self.writeRequirementTxt.text.length == 0) && [self.writeRequirementTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
        //[self viewWillAppear:YES];
    }
    
    [self.mobileNoTXT resignFirstResponder];
    [self.emailIDTXT resignFirstResponder];
    [self.nameTXT resignFirstResponder];
    [self.writeRequirementTxt resignFirstResponder];
    self.scrollView.contentOffset = CGPointMake(0, 0);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    
}
-(void)postMethod{
    
    
    if ([self.writeRequirementTxt.text length]==0 && (![self.writeRequirementTxt.text isEqualToString:POSTWRITEMSG]) && [self.writeRequirementTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]) {
        self.postBtn.backgroundColor=[UIColor DGPinkColor];
        active=YES;
    }
    else{
        self.postBtn.backgroundColor=[UIColor DGLightGrayColor];
        active=NO;
    }
    
}


-(BOOL)CheckForValidation
{
    BOOL valid=YES;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z]+\\.[A-Za-z]{2,4}"];
    
    //Mobile number validation
    NSString *phoneRegex =@"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";// @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    
    
    if(([self.nameTXT.text isEqualToString:@""]&& [self.nameTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.nameTXT becomeFirstResponder];
        [self showErrorWithMessage:Enterusername];
        //[[DealGaliInformation sharedInstance]showAlertWithMessage:Enterusername withTitle:nil withCancelTitle:OK];
    }
    else if((![phoneTest evaluateWithObject:self.mobileNoTXT.text]) || (self.mobileNoTXT.text.length!=10) || ([self.mobileNoTXT.text isEqualToString:@""]&& [self.mobileNoTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        [self.mobileNoTXT becomeFirstResponder];
        [self showErrorWithMessage:Validmobile];
        //[[DealGaliInformation sharedInstance]showAlertWithMessage:Validmobile withTitle:nil withCancelTitle:OK];
    }
    
    else if(self.emailIDTXT.text.length>0){
        if(![emailTest evaluateWithObject:self.emailIDTXT.text]){
            valid = NO;
            [self showErrorWithMessage:VALIDEMAIL];
            //[[DealGaliInformation sharedInstance]showAlertWithMessage:VALIDEMAIL withTitle:nil withCancelTitle:OK];
        }
    }
    else
        if(([self.writeRequirementTxt.text isEqualToString:@""]&& [self.writeRequirementTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] && [self.writeRequirementTxt.text isEqualToString:POSTWRITEMSG]))
        {
            valid = NO;
            [self.writeRequirementTxt becomeFirstResponder];
            [self showErrorWithMessage:MSG];
            //[[DealGaliInformation sharedInstance]showAlertWithMessage:MSG withTitle:nil withCancelTitle:OK];
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
    [self performSelector:@selector(postedRequirement) withObject:nil afterDelay:2.0];
    
}
-(void)postedRequirement{
    [self.minimalNotification dismiss];
    UIViewController *Roottocontroller;
    HomeViewController *homeViewController = [[DealGaliInformation sharedInstance]Storyboard:HOMESTORYBOARDID];
    
    Roottocontroller=homeViewController;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:Roottocontroller];
    [navController setViewControllers: @[Roottocontroller] animated: YES];
    
    [navController setViewControllers: @[Roottocontroller] animated: YES];
    
    [self.revealViewController setFrontViewController:navController];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
    
}



@end
