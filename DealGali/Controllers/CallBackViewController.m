//
//  CallBackViewController.m
//  DealGali
//
//  Created by Virinchi Software on 21/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "CallBackViewController.h"
#import "DealGaliNetworkEngine.h"

@interface CallBackViewController ()

@end

@implementation CallBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reQuestLbl.textColor=[UIColor DGBlackColor];
    self.reQuestLbl.font=[UIFont DGTextMediumFont];
    self.reQuestLbl.text=REQUESTFORCALLBACK;
    self.writeTXT.textColor=[UIColor DGDarkGrayColor];
    self.writeTXT.font=[UIFont DGLocalNotiFont];
    self.nameLbl.textColor=[UIColor DGLightGrayColor];
    self.nameLbl.font=[UIFont DGTextFieldFont];
    self.submitBtn.backgroundColor=[UIColor DGLightGrayColor];
    self.submitBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.submitBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    
    self.writeTXT.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.writeTXT.layer.borderWidth=0.5f;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
    
    self.profileImageView.layer.cornerRadius = self.imgVwHT.constant / 2;
    self.profileImageView.layer.borderColor=[UIColor grayColor].CGColor;
    self.profileImageView.layer.borderWidth=1.0;
    
    // NSString *path = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileImagePath"];
    
    if (_DealCompanyLogo.length==0) {
        NSString *path = [NSUSERDEFAULTS stringForKey:@"pathCompanyLogo"];
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:path]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        //self.profileImageView.image=[UIImage imageNamed:@"profileImg"];
    }
    else{
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:_DealCompanyLogo]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.profileImageView.clipsToBounds = YES;
        
    }
    
    
    
    // Do any additional setup after loading the view.
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
    
    self.writeTXT.text = WriteMSG;
    self.writeTXT.textColor = [UIColor DGLightGrayColor];
    self.writeTXT.delegate = self;
    
    //NSString *savedValue1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    self.nameLbl.text=_DealTitle;
    [self registerForKeyboardNotifications];
    self.revealViewController.panGestureRecognizer.enabled=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //    if([text isEqualToString:@"\n"]) {
    //        [textView resignFirstResponder];
    //        return NO;
    //    }
    
    return YES;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.writeTXT.text isEqualToString:WriteMSG]) {
        self.writeTXT.text = @"";
    }else
        self.writeTXT.text = textView.text;
    
    self.writeTXT.textColor = [UIColor DGBlackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    //    if((self.writeTXT.text.length == 0) && [self.writeTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
    ////        self.writeTXT.textColor = [UIColor DGLightGrayColor];
    ////        self.writeTXT.text = WriteMSG;
    //        self.submitBtn.backgroundColor=[UIColor DGLightGrayColor];
    //       // [self.writeTXT resignFirstResponder];
    //       // [self viewWillAppear:YES];
    //    }
    //    else{
    //        self.submitBtn.backgroundColor=[UIColor DGPinkColor];
    //    }
    
    if((self.writeTXT.text.length == 0) && [self.writeTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
        self.writeTXT.textColor = [UIColor lightGrayColor];
        self.writeTXT.text = WriteMSG;
        [self.writeTXT resignFirstResponder];
        self.submitBtn.backgroundColor=[UIColor DGLightGrayColor];
    }
    else{
        self.submitBtn.backgroundColor=[UIColor DGPinkColor];
    }
    
    
}


- (IBAction)submitBtnAction:(id)sender {
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserMobileNumber"];
    NSString *savedValue1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    NSString *savedValue2 = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
    NSString *savedValue3 = [[NSUserDefaults standardUserDefaults] stringForKey:@"EmailId"];
    NSString *savedValue4 = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    if (!self.writeTXT.hasText || [self.writeTXT.text isEqualToString:WriteMSG]) {
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:MSG withTitle:nil withCancelTitle:OK];
    }else{
        if ([self.companyPage isEqualToString:@"companyPage"]) {
            [[DealGaliInformation sharedInstance]ShowWaiting:REQUESTING];
            
            [[DealGaliNetworkEngine sharedInstance]SetCallBack:savedValue2 dealId:@"" vendorId:_CustomId Type:@"1" deviceId:savedValue4 deviceType:@"ios" currentPageURL:_currentPageURL userName:savedValue1 mobileNo:savedValue email:savedValue3 message:self.writeTXT.text withCallback:^(NSDictionary *response) {
                
                [[DealGaliInformation sharedInstance]HideWaiting];
                [self showSucessWithMessage:CALLBACKREQUIREMENTSUCCESSFULLY];
            }];
        }
        else{
            [[DealGaliInformation sharedInstance]ShowWaiting:REQUESTING];
            
            [[DealGaliNetworkEngine sharedInstance]SetCallBack:savedValue2 dealId:_CustomId vendorId:@"" Type:@"2" deviceId:savedValue4 deviceType:@"ios" currentPageURL:_currentPageURL userName:savedValue1 mobileNo:savedValue email:savedValue3 message:self.writeTXT.text withCallback:^(NSDictionary *response) {
                
                [[DealGaliInformation sharedInstance]HideWaiting];
                [self showSucessWithMessage:CALLBACKREQUIREMENTSUCCESSFULLY];
            }];
        }
    }
    
}

#pragma mark - Keyboard, textfield management

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //self.errorLabel.text = @"";
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Ensure that active text field is visible
    [self ensureVisible:activeField withPrevious:NO];
    
    
    keyboardVisible = YES;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Reset view
    [self resetVisibleRect];
    
    keyboardVisible = NO;
}


#pragma mark - TextField scrolling helpers

- (void)ensureVisible:(UITextView*)textField withPrevious:(BOOL)previous
{
    CGRect bounds = self.view.bounds;
    
    CGPoint textFieldOrigin = [self.view convertPoint:textField.frame.origin fromView:self.writeTXT];
    CGSize textFieldSize = textField.bounds.size;
    
    CGFloat slideValue = 90.0;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        if (previous) {
            //slideValue = bounds.size.height + keyboardSize.height + textFieldSize.height + textFieldOrigin.y;
        } else {
            slideValue = bounds.size.height - keyboardSize.height - textFieldSize.height - textFieldOrigin.y;
        }
        else
            slideValue = bounds.size.height - keyboardSize.width - textFieldSize.height - textFieldOrigin.y;
    
    if (slideValue > 0){
        [self slideWithYValue:-10.0];
    }
    
}


- (void)resetVisibleRect
{
    [self slideWithYValue:70.0];
}

- (void)slideWithYValue:(float)value
{
    CGRect bounds = self.view.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        [self.view setFrame:CGRectMake(0, value, bounds.size.width, bounds.size.height)];
    else
        [self.view setFrame:CGRectMake(value, 0, bounds.size.width, bounds.size.height)];
    [UIView commitAnimations];
}
-(void)touch{
    if((self.writeTXT.text.length == 0) && [self.writeTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
        // [self viewWillAppear:YES];
    }
    
    [self.writeTXT resignFirstResponder];
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
    [self performSelector:@selector(callBackMethod) withObject:nil afterDelay:2.0];
    
}
-(void)callBackMethod{
    [self.minimalNotification dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
