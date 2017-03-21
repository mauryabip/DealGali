//
//  SignUPWithFaceBookVC.h
//  DealGali
//
//  Created by Virinchi Software on 02/07/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "VerifySignUpVC.h"
#import "JFMinimalNotification.h"


@interface SignUPWithFaceBookVC : UIViewController<JFMinimalNotificationDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,SWRevealViewControllerDelegate>{
    UITextField* activeField;
    NSDictionary *dic;
    NSDictionary *dic1;
    
    UIDatePicker *datePicker;
    
}
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic)  NSString *name;
- (IBAction)closeAction:(id)sender;


- (IBAction)signUpBTNaction:(id)sender;
- (IBAction)termsNconditionsBtnAction:(id)sender;
- (IBAction)checkBoxBtnAction:(UIButton*)sender;

@property (strong, nonatomic) SWRevealViewController *viewController;


@property (weak, nonatomic) IBOutlet UITextField *emailTXT;
@property (weak, nonatomic) IBOutlet UITextField *phoneTXT;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *dobTXT;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *termBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end
