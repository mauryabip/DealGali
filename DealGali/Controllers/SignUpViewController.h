//
//  SignUpViewController.h
//  DealGali
//
//  Created by Virinchi Software on 18/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JFMinimalNotification.h"



@interface SignUpViewController : UIViewController<JFMinimalNotificationDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    UITextField* activeField;
    NSDictionary *dic;
    NSDictionary *dic1;
    
}
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)closeAction:(id)sender;

- (IBAction)signInBtnAction:(id)sender;
- (IBAction)signUpBTNaction:(id)sender;
- (IBAction)termsNconditionsBtnAction:(id)sender;
- (IBAction)checkBoxBtnAction:(UIButton*)sender;
@property (weak, nonatomic) IBOutlet UIButton *signup;

@property (weak, nonatomic) IBOutlet UIButton *signinBtn;
@property (weak, nonatomic) IBOutlet UILabel *alreadyAccLbl;
@property (weak, nonatomic) IBOutlet UIButton *termBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *emailTXT;
@property (weak, nonatomic) IBOutlet UITextField *phoneTXT;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *dobTXT;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end
