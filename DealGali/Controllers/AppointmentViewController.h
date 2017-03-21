//
//  AppointmentViewController.h
//  DealGali
//
//  Created by Virinchi Software on 24/05/16.
//  Copyright © 2016 Virinchi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JFMinimalNotification.h"

@interface AppointmentViewController : UIViewController<JFMinimalNotificationDelegate,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate>{
    
    UITextField* activeField;
    UITextView* activeTextView;
    UIDatePicker *datePicker;
    UIView *_inputAccView;
    BOOL   keyboardVisible;
    CGSize keyboardSize;
    BOOL active;
}

@property (nonatomic, strong) JFMinimalNotification* minimalNotification;

@property (weak, nonatomic) IBOutlet UIImageView *profileImgVw;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong) NSString *CustomId;
@property (nonatomic, strong) NSString *currentPageURL;
@property (nonatomic, strong) NSString *companyPage;
@property (nonatomic, strong) NSString *DealCompanyLogo;
@property (nonatomic, strong) NSString *DealTitle;

@property (strong, nonatomic) SWRevealViewController *viewController;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@property (weak, nonatomic) IBOutlet UITextField *emailTXT;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;

- (IBAction)termsNconditiosBtnAction:(id)sender;
- (IBAction)submitBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *writeTextView;

@property (weak, nonatomic) IBOutlet UITextField *pickDateTXT;
@property (weak, nonatomic) IBOutlet UITextField *pickDate1TXT;
@property (weak, nonatomic) IBOutlet UILabel *chooseLBL;
@property (weak, nonatomic) IBOutlet UILabel *contactInfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl;

@property (weak, nonatomic) IBOutlet UIButton *termBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitButtomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitHT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVwHT;

@end
