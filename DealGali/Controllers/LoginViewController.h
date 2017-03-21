//
//  LoginViewController.h
//  DealGali
//
//  Created by Virinchi Software on 18/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DealGaliNetworkEngine.h"
#import "DealGaliInformation.h"
#import "HomeViewController.h"
#import "SignUpViewController.h"
#import "ForgotPasswordVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Google/SignIn.h>
#import "JFMinimalNotification.h"


@interface LoginViewController : UIViewController<JFMinimalNotificationDelegate,SWRevealViewControllerDelegate,UITextFieldDelegate,FBLoginViewDelegate,GIDSignInUIDelegate,GIDSignInDelegate>{
    
    UITextField* activeField;
    NSDictionary *dic;
    NSDictionary *dic1;
}

@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@property (weak, nonatomic) IBOutlet UIButton *gPlusBtn;

@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UIView *seperator;
@property (weak, nonatomic) IBOutlet UIView *seperator1;

@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *signinBtn;

- (IBAction)loginBtnAction:(id)sender;
- (IBAction)forgotBtnAction:(id)sender;
- (IBAction)signUpBtnAction:(id)sender;
@property (strong, nonatomic) SWRevealViewController *viewController;


@property (strong, nonatomic) IBOutlet UITextField *phoneTXT;
@property (strong, nonatomic) IBOutlet UITextField *passwordTXT;



- (IBAction)loginWithFacebookBtnAction:(id)sender;
- (IBAction)loginWithGoogleBtnAction:(id)sender;
- (IBAction)showhideBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *showhideBtn;



@end
