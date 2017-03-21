//
//  AppointmentViewController.m
//  DealGali
//
//  Created by Virinchi Software on 24/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import "AppointmentViewController.h"

@interface AppointmentViewController ()

@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Book an Appointment", nil);
    
    self.userNameLbl.textColor=[UIColor DGLightGrayColor];
    self.userNameLbl.font=[UIFont DGTextFieldFont];
    self.chooseLBL.textColor=[UIColor DGBlackColor];
    self.chooseLBL.font=[UIFont DGTextMediumFont];
    self.chooseLBL.text=CHOOSEMSG;
    self.contactInfoLbl.textColor=[UIColor DGBlackColor];
    self.contactInfoLbl.font=[UIFont DGTextMediumFont];
    self.contactInfoLbl.text=CONTACTMSG;
    self.lbl.textColor=[UIColor DGLightGrayColor];
    self.lbl.font=[UIFont DGTextViewFont];
    self.lbl.text=LBLMSG;
    self.writeTextView.textColor=[UIColor DGDarkGrayColor];
    self.writeTextView.font=[UIFont DGTextFieldFont];
    self.phoneTxt.textColor=[UIColor DGBlackColor];
    self.phoneTxt.font=[UIFont DGTextFieldFont];
    self.pickDateTXT.textColor=[UIColor DGBlackColor];
    self.pickDateTXT.font=[UIFont DGTextFieldFont];
    self.emailTXT.textColor=[UIColor DGBlackColor];
    self.emailTXT.font=[UIFont DGTextFieldFont];
    self.pickDate1TXT.textColor=[UIColor DGBlackColor];
    self.pickDate1TXT.font=[UIFont DGTextFieldFont];
    self.submitBtn.backgroundColor=[UIColor DGPurpleColor];
    self.submitBtn.titleLabel.font=[UIFont DGActionButtonFont];
    self.submitBtn.titleLabel.textColor=[UIColor DGWhiteColor];
    self.termBtn.titleLabel.textColor=[UIColor DGLightGrayColor];
    self.termBtn.titleLabel.font=[UIFont DGTextViewFont];
    
    
    
    self.submitBtn.backgroundColor=[UIColor DGLightGrayColor];
    active=NO;
    
    
    
    self.profileImgVw.layer.cornerRadius = self.imgVwHT.constant / 2;
    self.profileImgVw.layer.borderColor=[UIColor grayColor].CGColor;
    self.profileImgVw.layer.borderWidth=1.0;
    //  NSString *path = [[NSUserDefaults standardUserDefaults] stringForKey:@"ProfileImagePath"];
    
    if (_DealCompanyLogo.length==0) {
        NSString *path = [NSUSERDEFAULTS stringForKey:@"pathCompanyLogo"];
        [self.profileImgVw sd_setImageWithURL:[NSURL URLWithString:path]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        //self.profileImgVw.image=[UIImage imageNamed:@"profileImg"];
    }
    else{
        [self.profileImgVw sd_setImageWithURL:[NSURL URLWithString:_DealCompanyLogo]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        self.profileImgVw.contentMode = UIViewContentModeScaleAspectFill;
        self.profileImgVw.clipsToBounds = YES;
        
    }
    
    // NSString *savedValue1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    self.userNameLbl.text=_DealTitle;
    
    self.scrollview.userInteractionEnabled=YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollview addGestureRecognizer:recognizer];
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bckArr.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(previousecall)];
    UIBarButtonItem * revealButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]]];
    self.navigationItem.leftBarButtonItems = @[revealButtonItem,revealButtonItem1];
    
}
- (void)touch
{
    self.submitButtomCons.constant=5;
    if((self.writeTextView.text.length == 0) && [self.writeTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
        // [self viewWillAppear:YES];
    }
    [self.phoneTxt resignFirstResponder];
    [self.emailTXT resignFirstResponder];
    [self.writeTextView resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollview.contentInset = contentInsets;
    
}

-(void)previousecall{
    [[DealGaliInformation sharedInstance]HideWaiting];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.submitButtomCons.constant=0;
    self.writeTextView.text = WRITETEXTVIEW;
    self.writeTextView.textColor = [UIColor DGLightGrayColor];
    self.writeTextView.delegate = self;
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserMobileNumber"];
    // NSString *savedValue3 = [[NSUserDefaults standardUserDefaults] stringForKey:@"EmailId"];
    NSString *savedValue3 = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    
    self.phoneTxt.text=savedValue;
    self.emailTXT.text=savedValue3;
    [self registerForKeyboardNotifications];
    self.revealViewController.panGestureRecognizer.enabled=NO;
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.revealViewController.panGestureRecognizer.enabled=YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)termsNconditiosBtnAction:(id)sender {
    TermVC *tVC=[[DealGaliInformation sharedInstance]Storyboard:TERMVCSTORYBOARD];
    tVC.name=@"appointment";
    [self.navigationController pushViewController:tVC animated:YES];
    
}

- (IBAction)submitBtnAction:(id)sender {
    
    if (active) {
        BOOL isValid=[self CheckForValidation];
        if (isValid) {
            self.submitButtomCons.constant=5;
            
            [[DealGaliInformation sharedInstance]ShowWaiting:REQUESTINGAPPOINTMENT];
            // NSString *savedValue1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
            NSString *savedValue2 = [[NSUserDefaults standardUserDefaults] stringForKey:@"UniqueUserId"];
            NSString *savedValue4 = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
            if ([self.companyPage isEqualToString:@"company"]) {
                [[DealGaliNetworkEngine sharedInstance]SetAppointmentAPI:savedValue2 userName:self.emailTXT.text vendorId:self.CustomId dealId:@"" price:0 mobileNumber:self.phoneTxt.text deviceId:savedValue4 deviceType:@"ios" currentPageURL:self.currentPageURL email:@""  appointmentPaidStatus:false paymentMode:@"" fromTime:@"2014-11-12 11:14:15.638276 " toTime:@"2014-11-12 11:14:15.638276 " fromOperationDay:@"" toOperationDay:@"" date1:self.pickDateTXT.text date2:self.pickDate1TXT.text date3:@"" dateTime1:@"" dateTime2:@"" dateTime3:@"" message:self.writeTextView.text withCallback:^(NSDictionary *response) {
                    
                    NSString *status=[[response objectForKey:@"STATUS"]valueForKey:@"Status"];
                    NSString *msg=[[response objectForKey:@"STATUS"]valueForKey:@"Message"];
                    if ([status isEqualToString:@"0"]) {
                        [[DealGaliInformation sharedInstance]HideWaiting];
                        [self showErrorWithMessage:msg];
                        // [[DealGaliInformation sharedInstance]showAlertWithMessage:msg withTitle:nil withCancelTitle:OK];
                    }
                    else{
                        [[DealGaliInformation sharedInstance]HideWaiting];
                        [self showSucessWithMessage:APPOINTMENTSUCCESSFULLY];
                    }
                    
                }];
                
            }
            else{
                [[DealGaliNetworkEngine sharedInstance]SetAppointmentAPI:savedValue2 userName:self.emailTXT.text vendorId:@"" dealId:self.CustomId price:0 mobileNumber:self.phoneTxt.text deviceId:savedValue4 deviceType:@"ios" currentPageURL:self.currentPageURL email:@"" appointmentPaidStatus:false paymentMode:@"" fromTime:@"2014-11-12 11:14:15.638276 " toTime:@"2014-11-12 11:14:15.638276 " fromOperationDay:@"" toOperationDay:@"" date1:self.pickDateTXT.text date2:self.pickDate1TXT.text date3:@"" dateTime1:@"" dateTime2:@"" dateTime3:@"" message:self.writeTextView.text withCallback:^(NSDictionary *response) {
                    NSString *status=[[response objectForKey:@"STATUS"]valueForKey:@"Status"];
                    NSString *msg=[[response objectForKey:@"STATUS"]valueForKey:@"Message"];
                    if ([status isEqualToString:@"0"]) {
                        [[DealGaliInformation sharedInstance]HideWaiting];
                        [self showErrorWithMessage:msg];
                        //[[DealGaliInformation sharedInstance]showAlertWithMessage:msg withTitle:nil withCancelTitle:OK];
                    }
                    else{
                        [[DealGaliInformation sharedInstance]HideWaiting];
                        [self showSucessWithMessage:APPOINTMENTSUCCESSFULLY];
                    }
                }];
                
            }
            
        }
    }
}


#pragma mark UITextViewDelegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //    if([text isEqualToString:@"\n"]) {
    //        [textView resignFirstResponder];
    //        return NO;
    //    }
    
    return YES;
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 130.0, 0.0);
    self.scrollview.contentInset = contentInsets;
    
    
    if ([self.writeTextView.text isEqualToString:WRITETEXTVIEW]) {
        self.writeTextView.text = @"";
    }else
        self.writeTextView.text = textView.text;
    
    self.writeTextView.textColor = [UIColor DGBlackColor];
    
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if((self.writeTextView.text.length == 0) && [self.writeTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
        self.writeTextView.textColor = [UIColor lightGrayColor];
        self.writeTextView.text = WRITETEXTVIEW;
        [self.writeTextView resignFirstResponder];
    }
    else{
        self.submitBtn.backgroundColor=[UIColor DGPinkColor];
    }
    //    if((self.writeTextView.text.length == 0) && [self.writeTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
    //        // [self viewWillAppear:YES];
    //    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [self submitMethod];
    
}

#pragma mark UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField==self.pickDateTXT) {
        [self pickDateMethod];
    }
    else  if (textField==self.pickDate1TXT) {
        [self pickDate1Method];
    }
    //    else
    //    self.scrollview.contentOffset = CGPointMake(0, textField.frame.origin.y+30);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 130, 0.0);
    self.scrollview.contentInset = contentInsets;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField ==self.phoneTxt)
    {
        NSUInteger newLength = [self.phoneTxt.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.submitButtomCons.constant=5;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollview.contentInset = contentInsets;
    [textField resignFirstResponder];
    return YES;
}



-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self submitMethod];
    // self.scrollview.contentOffset = CGPointMake(0, 0);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [activeField resignFirstResponder];
}




-(void)goToHomePage{
    [self.minimalNotification dismiss];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)pickDateMethod{
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    datePicker.minuteInterval=30;
    [datePicker setMinimumDate: [NSDate date]];
    
    [self.pickDateTXT setInputView:datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    [toolBar setTintColor:[UIColor DGDarkGrayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.pickDateTXT setInputAccessoryView:toolBar];
    
}
-(void)pickDate1Method{
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    datePicker.minuteInterval=30;
    [datePicker setMinimumDate: [NSDate date]];
    
    [self.pickDate1TXT setInputView:datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    [toolBar setTintColor:[UIColor DGDarkGrayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate1)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.pickDate1TXT setInputAccessoryView:toolBar];
    
}
-(void)ShowSelectedDate
{
    
    self.submitButtomCons.constant=5;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm a"];
    
    self.pickDateTXT.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.pickDateTXT resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollview.contentInset = contentInsets;
}
-(void)ShowSelectedDate1
{
    self.submitButtomCons.constant=5;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm a"];
    
    self.pickDate1TXT.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    
    [self.pickDate1TXT resignFirstResponder];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.scrollview.contentInset = contentInsets;
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
    [self ensureVisible:self.writeTextView withPrevious:NO];
    
    
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
    CGRect bounds = self.scrollview.bounds;
    
    CGPoint textFieldOrigin = [self.scrollview convertPoint:textField.frame.origin fromView:self.writeTextView];
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
    
    if (slideValue < 0){
        [self slideWithYValue:-30.0];
    }
    
}


- (void)resetVisibleRect
{
    [self slideWithYValue:70.0];
}

- (void)slideWithYValue:(float)value
{
    CGRect bounds = self.scrollview.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        [self.view setFrame:CGRectMake(0, value, bounds.size.width, bounds.size.height)];
    else
        [self.view setFrame:CGRectMake(value, 0, bounds.size.width, bounds.size.height)];
    [UIView commitAnimations];
}

-(void)submitMethod{
    if (self.pickDateTXT.hasText) {
        self.submitBtn.backgroundColor=[UIColor DGPinkColor];
        active=YES;
    }
    else{
        self.submitBtn.backgroundColor=[UIColor DGLightGrayColor];
        
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:@"Please enter all fields" withTitle:nil withCancelTitle:OK];
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
    
    
    
    if(([self.pickDateTXT.text isEqualToString:@""]&& [self.pickDateTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])){
        valid = NO;
        [self.pickDateTXT becomeFirstResponder];
        [self showErrorWithMessage:PICKTIME];
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:PICKTIME withTitle:nil withCancelTitle:OK];
    }
    
    
    
    // else if([self.emailTXT.text length]>0){
    else if([self.emailTXT.text isEqualToString:@""]&& [self.emailTXT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]){
        valid = NO;
        [self.emailTXT becomeFirstResponder];
        self.submitButtomCons.constant=0;
        [self showErrorWithMessage:Enterusername];
        
        // [[DealGaliInformation sharedInstance]showAlertWithMessage:VALIDEMAIL withTitle:nil withCancelTitle:OK];
        
    }
    //else if([self.phoneTxt.text length]>0){
    else if((![phoneTest evaluateWithObject:self.phoneTxt.text]) || (self.phoneTxt.text.length!=10) || ([self.phoneTxt.text isEqualToString:@""]&& [self.phoneTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        valid = NO;
        self.submitButtomCons.constant=0;
        [self showErrorWithMessage:Validmobile];
        
        //  [[DealGaliInformation sharedInstance]showAlertWithMessage:Validmobile withTitle:nil withCancelTitle:OK];
    }
    
    // }
    
    
    
    
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
    self.submitButtomCons.constant=0;
    [self performSelector:@selector(goToHomePage) withObject:nil afterDelay:2.0];
    
}




@end
