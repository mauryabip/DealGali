//
//  VerifySignUpVC.h
//  DealGali
//
//  Created by Virinchi Software on 27/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JFMinimalNotification.h"


@interface VerifySignUpVC : UIViewController<JFMinimalNotificationDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIScrollViewDelegate,SWRevealViewControllerDelegate>{
    UITextField *activeField ;
    NSDictionary *dic1;

}
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;
@property (nonatomic, strong) NSString *controllerName;

@property (strong, nonatomic) SWRevealViewController *viewController;
@property (weak, nonatomic) IBOutlet UILabel *optLbl;

@property (weak, nonatomic) IBOutlet UITextField *otpTXT;
- (IBAction)verifyAction:(id)sender;
- (IBAction)resendOTPAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resendBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyOtpbtn;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLbl;

@end
